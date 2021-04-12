function [params, nonspecific, base_cfg, hard_cfg] = initializeReqParameters()

%% Parameters not specific to base/hard scenarios
% Step size for Simulink model
nonspecific.fixedStepSize = 0.04;

% Underlying assumption: _req and _act belonging to the same .slx file have
% the same evaluation times
% Example: ADA_req has evaluation time [0 10], meaning the formula is 
%   alw_[0, 10](...)
nonspecific.ADA_evalTime = [0 10];
nonspecific.ADI_evalTime = [0 10];
nonspecific.AFE_evalTime = [0 10];
nonspecific.AOT_evalTime = [0 10];
nonspecific.ARCH_AT1_evalTime = [0 20];
nonspecific.ARCH_AT2_evalTime = [0 10];
nonspecific.ARCH_AT51_evalTime = [0 30];
nonspecific.ARCH_AT52_evalTime = [0 30];
nonspecific.ARCH_AT53_evalTime = [0 30];
nonspecific.ARCH_AT54_evalTime = [0 30];
nonspecific.ARCH_AT6a_evalTime = [0 30];
nonspecific.ARCH_AT6b_evalTime = [0 30];
nonspecific.ARCH_AT6c_evalTime = [0 30];
nonspecific.ASL_evalTime = [0 10];
nonspecific.BTL_evalTime = [0 10];
nonspecific.RFC_evalTime = [0 10];

% Assign the non-specific parameter values in base workspace
cellfun(@(c)(assignin('base', c, nonspecific.(c))), fieldnames(nonspecific));

%% Initialize parameter values for Volvo-inspired specifications

% ADA
base_cfg.ADA_req.ADA_notAlwaysHorizon = 1;
base_cfg.ADA_req.ADA_subsystem1_rpmLimit = 2000;
base_cfg.ADA_req.ADA_subsystem1_timeHorizon = 0.2;
base_cfg.ADA_req.ADA_subsystem2_throttleMin = 50;
base_cfg.ADA_req.ADA_subsystem2_impellerMin = 400;
base_cfg.ADA_req.ADA_subsystem2_impellerMax = 50;
base_cfg.ADA_req.ADA_subsystem3_gear = 3;
base_cfg.ADA_req.ADA_subsystem3_gearSelectionState = 2;
base_cfg.ADA_req.ADA_subsystem3_speedMin = 65;
base_cfg.ADA_req.ADA_subsystem3_speedMax = 70;
base_cfg.ADA_req.ADA_subsystem2_gear1 = 3;
base_cfg.ADA_req.ADA_subsystem2_gear2 = 4;
base_cfg.ADA_req.ADA_subsystem2_maxValue = 4;

base_cfg.ADA_act = base_cfg.ADA_req;

hard_cfg.ADA_req.ADA_subsystem3_speedMin = [69.9 65];
hard_cfg.ADA_req.ADA_subsystem2_maxValue = [4 240];

hard_cfg.ADA_act.ADA_subsystem3_speedMin = 67.2;

