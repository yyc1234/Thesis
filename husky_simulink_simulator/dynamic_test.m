% p_a=[0;0;0];
% p_b=[1;0;0];
% p_c=[1;1;-1];
% p_c_local=[0;0;-sqrt(2)];
% T1=[1,0,0,1;0,1,0,0;0,0,1,0;0,0,0,1];
% R1=[1,0,0,0;0,cos(-pi/4),sin(-pi/4),0;0,-sin(-pi/4),cos(-pi/4),0;0,0,0,1];
% T2=[0,0,0,1;0,1,0,0;0,0,-sqrt(2),0;0,0,0,1];

trans.hipf.FL=[0.19745, 0.045, 0]';
trans.hipf.FR=[0.19745, -0.045, 0]';
trans.hipf.BL=[-0.19745, 0.045, 0]';
trans.hipf.BR=[-0.19745, -0.045, 0]';

trans.hips.FL=[-0.007, 0.053, 0]';
trans.hips.FR=[-0.007, -0.053, 0]';
trans.hips.BL=[-0.007, 0.053, 0]';
trans.hips.BR=[-0.007, -0.053, 0]';

trans.knee.FL=[0, 0, -0.158]';
trans.knee.FR=[0, 0, -0.158]';
trans.knee.BL=[0, 0, -0.158]';
trans.knee.BR=[0, 0, -0.158]';

trans.ankl.FL=[-0.333, 0.0075, 0]';
trans.ankl.FR=[-0.333, -0.0075, 0]';
trans.ankl.BL=[-0.333, 0.0075, 0]';
trans.ankl.BR=[-0.333, -0.0075, 0]';

trans.footend.FL=[0 0 -0.120]';
trans.footend.FR=[0 0 -0.120]';
trans.footend.BL=[0 0 -0.120]';
trans.footend.BR=[0 0 -0.120]';

% p_c2=get_new_pos(p_c_local,T1*R1);

%p_c2=get_new_pos([0;0;-1],rotm_x(pi/4));
% syms a
% rotm_x_h(a)*transm_h(1,2,3)
% rotm_y_h(a)
% rotm_x_h(a)
% leg_seq=['FL';'FR';'BL';'BR'];
leg_seq=['FR';'FL';'BR';'BL'];
joint_seq=['hipf';'hips';'knee';'ankl'];
rot_seq=['x','y','y','y','x','y','y','y','x','y','y','y','x','y','y','y'];
%input will be 16x1 vector of q1 to q12, in sequence of
%[q1,q2,q3,-q3,q4,q5,q6,-q6,q7,q8,q9,-q9,q10,q11,q12,-q12]
input=[];
for ii=1:12
    eval(['syms q',num2str(ii),';']);
    eval(['input=[input;q',num2str(ii),'];']);
end
input_ex=[input(1:3);-input(3);input(4:6);-input(6);input(7:9);-input(9);input(10:12);-input(12)];
unsigned_input_ex=[input(1:3);input(3);input(4:6);input(6);input(7:9);input(9);input(10:12);input(12)];


for ii =0:3
    leg_name=leg_seq(ii+1,:);
%     eval(['A_',leg_name,'=zeros(4,4,4);']);
    for jj=1:4 
        joint_num=4*ii+jj;
        joint_name=joint_seq(jj,:);
        eval(['Tm_',joint_name,'_',leg_name,'=transm_h(trans.',joint_name,'.',leg_name,')*rotm_',rot_seq(jj),'_h(input_ex(',num2str(joint_num),'));']);
    end
    eval(['T_hipf_',leg_name,'=Tm_hipf_',leg_name,';']);
    eval(['T_hips_',leg_name,'=T_hipf_',leg_name,'*Tm_hips_',leg_name,';']);
    eval(['T_knee_',leg_name,'=T_hips_',leg_name,'*Tm_knee_',leg_name,';']);
    eval(['T_ankl_',leg_name,'=T_knee_',leg_name,'*Tm_ankl_',leg_name,';']);
    eval(['p_foot_end_',leg_name,'=T_ankl_',leg_name,'*[trans.footend.',leg_name,';1];']);
    eval(['A_',leg_name,'(:,:,1)=T_hipf_',leg_name,';']);
    eval(['A_',leg_name,'(:,:,2)=T_hips_',leg_name,';']);
    eval(['A_',leg_name,'(:,:,3)=T_knee_',leg_name,';']);
    eval(['A_',leg_name,'(:,:,4)=T_ankl_',leg_name,';']);
end


