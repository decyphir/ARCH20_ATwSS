%% ATwSS basic falsification setup using cfg struct
clear all
bdclose all;

%% Initialize model interface, input generator and requirements
precfg = 'all_ARCH_base'; % other options are 'all_base', 'all_hard_1', 'all_hard_2','all_ARCH_base','all_Volvo_base'
use_artif_signals= true; 

[B, R, cfg] = setup_ATwSS_system_and_reqs(precfg,use_artif_signals);
if isempty(B) % cancel
    return;
end    

%% Run a quick falsification with default options
pb = FalsificationProblem(B, R);
pb.StopAtFalse = false; % don't stop at first falsified requirement
pb.max_obj_eval=10;
pb.solve();

%% Display results
Rlog = pb.GetLog();
disp_ATwSS_results(Rlog);
BreachSamplesPlot(Rlog);
