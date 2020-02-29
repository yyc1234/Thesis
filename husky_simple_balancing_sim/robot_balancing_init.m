Ts=0.001

init_position=[0,0,0.8]
desired_q=[0,0,0,0.6,0,0,0,0.6,0,0,0,0.6,0,0,0,0.6]
% Contact model parameters
% Normal force
c_k = 5e3;
c_b = 2e2;
% Friction
mu_k = 0.4;
mu_s = 0.8;
v_th = 0.0001; %m/s


roll=[0,0,0,0];
pitch=[0,0,0,0];
yaw=[0,0,0,0];
l=[0.6,0.6,0.6,0.6];
for i=1:4
    eval(['roll',num2str(i),'=roll(',num2str(i),');']);
    eval(['pitch',num2str(i),'=pitch(',num2str(i),');']);
    eval(['yaw',num2str(i),'=yaw(',num2str(i),');']);
    eval(['l',num2str(i),'=l(',num2str(i),');']);
end