% ADI
base_cfg.ADI_req.ADI_notAlwaysHorizon = 0.1;
base_cfg.ADI_req.ADI_notAlways1Horizon = 0.2;
base_cfg.ADI_req.ADI_outputTorqueBound = 200;
base_cfg.ADI_req.ADI_evChangesDuration = 5;
base_cfg.ADI_req.ADI_subsystem1_gearOption1 = 1;
base_cfg.ADI_req.ADI_subsystem1_gearOption2 = 3;
base_cfg.ADI_req.ADI_subsystem1_speedThreshold = 50;
base_cfg.ADI_req.ADI_subsystem1_downThreshold1 = 0;
base_cfg.ADI_req.ADI_subsystem1_downThreshold2 = 5;
base_cfg.ADI_req.ADI_subsystem1_downThreshold3 = 20;
base_cfg.ADI_req.ADI_subsystem1_downThreshold4 = 35;
base_cfg.ADI_req.ADI_subsystem1_evChangesDuration = 0.1;
base_cfg.ADI_req.ADI_subsystem2_evChangesDuration = 0.5;
base_cfg.ADI_req.ADI_subsystem2_gear1 = 3;
base_cfg.ADI_req.ADI_subsystem2_gear2 = 4;
base_cfg.ADI_req.ADI_subsystem2_speedMin = 40;
base_cfg.ADI_req.ADI_subsystem2_notAlwaysHorizon = 1.5;
base_cfg.ADI_req.ADI_subsystem3_downThreshold = 20;
base_cfg.ADI_req.ADI_subsystem3_upThreshold = 50;
base_cfg.ADI_req.ADI_subsystem3_gear = 1;
base_cfg.ADI_req.ADI_subsystem3_gearSelectionState = 2;
base_cfg.ADI_req.ADI_subsystem3_RPM = 500;
base_cfg.ADI_req.ADI_subsystem3_impellerTorque = 200;
base_cfg.ADI_req.ADI_subsystem4_gear = 4;
base_cfg.ADI_req.ADI_subsystem4_downThreshold = 80;
base_cfg.ADI_req.ADI_subsystem4_RPM = 4000;
base_cfg.ADI_req.ADI_subsystem4_throttle = 70;
base_cfg.ADI_req.ADI_subsystem4_gearSelectionState = 3;
base_cfg.ADI_req.ADI_subsystem4_upThreshold = 100;
base_cfg.ADI_req.ADI_subsystem4_notAlwaysHorizon = 2;
base_cfg.ADI_req.ADI_subsystem4_notAlways1Horizon = 2.8;
base_cfg.ADI_req.ADI_subsystem5_speedThreshold = 50;
base_cfg.ADI_req.ADI_subsystem5_notAlwaysHorizon = 0.1;
base_cfg.ADI_req.ADI_subsystem5_evChangesDuration = 0.1;
base_cfg.ADI_req.ADI_subsystem5_evChanges1Duration = 0.1;

base_cfg.ADI_act1 = base_cfg.ADI_req;
base_cfg.ADI_act2 = base_cfg.ADI_req;
base_cfg.ADI_act3 = base_cfg.ADI_req;


% AFE
base_cfg.AFE_req.AFE_speedMin = 50;
base_cfg.AFE_req.AFE_downThreshold = 27;
base_cfg.AFE_req.AFE_subsystem1_gear = 3;
base_cfg.AFE_req.AFE_subsystem1_gearSelectionState = 1;
base_cfg.AFE_req.AFE_subsystem1_upThreshold1 = 40;
base_cfg.AFE_req.AFE_subsystem1_upThreshold2 = 60;
base_cfg.AFE_req.AFE_subsystem1_downThreshold = 20;
base_cfg.AFE_req.AFE_subsystem1_notAlwaysTimeHorizon = 0.1;

base_cfg.AFE_act = base_cfg.AFE_req;

hard_cfg.AFE_req.AFE_speedMin = [59 50];
hard_cfg.AFE_req.AFE_subsystem1_notAlwaysTimeHorizon = [0.1 5];

hard_cfg.AFE_act.AFE_downThreshold = 29.8;

% AOT
base_cfg.AOT_req.AOT_gear = 3;
base_cfg.AOT_req.AOT_gearSelectionState = 1;
base_cfg.AOT_req.AOT_notAlwaysHorizon = 1;
base_cfg.AOT_req.AOT_evChangesDuration = 0.1;
base_cfg.AOT_req.AOT_rpmLimit = 2000;
base_cfg.AOT_req.AOT_speedLimit = 70; 

base_cfg.AOT_act = base_cfg.AOT_req;

hard_cfg.AOT_req.AOT_speedLimit = [89 70];
hard_cfg.AOT_req.AOT_rpmLimit = [2000 4200];


