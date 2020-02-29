
% [-0.072127,-0.0350,-0.42342,  -0.072127,0.0350,-0.42342,  - 0.172127,-0.0350,-0.43342,   -0.172127,0.0350,-0.43342]


set_path

sysName = 'husky_sim';

open('husky_sim.slx')


%%

time_sim = out.tout;
output_sim = out.simout;

GRF = output_sim(:,28:31);
F_fr = output_sim(:,32:43);

%==========================================================================
% Joint angles

fig_name = 'Joint_angle_FR_HF';
fig_num = 1;
figure(1)
subplot(1,3,1)
plot(time_sim, output_sim(:,1)*180/pi), 
% hold on
% plot(time_sim, output_sim(:,12*1+1)*180/pi)
% hold off
ylabel('angle (deg)')
xlabel('time (s)')
title('q_{FR, HF}')

subplot(1,3,2)
plot(time_sim, output_sim(:,2)*180/pi), 
% hold on
% plot(time_sim, output_sim(:,12*1+2)*180/pi)
% hold off
ylabel('angle (deg)')
xlabel('time (s)')
title('q_{FR, HS}')

subplot(1,3,3)
plot(time_sim, output_sim(:,3)*180/pi), 
% hold on
% plot(time_sim, output_sim(:,12*1+3)*180/pi)
% hold off
ylabel('angle (deg)')
xlabel('time (s)')
title('q_{FR, K}')

%-----------------------------------------------------------------------

figure(2)
subplot(1,3,1)
plot(time_sim, output_sim(:,4)*180/pi)
ylabel('angle (deg)')
xlabel('time (s)')
title('q_{FL, HF}')

subplot(1,3,2)
plot(time_sim, output_sim(:,5)*180/pi)
ylabel('angle (deg)')
xlabel('time (s)')
title('q_{FL, HS}')

subplot(1,3,3)
plot(time_sim, output_sim(:,6)*180/pi)
ylabel('angle (deg)')
xlabel('time (s)')
title('q_{FL, K}')

%-----------------------------------------------------------------------

figure(3)
subplot(1,3,1)
plot(time_sim, output_sim(:,7)*180/pi)
ylabel('angle (deg)')
xlabel('time (s)')
title('q_{BR, HF}')

subplot(1,3,2)
plot(time_sim, output_sim(:,8)*180/pi)
ylabel('angle (deg)')
xlabel('time (s)')
title('q_{BR, HS}')

subplot(1,3,3)
plot(time_sim, output_sim(:,9)*180/pi)
ylabel('angle (deg)')
xlabel('time (s)')
title('q_{BR, K}')

%-----------------------------------------------------------------------

figure(4)
subplot(1,3,1)
plot(time_sim, output_sim(:,10)*180/pi)
ylabel('angle (deg)')
xlabel('time (s)')
title('q_{BL, HF}')

subplot(1,3,2)
plot(time_sim, output_sim(:,11)*180/pi)
ylabel('angle (deg)')
xlabel('time (s)')
title('q_{BL, HS}')

subplot(1,3,3)
plot(time_sim, output_sim(:,12)*180/pi)
ylabel('angle (deg)')
xlabel('time (s)')
title('q_{BL, K}')

%==========================================================================
% Forces

figure(5)
subplot(2,2,1)
plot(time_sim, GRF(:,1))
ylabel('Force (N)')
xlabel('time (s)')
title('Normal force on FR leg')

subplot(2,2,2)
plot(time_sim, GRF(:,2))
ylabel('Force (N)')
xlabel('time (s)')
title('Normal force on FL leg')

subplot(2,2,3)
plot(time_sim, GRF(:,3))
ylabel('Force (N)')
xlabel('time (s)')
title('Normal force on BR leg')

subplot(2,2,4)
plot(time_sim, GRF(:,4))
ylabel('Force (N)')
xlabel('time (s)')
title('Normal force on BL leg')

%-----------------------------------------------------------------------

figure(6)
subplot(2,2,1)
plot(time_sim, F_fr(:,1)), hold on
plot(time_sim, F_fr(:,2)), hold off
ylabel('Force (N)')
xlabel('time (s)')
title('Friction forces on FR leg')
legend('x component','y component')

