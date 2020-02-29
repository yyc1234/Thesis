% Intialize all block parameters in simulink model
%
% by Pravin Dangol, 10/01/19, Boston MA
%
% Note: name of each block in simulink model MUST be unique throughout ALL
% subsystems
%
%==================================================================
% Set values here, MUST BE set to zeros at start up

set_path

sysName = 'husky_sim';

% Saturation limits in radians
%  MUST follow the following format: [UpperLimit, LowerLimit]
%   Currently set to physical limits, based on recorded data
sat_limits_FR_hip_frontal = 1*[90, -30]*pi/180;
sat_limits_FR_hip_sagittal = 1*[90, -90]*pi/180;
sat_limits_FR_knee = 1*[60, -60]*pi/180;
sat_limits_FL_hip_frontal = 1*[90,-30]*pi/180;
sat_limits_FL_hip_sagittal = 1*[90, -90]*pi/180;
sat_limits_FL_knee = 1*[60, -60]*pi/180;
sat_limits_BR_hip_frontal = 1*[90, -30]*pi/180;
sat_limits_BR_hip_sagittal = 1*[90, -90]*pi/180;
sat_limits_BR_knee = 1*[60, -60]*pi/180;
sat_limits_BL_hip_frontal = 1*[90, -30]*pi/180;
sat_limits_BL_hip_sagittal = 1*[90, -90]*pi/180;
sat_limits_BL_knee = 1*[60, -60]*pi/180;

% Rate limits in rad/s 
% ENTER SINGLE VALUE, this is multiplied by [1, -1] later to give:
%       [RisingSlewLimit FallingSlewLimit]
rate_limits_FR_hip_frontal = 2000*pi/180;
rate_limits_FR_hip_sagittal = 2000*pi/180;
rate_limits_FR_knee = 2000*pi/180;
rate_limits_FL_hip_frontal = 2000*pi/180;
rate_limits_FL_hip_sagittal = 2000*pi/180;
rate_limits_FL_knee = 2000*pi/180;
rate_limits_BR_hip_frontal = 2000*pi/180;
rate_limits_BR_hip_sagittal = 2000*pi/180;
rate_limits_BR_knee = 2000*pi/180;
rate_limits_BL_hip_frontal = 2000*pi/180;
rate_limits_BL_hip_sagittal = 2000*pi/180;
rate_limits_BL_knee = 2000*pi/180;


% Sine parameters must be seperated as: [Amplitude, Bias, Frequency, Phase]
qd_sine_FR_HF_params = [0, 0, 2*pi, 0*2*pi];
qd_sine_FR_HS_params = [0, 0, 2*pi, 0*2*pi];
qd_sine_FR_K_params = [0, 0, 2*pi, 0*2*pi];
qd_sine_FL_HF_params = [0, 0, 2*pi, 0*2*pi];
qd_sine_FL_HS_params = [0, 0, 2*pi, 0*2*pi];
qd_sine_FL_K_params = [0, 0, 2*pi, 0*2*pi];
qd_sine_BR_HF_params = [0, 0, 2*pi, 0*2*pi];
qd_sine_BR_HS_params = [0, 0, 2*pi, 0*2*pi];
qd_sine_BR_K_params = [0, 0, 2*pi, 0*2*pi];
qd_sine_BL_HF_params = [0, 0, 2*pi, 0*2*pi];
qd_sine_BL_HS_params = [0, 0, 2*pi, 0*2*pi];
qd_sine_BL_K_params = [0, 0, 2*pi, 0*2*pi];

% Desired values for all angles in robot convention
qd_constant = [0,0,0,0,0,0,0,0,0,0,0,0];

% Starting leg end positions, initiated at startup configuration
%
% The following values are obtained from forward kinemtics, assuming all
% legs have origins at their respective hip frontal motors (origin)
%   y coordinate of right legs are negative and positve for left leg
%   (relative to their origins)
p0 = [0.072127,-0.0350,-0.45342,...
  	  0.072127,0.0350,-0.45342,...
      0.072127,-0.0350,-0.45342,...
      0.072127,0.0350,-0.45342];
     
% [0.072127,-0.0350,-0.45342,   0.072127,0.0350,-0.45342,   0.072127,-0.0350,-0.45342,   0.072127,0.0350,-0.45342]

% Set values for cubic trajectory

% final position of trajectory intially set to be same as initial, this
% forces the coefficients of trajectory to be zeros
pf_abs = p0;
del_pf = [0,0,0, 0.1,0.1,0.2, 0,0,0,0,0,0];