% ASL
base_cfg.ASL_req.ASL_resetCounterMax = 0.1;
base_cfg.ASL_req.ASL_subsystem1_speedThreshold = 80;
base_cfg.ASL_req.ASL_subsystem1_gear = 2;
base_cfg.ASL_req.ASL_subsystem1_notAlwaysHorizon = 0.2;
base_cfg.ASL_req.ASL_subsystem2_gear = 2;
base_cfg.ASL_req.ASL_subsystem2_gear2 = 3;
base_cfg.ASL_req.ASL_subsystem2_upThreshold1 = 0;
base_cfg.ASL_req.ASL_subsystem2_upThreshold2 = 10;
base_cfg.ASL_req.ASL_subsystem2_notAlwaysHorizon = 0.08;
base_cfg.ASL_req.ASL_subsystem2_TorqueValue = 0;

base_cfg.ASL_act = base_cfg.ASL_req;

hard_cfg.ASL_act.ASL_subsystem2_TorqueValue = 0.7;

% BTL
base_cfg.BTL_req.BTL_subsystem1_speedLimit = 10;
base_cfg.BTL_req.BTL_subsystem1_rpmLimit = 1500;
base_cfg.BTL_req.BTL_sub1Value = 2;
base_cfg.BTL_req.BTL_sub1Value2 = 4;
base_cfg.BTL_req.BTL_preconditionSpeedLim = 20;
base_cfg.BTL_req.BTL_preconditionGear = 1;
base_cfg.BTL_req.BTL_preconditionSub1Value = 2;
base_cfg.BTL_req.BTL_preconditionSub1Value2 = 4;
base_cfg.BTL_req.BTL_evChangesTime = 4;
base_cfg.BTL_req.BTL_notAlwaysTime = 0.04;
base_cfg.BTL_req.BTL_notAlwaysTime2 = 5;
base_cfg.BTL_req.BTL_rpmLimit = 4700;

base_cfg.BTL_act1 = base_cfg.BTL_req;
base_cfg.BTL_act2 = base_cfg.BTL_req;

hard_cfg.BTL_req.BTL_subsystem1_rpmLimit = 590;

hard_cfg.BTL_act1.BTL_preconditionSpeedLim = 10;

hard_cfg.BTL_act2.BTL_subsystem1_rpmLimit = 590;

% RFC
base_cfg.RFC_req.RFC_gearState = 1;
base_cfg.RFC_req.RFC_notAlwaysTime = 0.04;
base_cfg.RFC_req.RFC_subsystem1_gearState = 2;
base_cfg.RFC_req.RFC_subsystem1_downThreshold1 = 500;
base_cfg.RFC_req.RFC_subsystem1_downThreshold2 = 20;
base_cfg.RFC_req.RFC_subsystem1_evChangesTime = 1;
base_cfg.RFC_req.RFC_subsystem1_evChangesTime2 = 1;
base_cfg.RFC_req.RFC_subsystem1_notAlwaysTime = 0.08;
base_cfg.RFC_req.RFC_subsystem1_rpmLimit = 3000;
base_cfg.RFC_req.RFC_subsystem1_torqueLimit = 1000;
base_cfg.RFC_req.RFC_subsystem1_gear = 1;
base_cfg.RFC_req.RFC_preconditions_speedLimit = 50;
base_cfg.RFC_req.RFC_preconditions_rpmLimit = 2500;
base_cfg.RFC_req.RFC_preconditions_torqueLimit = 5;
base_cfg.RFC_req.RFC_preconditions_gear = 1;
base_cfg.RFC_req.RFC_preconditions_throttleLimit = 80;

base_cfg.RFC_act = base_cfg.RFC_req;

hard_cfg.RFC_req.RFC_subsystem1_evChangesTime = 3;
hard_cfg.RFC_act.RFC_notAlwaysTime = 0.12;

%% Initialize parameter values for ARCH benchmarks

