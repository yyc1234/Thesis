



number_of_links=4;

for ii = 1:4
    leg_name=
    for jj = ii:number_of_links
        
            
    end
        Ak=A(:,:,k)
        H(i,j) = simplify(tr);
        H(j,i) = H(i,j);
    end
end


% function Inertia_Matrix_general=get_Inertia_Matrix_general(name)
%    
% end
% %C
% for i = 1:number_of_links
%     for j = 1:number_of_links
%         c = 0;
%         for k = 1:number_of_links
%             c = c + 1/2*(eval(['diff(H(i,j),q',num2str(k),')'])...
%                         + eval(['diff(H(i,k),q',num2str(j),')'])...
%                         - eval(['diff(H(j,k),q',num2str(i),')']))*eval(['dq',num2str(k)]);
%         end
%         C(i,j) = simplify(c);
%     end
% end
% 
% 
% g = [0,0,-gc,0]';
% 
% % ??G(q)
% for i = 1:number_of_links
%     gi = 0;
%     for j = 1:number_of_links
%         gi = gi - mass_list(j)*g'...
%                 *eval(['diff(A0(:,:,j),q',num2str(i),')'])...
%                 *[mass_center_list(j,:),1]';
%     end
%     G(i) = simplify(gi);
% end
% G = G';