direction=['right';'left ';'right';'left '];
leg_name_seq=['   hip_';' femur_';' tibia_';'tarsus_'];
for dd=1:2
    drt=direction(dd,:);
    eval(['inertia_Matrix_',drt,'=zeros(4,4,4);']);
    for ii=1:4
        leg_name=[leg_name_seq(ii,:),drt];
        eval(['leg=',leg_name,';']);
        m=getfield(leg,'mass');
        MomentsofInertia=getfield(leg,'MomentsofInertia');
        ProductsofInertia=getfield(leg,'ProductsofInertia');
        pCOM=getfield(leg,'pCOM');
        Ix=MomentsofInertia(1);
        Iy=MomentsofInertia(2);
        Iz=MomentsofInertia(3);
        Iyz=ProductsofInertia(1);
        Ixz=ProductsofInertia(2);
        Ixy=ProductsofInertia(3);
        x=pCOM(1);
        y=pCOM(2);
        z=pCOM(3);
        Inertia_Matrix_general=[(-Ix+Iy+Iz)/2,Ixy,Ixz,m*x;...
                                Ixy,(Ix-Iy+Iz)/2,Iyz,m*y;...
                                Ixz,Iyz,(Ix+Iy-Iz)/2,m*z;...
                                m*x,m*y,m*z,m];
        eval(['inertia_Matrix_',drt,'(:,:,ii)=Inertia_Matrix_general;']);
    end
end

number_of_links=4;

for leg_num = 1:4
    leg_name=leg_seq(leg_num,:);
    drt=direction(leg_num,:);
    for ii=1:4
        for jj=1:4
            H(ii,jj)=sym(0);
            for kk=1:max(ii,jj)
                qq1=unsigned_input_ex(4*(leg_num-1)+ii);
                qq2=unsigned_input_ex(4*(leg_num-1)+jj);
                eval(['JJ=inertia_Matrix_',drt,';']);
                eval(['Ak=A_',leg_name,'(:,:,kk);']);
                H(ii,jj)=H(ii,jj)+trace(diff(Ak,qq1)*JJ(:,:,kk)*diff(Ak',qq2));
                if (ii==4 || jj==4) && ii~=jj
                    H(ii,jj)=H(ii,jj)-trace(diff(Ak,qq1)*JJ(:,:,kk)*diff(Ak',qq2));
                end
            end
            H(ii,jj);
        end
    end
    eval(['H_',leg_name,'=simplify(H);']);
end
       
        
%         H(i,j) = simplify(tr);
%         H(j,i) = H(i,j);
%     end
% end



% a=0;
% b=0;
% c=0;
% 

% eval(subs(p_foot_end_FL,[q1,q2,q3],[a,b,c]))
% eval(subs(p_foot_end_FR,[q4,q5,q6],[a,b,c]))
% eval(subs(p_foot_end_BL,[q7,q8,q9],[a,b,c]))
% eval(subs(p_foot_end_BR,[q10,q11,q12],[a,b,c]))

% p1=Jacobian()

for leg_num=1:4
    num=3*(leg_num-1)+1;
    leg_name=leg_seq(leg_num,:);
    eval(['q=[q',num2str(num),',q',num2str(num+1),',q',num2str(num+2),',q',num2str(num+2),'];']);
    eval(['Jacobian_',leg_name,'=simplify(jacobian(p_foot_end_',leg_name,'(1:3),q)).*[1,1,1,-1];']);
%     eval(['Jacobian_',leg_name,'_trans=simplify(jacobian(p_foot_end_',leg_name,'(1:3)'',q)).*[1,1,1,-1];']);
end


function rotm=rotm_x_h(theta)
    rotm=[1,0,0,0;0,cos(theta),sin(theta),0;0,-sin(theta),cos(theta),0;0,0,0,1];
end

function rotm=rotm_y_h(theta)
    rotm=[cos(theta),0,sin(theta),0;0,1,0,0;-sin(theta),0,cos(theta),0;0,0,0,1];
end

function rotm=rotm_z_h(theta)
    rotm=[cos(theta),-sin(theta),0,0;sin(theta),cos(theta),0,0;0,0,1,0;0,0,0,1];
end

function T=transm_h(p)
    T=[1,0,0,p(1);0,1,0,p(2);0,0,1,p(3);0,0,0,1];
end

function new_pos=get_new_pos(old_pos,T)
    old_pos_h=[old_pos;1];
    new_pos_h=T*old_pos_h;
    new_pos=new_pos_h(1:3);
end



    

