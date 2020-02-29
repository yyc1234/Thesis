% Call on this file to assign values to simulink model block parameters
%
% Update parameter list with block name (Case and space sensisitive) in the
% list below to change block parameters
%
% NOTES:
% * Initialize_parameters.m MUST be run in the beginng as it initializes
% variables used here
% * Name of each block in simulink model MUST be unique throughout ALL
% subsystems
%
% ========================================================================

% Assign values to simulink block parameters based on the list below


% Error checks

% Trajectory time not desfined for T <= 0    
if any(T_f <= 0)
    error('T_f should be > 0')
elseif any(abs(pf_abs) > 0.75) || any(abs(del_pf) > 0.25)
    error('Desired posotion greater than 75 cm away from p0, distance is too large')
elseif size(pf_abs,2)~= 12 || size(del_pf,2) ~= 12
    error('size of pf should be 1x12')
end


sat_matrix = sat_limits;
rate_matrix = rate_limits*[1,-1];

if any(sat_matrix(:,1) < sat_matrix(:,2))
    error('Saturation upper limit should be greater than lower limit')
elseif any(rate_matrix(:,1) < rate_matrix(:,2))
    error('Upper rate limit should be greater than lower limit')
end

% This list needs to be converted to a cell with strings, the values are
% converted to numbers during set_param

paramList = {'Saturation FR HF',num2str(sat_matrix(1,:));...
    'Saturation FR HS',num2str(sat_matrix(2,:));...
    'Saturation FR K',num2str(sat_matrix(3,:));...
    'Saturation FL HF',num2str(sat_matrix(4,:));...
    'Saturation FL HS',num2str(sat_matrix(5,:));...
    'Saturation FL K',num2str(sat_matrix(6,:));...
    'Saturation BR HF',num2str(sat_matrix(7,:));...
    'Saturation BR HS',num2str(sat_matrix(8,:));...
    'Saturation BR K',num2str(sat_matrix(9,:));...
    'Saturation BL HF',num2str(sat_matrix(10,:));...
    'Saturation BL HS',num2str(sat_matrix(11,:));...
    'Saturation BL K',num2str(sat_matrix(12,:));...
    'Rate Limiter FR HF',num2str(rate_matrix(1,:));...
    'Rate Limiter FR HS',num2str(rate_matrix(2,:));...
    'Rate Limiter FR K',num2str(rate_matrix(3,:));...
    'Rate Limiter FL HF',num2str(rate_matrix(4,:));...
    'Rate Limiter FL HS',num2str(rate_matrix(5,:));...
    'Rate Limiter FL K',num2str(rate_matrix(6,:));...
    'Rate Limiter BR HF',num2str(rate_matrix(7,:));...
    'Rate Limiter BR HS',num2str(rate_matrix(8,:));...
    'Rate Limiter BR K',num2str(rate_matrix(9,:));...
    'Rate Limiter BL HF',num2str(rate_matrix(10,:));...
    'Rate Limiter BL HS',num2str(rate_matrix(11,:));...
    'Rate Limiter BL K',num2str(rate_matrix(12,:));...
    'cubic_trajectory_rate_limiter',num2str(rate_matrix(13,:));...
    'qd_constant',num2str(qd_constant);
    'pf_abs',num2str(pf_abs);...
    'del_pf',num2str(del_pf);...
    'switch_pf_rel_abs',num2str(switch_pf_rel_abs);...
    'v0',num2str(v0);...
    'vf',num2str(vf);...
    'T_f',num2str(T_f);... 
    'Update_p0',num2str(Update_p0);...
    'reset_start_timer',num2str(reset_start_timer);
    'switch_to_dynamic',num2str(switch_to_dynamic);...
    'start_trot_in_place',num2str(start_trot_in_place);...
    'z_max',num2str(z_max);...
    'qd Sine FR HF',num2str(sine_wave_params(1,:));...
    'qd Sine FR HS',num2str(sine_wave_params(2,:));...
    'qd Sine FR K',num2str(sine_wave_params(3,:));...
    'qd Sine FL HF',num2str(sine_wave_params(4,:));...
    'qd Sine FL HS',num2str(sine_wave_params(5,:));...
    'qd Sine FL K',num2str(sine_wave_params(6,:));...
    'qd Sine BR HF',num2str(sine_wave_params(7,:));...
    'qd Sine BR HS',num2str(sine_wave_params(8,:));...
    'qd Sine BR K',num2str(sine_wave_params(9,:));...
    'qd Sine BL HF',num2str(sine_wave_params(10,:));...
    'qd Sine BL HS',num2str(sine_wave_params(11,:));...
    'qd Sine BL K',num2str(sine_wave_params(12,:));...
    };