% AT1
base_cfg.ARCH_AT1_req.ARCH_AT1_speedLimit = 120;
base_cfg.ARCH_AT1_req.ARCH_AT1_speedLimitAct = 100;
base_cfg.ARCH_AT1_act = base_cfg.ARCH_AT1_req;
hard_cfg.ARCH_AT1_req.ARCH_AT1_speedLimit = 130;
hard_cfg.ARCH_AT1_act.ARCH_AT1_speedLimit = 110;


% AT2
base_cfg.ARCH_AT2_req.ARCH_AT2_rpmLimit = 4750;
base_cfg.ARCH_AT2_req.ARCH_AT2_rpmLimitAct = 4250;

base_cfg.ARCH_AT2_act = base_cfg.ARCH_AT2_req;

% AT51
base_cfg.ARCH_AT51_req.ARCH_AT51_timeHorizon = 2.5;

base_cfg.ARCH_AT51_act = base_cfg.ARCH_AT51_req;

% AT52
base_cfg.ARCH_AT52_req.ARCH_AT52_timeHorizon = 2.5;

base_cfg.ARCH_AT52_act = base_cfg.ARCH_AT52_req;

% AT53
base_cfg.ARCH_AT53_req.ARCH_AT53_timeHorizon = 2.5;

base_cfg.ARCH_AT53_act = base_cfg.ARCH_AT53_req;

% AT54
base_cfg.ARCH_AT54_req.ARCH_AT54_timeHorizon = 2.5;

base_cfg.ARCH_AT54_act = base_cfg.ARCH_AT54_req;

% AT6a
base_cfg.ARCH_AT6a_req.ARCH_AT6a_rpmThreshold = 3000;
base_cfg.ARCH_AT6a_req.ARCH_AT6a_rpmStartTime = 0;
base_cfg.ARCH_AT6a_req.ARCH_AT6a_rpmEndTime = 30;
base_cfg.ARCH_AT6a_req.ARCH_AT6a_speedThreshold = 35;
base_cfg.ARCH_AT6a_req.ARCH_AT6a_speedStartTime = 0;
base_cfg.ARCH_AT6a_req.ARCH_AT6a_speedEndTime = 4;

base_cfg.ARCH_AT6a_act = base_cfg.ARCH_AT6a_req;

% AT6b
base_cfg.ARCH_AT6b_req.ARCH_AT6b_rpmThreshold = 3000;
base_cfg.ARCH_AT6b_req.ARCH_AT6b_rpmStartTime = 0;
base_cfg.ARCH_AT6b_req.ARCH_AT6b_rpmEndTime = 30;
base_cfg.ARCH_AT6b_req.ARCH_AT6b_speedThreshold = 50;
base_cfg.ARCH_AT6b_req.ARCH_AT6b_speedStartTime = 0;
base_cfg.ARCH_AT6b_req.ARCH_AT6b_speedEndTime = 8;

base_cfg.ARCH_AT6b_act = base_cfg.ARCH_AT6b_req;

% AT6c
base_cfg.ARCH_AT6c_req.ARCH_AT6c_rpmThreshold = 3000;
base_cfg.ARCH_AT6c_req.ARCH_AT6c_rpmStartTime = 0;
base_cfg.ARCH_AT6c_req.ARCH_AT6c_rpmEndTime = 30;
base_cfg.ARCH_AT6c_req.ARCH_AT6c_speedThreshold = 65;
base_cfg.ARCH_AT6c_req.ARCH_AT6c_speedStartTime = 0;
base_cfg.ARCH_AT6c_req.ARCH_AT6c_speedEndTime = 20;

base_cfg.ARCH_AT6c_act = base_cfg.ARCH_AT6c_req;

%% Artificial thresholds
% The following are thresholds used for the "artificial" inptus added in
% "AT_and_specifications_artificial". 
% Each input has the range [0 100], so setting a threshold to 10 will make
% only 10% of falsified cases falsify also the artificial requirement. 

% Example:
% ADA_req has two "artificial" constants connected to it. The requirement
% ADA_art is 
% (ADA_req) or 
%   (artificial_ADA <= artificial_ADA_constant) or
%   (artificial_ASL_ADA <= artificial_ASL_ADA_constant)
% To falsify this, if both constants are 10, ADA_art should only
% be falsified for around 1% of the cases where ADA_req is falsified. 

