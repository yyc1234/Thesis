% Contact model parameters
% Normal force
c_k = 5e3;
c_b = 2e2;
% Friction
% mu_k = 0.7;
% mu_s = 0.5;
mu_k = 0.4;
mu_s = 0.8;
v_th = 0.0001; %m/s
%-------------controller---------------------------------
Kp1=100;
Kv1=5;
Kp2=100;
Kv2=5;
q_desired=[-60;0;120;0].*pi/180;

%-----------------------------------------------

%pen init
l1=0.4;
l2=0.4;
pen1_initangle=-60;
pen2_initangle=120;
link1.pCOM=[0, 0, -0.4];
link1.mass=2.2337;
link1.MomentsofInertia=[0.0298385, 0.0298385, 0.000111685];
link1.ProductsofInertia=[0 0 0];

link2.pCOM=[0, 0, -0.4];
link2.mass=2.2337;
link2.MomentsofInertia=[0.0298385, 0.0298385, 0.000111685];
link2.ProductsofInertia=[0 0 0];

m=link1.mass;
pCOM=link1.pCOM;
Ix=link1.MomentsofInertia(1);
Iy=link1.MomentsofInertia(2);
Iz=link1.MomentsofInertia(3);
Iyz=link1.ProductsofInertia(1);
Ixz=link1.ProductsofInertia(2);
Ixy=link1.ProductsofInertia(3);
x=link1.pCOM(1);
y=link1.pCOM(2);
z=link1.pCOM(3);
J_pen1=[(-Ix+Iy+Iz)/2,Ixy,Ixz,m*x;...
        Ixy,(Ix-Iy+Iz)/2,Iyz,m*y;...
        Ixz,Iyz,(Ix+Iy-Iz)/2,m*z;...
        m*x,m*y,m*z,m];
 
m=link2.mass;   
pCOM=link2.pCOM;
Ix=link2.MomentsofInertia(1);
Iy=link2.MomentsofInertia(2);
Iz=link2.MomentsofInertia(3);
Iyz=link2.ProductsofInertia(1);
Ixz=link2.ProductsofInertia(2);
Ixy=link2.ProductsofInertia(3);
x=link2.pCOM(1);
y=link2.pCOM(2);
z=link2.pCOM(3);
J_pen2=[(-Ix+Iy+Iz)/2,Ixy,Ixz,m*x;...
        Ixy,(Ix-Iy+Iz)/2,Iyz,m*y;...
        Ixz,Iyz,(Ix+Iy-Iz)/2,m*z;...
        m*x,m*y,m*z,m];
    
syms theta1 theta2 dq1 dq2 dt
T1=[1,0,0,0;0,cos(theta1),sin(theta1),0;0,-sin(theta1),cos(theta1),0;0,0,0,1];
T2=T1*[1,0,0,0;0,1,0,0;0,0,1,-0.4;0,0,0,1]*[1,0,0,0;0,cos(theta2),sin(theta2),0;0,-sin(theta2),cos(theta2),0;0,0,0,1];
p=T2*[0;0;-0.4;1];
p=p(1:3);
dA1dq1=diff(T1,theta1);
dA1dq2=diff(T1,theta2);
dA2dq1=diff(T2,theta1);
dA2dq2=diff(T2',theta2);
q=[theta1;theta2];
J=simplify(jacobian(p,q))



H_pen(1,1)=trace(dA1dq1*J_pen1*dA1dq1')+trace(dA2dq1*J_pen1*dA2dq1');
H_pen(1,2)=trace(dA2dq1*J_pen2*dA2dq2');
H_pen(2,1)=trace(dA2dq2*J_pen2*dA2dq1');
H_pen(2,2)=trace(dA2dq2*J_pen2*dA2dq2');

H_pen=simplify(H_pen);
q_pen=[theta1 theta2];
dq_pen=[dq1 dq2];
for ii=1:2
    for jj=1:2
        C_pen(ii,jj)=sym(0);
        for kk=1:2
            C_pen(ii,jj)=C_pen(ii,jj)+0.5*(diff(H_pen(ii,jj),q_pen(kk))+diff(H_pen(ii,kk),q_pen(jj))+diff(H_pen(jj,kk),q_pen(ii)))*dq_pen(kk);
        end
    end
end
C_pen=simplify(C_pen)
gg=[0;0;-9.8;0];
pCOM1=[link1.pCOM,1]';
pCOM2=[link2.pCOM,1]';
G(1,1)=link1.mass*gg'*dA1dq1*pCOM1+link2.mass*gg'*dA2dq1*pCOM2;
G(2,1)=link1.mass*gg'*dA1dq2*pCOM1+link2.mass*gg'*dA2dq2*pCOM2;
G=simplify(G)
