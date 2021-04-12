%% ATwSS basic falsification setup using GUI
clear all
bdclose all;

%% Run GUI to initialize model interface, input generator and requirements
[B, R, cfg] = setup_ATwSS_system_and_reqs();
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