% Copy all non-artifical specs into their corresponding artificial ones
baseFieldNames = fieldnames(base_cfg);
for specCounter = 1:numel(baseFieldNames)
    thisField = baseFieldNames{specCounter};
    if contains(thisField, '_artificial')
        % Skip if artificial
        continue
    end
    base_cfg.([thisField '_artificial']) = base_cfg.(thisField);
end

% Now, add artificial-only parameters
base_cfg.ADA_art.artificial_ADA_min = 45;
base_cfg.ADA_art.artificial_ADA_max = 55;
base_cfg.ADI_art.artificial_ADI_min = 45;
base_cfg.ADI_art.artificial_ADI_max = 55;
base_cfg.ADI_art.artificial_ADI_BTL_min = 45;
base_cfg.ADI_art.artificial_ADI_BTL_max = 55;
base_cfg.AFE_art.artificial_AFE_RFC_min = 45;
base_cfg.AFE_art.artificial_AFE_RFC_max = 55;
base_cfg.AOT_art.artificial_AOT_AFE_min = 10;
base_cfg.AOT_art.artificial_AOT_AFE_max = 90;
base_cfg.AOT_art.artificial_AOT_ASL_min = 45;
base_cfg.AOT_art.artificial_AOT_ASL_max = 55;
base_cfg.ASL_art.artificial_ASL_ADA_min = 10;
base_cfg.ASL_art.artificial_ASL_ADA_max = 90;

% Copy values to all the other _req requirements where needed
base_cfg.BTL_art.artificial_ADI_BTL_min = ...
    base_cfg.ADI_art.artificial_ADI_BTL_min;
base_cfg.BTL_art.artificial_ADI_BTL_max = ...
    base_cfg.ADI_art.artificial_ADI_BTL_max;
base_cfg.RFC_art.artificial_AFE_RFC_min = ...
    base_cfg.AFE_art.artificial_AFE_RFC_min;
base_cfg.RFC_art.artificial_AFE_RFC_max = ...
    base_cfg.AFE_art.artificial_AFE_RFC_max;
base_cfg.AFE_art.artificial_AOT_AFE_min = ...
    base_cfg.AOT_art.artificial_AOT_AFE_min;
base_cfg.AFE_art.artificial_AOT_AFE_max = ...
    base_cfg.AOT_art.artificial_AOT_AFE_max;
base_cfg.AFE_art.artificial_AOT_AFE_min = ...
    base_cfg.AOT_art.artificial_AOT_AFE_min;
base_cfg.AFE_art.artificial_AOT_AFE_max = ...
    base_cfg.AOT_art.artificial_AOT_AFE_max;
base_cfg.ASL_art.artificial_AOT_ASL_min = ...
    base_cfg.AOT_art.artificial_AOT_ASL_min;
base_cfg.ASL_art.artificial_AOT_ASL_max = ...
    base_cfg.AOT_art.artificial_AOT_ASL_max;
base_cfg.ADA_art.artificial_ASL_ADA_min = ...
    base_cfg.ASL_art.artificial_ASL_ADA_min;
base_cfg.ADA_art.artificial_ASL_ADA_max = ...
    base_cfg.ASL_art.artificial_ASL_ADA_max;

% Artificial thresholds for ARCH specs
base_cfg.ARCH_AT1_art.artificial_ARCH_AT1_min = 45;
base_cfg.ARCH_AT1_art.artificial_ARCH_AT1_max = 55;
base_cfg.ARCH_AT2_art.artificial_ARCH_AT2_min = 45;
base_cfg.ARCH_AT2_art.artificial_ARCH_AT2_max = 55;
base_cfg.ARCH_AT51_art.artificial_ARCH_AT5_min = 45;
base_cfg.ARCH_AT51_art.artificial_ARCH_AT5_max = 55;
base_cfg.ARCH_AT6a_art.artificial_ARCH_AT6_min = 45;
base_cfg.ARCH_AT6a_art.artificial_ARCH_AT6_max = 55;