subplot(2,2,2)
plot(time_sim, F_fr(:,4)), hold on
plot(time_sim, F_fr(:,5)), hold off
ylabel('Force (N)')
xlabel('time (s)')
title('Friction forces on FL leg')
legend('x component','y component')

subplot(2,2,3)
plot(time_sim, F_fr(:,7)), hold on
plot(time_sim, F_fr(:,8)), hold off
ylabel('Force (N)')
xlabel('time (s)')
title('Friction forces on BR leg')
legend('x component','y component')

subplot(2,2,4)
plot(time_sim, F_fr(:,10)), hold on
plot(time_sim, F_fr(:,11)), hold off
ylabel('Force (N)')
xlabel('time (s)')
title('Friction forces on BL leg')
legend('x component','y component')

%%
% Animate support triangle and COM
time_sim = out.tout;
output_sim = out.simout;
output_COM_pos = out.COM_leg_positions;

p_body = output_sim(:,25:27);

leg_end_pos = output_COM_pos(:,1:12);

FR_end = leg_end_pos(:,1:3);
FL_end = leg_end_pos(:,4:6);
BR_end = leg_end_pos(:,7:9);
BL_end = leg_end_pos(:,10:12);

COM_curr = output_COM_pos(:,13:15);
COM_des = output_COM_pos(:,16:18);

skip = round(0.008/0.002);

fh = figure(10);
set(fh,'Name','COM and support triangle location',...
    'Renderer','opengl',...
    'GraphicsSmoothing','on');
ah = axes('Box','on',...
    'XGrid','off',...
    'YGrid','off',...
    'DataAspectRatio',[1,1,1],...
    'PlotBoxAspectRatio',[1,1,1],...
    'Parent',fh);
xlabel(ah,'[m]');
ylabel(ah,'[m]');
xlim(ah,[-0.6, 0.6]);
ylim(ah,[-0.4 0.4]);

 hold(ah,'off'); % To animate
 
 LineWidth = 0.5;
 MarkerSize = 5;
 LineWidth_marker = 3;

for i = 1:skip:length(time_sim)
    
    % Clear figure
    cla(ah);
    
    % triangle
    line(ah, [FR_end(i,1), BR_end(i,1)],[FR_end(i,2), BR_end(i,2)],'Color','k','LineStyle','-.','LineWidth', LineWidth)
    line(ah, [FR_end(i,1), BL_end(i,1)],[FR_end(i,2), BL_end(i,2)],'Color','k','LineStyle','-.','LineWidth', LineWidth)
    line(ah, [BR_end(i,1), BL_end(i,1)],[BR_end(i,2), BL_end(i,2)],'Color','k','LineStyle','-.','LineWidth', LineWidth)
    
    % leg ends
    line(ah, [FR_end(i,1), FR_end(i,1)],[FR_end(i,2), FR_end(i,2)],'Color','y','Marker','o','MarkerSize',MarkerSize,'LineWidth', LineWidth)
    line(ah, [FL_end(i,1), FL_end(i,1)],[FL_end(i,2), FL_end(i,2)],'Color','g','Marker','o','MarkerSize',MarkerSize,'LineWidth', LineWidth)
    line(ah, [BR_end(i,1), BR_end(i,1)],[BR_end(i,2), BR_end(i,2)],'Color','g','Marker','o','MarkerSize',MarkerSize,'LineWidth', LineWidth)
    line(ah, [BL_end(i,1), BL_end(i,1)],[BL_end(i,2), BL_end(i,2)],'Color','b','Marker','o','MarkerSize',MarkerSize,'LineWidth', LineWidth)
    
    % body p_body
%     line(ah, [p_body(i,1), p_body(i,1)],[p_body(i,2), p_body(i,2)],'Color','k','Marker','x','MarkerSize',MarkerSize,'LineWidth', LineWidth)
    
    % COM
    line(ah, [COM_curr(i,1), COM_curr(i,1)],[COM_curr(i,2), COM_curr(i,2)],'Color','k','Marker','o','MarkerSize',MarkerSize,'LineWidth', LineWidth_marker)
    line(ah, [COM_des(i,1), COM_des(i,1)],[COM_des(i,2), COM_des(i,2)],'Color','r','Marker','o','MarkerSize',MarkerSize,'LineWidth', LineWidth_marker)
    
    %drawnow limitrate
    pause(0.01);
    
end
