%% ATwSS basic falsification setup using cfg struct
clear all
bdclose all;

%% Initialize model interface, input generator and requirements
cfg = struct('artificial',0, ...
             'ARCH_AT51_act','base',...
             'ARCH_AT51_req','base',...
             'ADA_act', 'hard,1',...
             'ADA_req', 'hard,1'...
         );
%%
[B, R, cfg] = setup_ATwSS_system_and_reqs(cfg);
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