% Copy values to other ARCH _req specs as needed
base_cfg.ARCH_AT52_art.artificial_ARCH_AT5_min = ...
    base_cfg.ARCH_AT51_art.artificial_ARCH_AT5_min;
base_cfg.ARCH_AT52_art.artificial_ARCH_AT5_max = ...
    base_cfg.ARCH_AT51_art.artificial_ARCH_AT5_max;
base_cfg.ARCH_AT53_art.artificial_ARCH_AT5_min = ...
    base_cfg.ARCH_AT51_art.artificial_ARCH_AT5_min;
base_cfg.ARCH_AT53_art.artificial_ARCH_AT5_max = ...
    base_cfg.ARCH_AT51_art.artificial_ARCH_AT5_max;
base_cfg.ARCH_AT54_art.artificial_ARCH_AT5_min = ...
    base_cfg.ARCH_AT51_art.artificial_ARCH_AT5_min;
base_cfg.ARCH_AT54_art.artificial_ARCH_AT5_max = ...
    base_cfg.ARCH_AT51_art.artificial_ARCH_AT5_max;
base_cfg.ARCH_AT6b_art.artificial_ARCH_AT6_min = ...
    base_cfg.ARCH_AT6a_art.artificial_ARCH_AT6_min;
base_cfg.ARCH_AT6b_art.artificial_ARCH_AT6_max = ...
    base_cfg.ARCH_AT6a_art.artificial_ARCH_AT6_max;
base_cfg.ARCH_AT6c_art.artificial_ARCH_AT6_min = ...
    base_cfg.ARCH_AT6a_art.artificial_ARCH_AT6_min;
base_cfg.ARCH_AT6c_art.artificial_ARCH_AT6_max = ...
    base_cfg.ARCH_AT6a_art.artificial_ARCH_AT6_max;

% Add all artificial temporal parameters for Volvo-inspired specs
base_cfg.ADA_art.artificial_ADA_time = 15;
base_cfg.ADI_art.artificial_ADI_time = 15;
base_cfg.AFE_art.artificial_AFE_time = 15;
base_cfg.AOT_art.artificial_AOT_time = 15;
base_cfg.ASL_art.artificial_ASL_time = 15;
base_cfg.BTL_art.artificial_BTL_time = 15;
base_cfg.RFC_art.artificial_RFC_time = 15;

% Add all artificial temporal parameters for ARCH specs
base_cfg.ARCH_AT1_art.artificial_ARCH_AT1_time = 15;
base_cfg.ARCH_AT2_art.artificial_ARCH_AT2_time = 15;
base_cfg.ARCH_AT51_art.artificial_ARCH_AT51_time = 15;
base_cfg.ARCH_AT52_art.artificial_ARCH_AT52_time = 15;
base_cfg.ARCH_AT53_art.artificial_ARCH_AT53_time = 15;
base_cfg.ARCH_AT54_art.artificial_ARCH_AT54_time = 15;
base_cfg.ARCH_AT6a_art.artificial_ARCH_AT6a_time = 15;
base_cfg.ARCH_AT6b_art.artificial_ARCH_AT6b_time = 15;
base_cfg.ARCH_AT6c_art.artificial_ARCH_AT6c_time = 15;


%% params struct with everything
all_specs = fieldnames(base_cfg);
for ispec = 1:numel(all_specs)
   this_spec_params = fieldnames(base_cfg.(all_specs{ispec}));
   for iparam = 1:numel(this_spec_params)
       params.(this_spec_params{iparam})= base_cfg.(all_specs{ispec}).(this_spec_params{iparam});
   end
end

%% Assign all parameters in struct base_cfg.AFE_req in base workspace 
%cellfun(@(c)(assignin('base', c, params.(c))), fieldnames(params));