% start with relative pf
%   0 uses relative motion to p0_current
%   1 uses abolute relative to p0_absolute
switch_pf_rel_abs = 0;

 % Initiual and final velocities for trajectories
v0 = [0,0,0,0,0,0,0,0,0,0,0,0];
vf = [0,0,0,0,0,0,0,0,0,0,0,0];

% TIme needed to rech end point for each leg [FR,FL, BR, BL]
T_f = 5;

%===============================================================

% manually update p0 by sampling from encoder FK
Update_p0 = 0;

% Rate limit for trajectory, rising and falling, start at 1 - otherwise
% input for IK is 0 which represents end effector locations at [0,0,0]
% i.e. hip frontal motor location 
cubic_trajectory_rate_limiter = 0.6;

% Reset or start timer for trajectory
%   set to 0 to reset, output will be a constant 0 (default)
%   set to 1 to start timer, for dynamic or trasition trajectory
reset_start_timer = 1;
% Switch between transition or dynamic gait
%   set to 0 for transition (default)
%   set to 1 for dynamic
switch_to_dynamic = 0;

%===============================================================
% Trot in place

start_trot_in_place = 0;

z_max = 0.05;



%==================================================================

% load simulink model and look for all constant and gain blocks,
%   the names of the blocks are stored as cell arrays
% Note: This needs to be done using the simulink model because find_system 
% cannot handle target objects
%   To find BlockType name used by simulink, find the full path of block
%       blockPath = find_system(sysName,'LookUnderMasks','all','Type','Block')
%       get_param(blockPath{i},'BlockType')
%           where i the block path of interest
%
% sysName = 'robot_mdl';
%
load_system(sysName)
constantBlockNames = find_system(sysName,'LookUnderMasks','all','BlockType','Constant');
numConstant = size(constantBlockNames,1);

gainBlockNames = find_system(sysName,'LookUnderMasks','all','BlockType','Gain');
numGain = size(gainBlockNames,1);

saturationBlockNames = find_system(sysName,'LookUnderMasks','all','BlockType','Saturate');
numSaturation = size(saturationBlockNames,1);

ratelimitBlockNames = find_system(sysName,'LookUnderMasks','all','BlockType','RateLimiter');
numRatelimit = size(ratelimitBlockNames,1);

sineBlockNames = find_system(sysName,'LookUnderMasks','all','BlockType','Sin');
numSine = size(sineBlockNames,1);

pulseBlockNames = find_system(sysName,'LookUnderMasks','all','BlockType','DiscretePulseGenerator');
numPulse = size(pulseBlockNames,1);

% =====================================================================
% Organizing in matrices, these will be passed on to set_param_values.m 

sat_limits = [sat_limits_FR_hip_frontal;...
    sat_limits_FR_hip_sagittal;...
    sat_limits_FR_knee;...
    sat_limits_FL_hip_frontal;...
    sat_limits_FL_hip_sagittal;...
    sat_limits_FL_knee;...
    sat_limits_BR_hip_frontal;...
    sat_limits_BR_hip_sagittal;...
    sat_limits_BR_knee;...
    sat_limits_BL_hip_frontal;...
    sat_limits_BL_hip_sagittal;...
    sat_limits_BL_knee];

rate_limits = [rate_limits_FR_hip_frontal;...
    rate_limits_FR_hip_sagittal;...
    rate_limits_FR_knee;...
    rate_limits_FL_hip_frontal;...
    rate_limits_FL_hip_sagittal;...
    rate_limits_FL_knee;...
    rate_limits_BR_hip_frontal;...
    rate_limits_BR_hip_sagittal;...
    rate_limits_BR_knee;...
    rate_limits_BL_hip_frontal;...
    rate_limits_BL_hip_sagittal;...
    rate_limits_BL_knee;...
    cubic_trajectory_rate_limiter];

sine_wave_params = [qd_sine_FR_HF_params;...
    qd_sine_FR_HS_params;...
    qd_sine_FR_K_params;...
    qd_sine_FL_HF_params;...
    qd_sine_FL_HS_params;...
    qd_sine_FL_K_params;...
    qd_sine_BR_HF_params;...
    qd_sine_BR_HS_params;...
    qd_sine_BR_K_params;...
    qd_sine_BL_HF_params;...
    qd_sine_BL_HS_params;...
    qd_sine_BL_K_params];

% =====================================================================
% Call on this file to assign values to simulink model block parameters set
% above
set_block_param_on_sim