% Match block name to list (needs to be an exact match to avoid errors)
for i = 1:numConstant
    % Split block path
    endout=regexp(constantBlockNames{i},'/','split');
    % Find index where names match block name (last entry of name after split)
    constantIndx = find(strcmp(paramList,endout{end}));
    
    % if names are not on the list the Indx variable will be empty, so
    % ignore it
    if ~isempty(constantIndx)
        % Get values that was set from the list stored in 2nd column
        constantVal = paramList{constantIndx,2};
        % input to set param must be a string, if the input is a vector the
        % string must include square brackets
        constantVal = ['[' constantVal ']'];
        
        % remove model name from block path, for use in set_param
        const_block_name = char(join(endout(1:end),'/'));
        
        % Set parameter on the block
        set_param(const_block_name,'Value',constantVal);
    end
end

% Gain blocks
for i = 1:numGain
    endout=regexp(gainBlockNames{i},'/','split');
    gainIndx = find(strcmp(paramList,endout{end}));
    
    if ~isempty(gainIndx)
        gainVal = paramList{gainIndx,2};
        gainVal = ['[' gainVal ']'];
        
        gain_block_name = char(join(endout(1:end),'/'));
        
        set_param(gain_block_name,'Gain',gainVal);
    end
end

% Saturation blocks
for i = 1:numSaturation
    endout=regexp(saturationBlockNames{i},'/','split');
    saturationIndx = find(strcmp(paramList,endout{end}));
    
    if ~isempty(saturationIndx)
        saturationLimits = str2num(paramList{saturationIndx,2});
        sat_block_name = char(join(endout(1:end),'/'));
        
        set_param(sat_block_name,'UpperLimit',num2str(saturationLimits(1)));
        set_param(sat_block_name,'LowerLimit',num2str(saturationLimits(2)));
    end
end

% Rate limit blocks
for i = 1:numRatelimit
    endout=regexp(ratelimitBlockNames{i},'/','split');
    ratelimitIndx = find(strcmp(paramList,endout{end}));
    
    if ~isempty(ratelimitIndx)
        rateLimits = str2num(paramList{ratelimitIndx,2});
        rate_block_name = char(join(endout(1:end),'/'));
        
        set_param(rate_block_name,'RisingSlewLimit',num2str(rateLimits(1)));
        set_param(rate_block_name,'FallingSlewLimit',num2str(rateLimits(2)));
    end
end

%Sine wave blocks
for i = 1:numSine
    endout=regexp(sineBlockNames{i},'/','split');
    sineIndx = find(strcmp(paramList,endout{end}));
    
    if ~isempty(sineIndx)
        sineVal = str2num(paramList{sineIndx,2});
        sine_block_name = char(join(endout(1:end),'/'));
        
        set_param(sine_block_name,'Amplitude',num2str(sineVal(1)));
        set_param(sine_block_name,'Bias',num2str(sineVal(2)));
        set_param(sine_block_name,'Frequency',num2str(sineVal(3)));
        set_param(sine_block_name,'Phase',num2str(sineVal(4)));
    end
end

% Pulse wave blocks 
for i = 1:numPulse
    endout=regexp(pulseBlockNames{i},'/','split');
    pulseIndx = find(strcmp(paramList,endout{end}));
    
    if ~isempty(pulseIndx)
        pulseVal = paramList{pulseIndx,2};
        pulse_block_name = char(join(endout(1:end),'/'));
        
        set_param(pulse_block_name,'Period',num2str(pulseVal(1)));
        set_param(pulse_block_name,'PhaseDelay',num2str(pulseVal(2)));
    end
end
