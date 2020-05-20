addpath('specRefModels');
addpath('../../testron_staliro');
addpath('../../specTransformer');
bdclose('AT_and_specifications_breach');

% Initialize parameter values (used in requirement models)
initializeReqParameters;
B = initializeBreachSystemForMRF('AT_and_specifications', fieldnames(params)');
%%
time =0:1:30;

%% Reach analysis for input generator
IG = B.InputGenerator;
IG.SetTime(time);
throttle_vars = IG.expand_param_name('throttle*');
IG.SetParamRanges(throttle_vars, [0 100]);

brake_vars = IG.expand_param_name('brake*');
IG.SetParamRanges(brake_vars, [0 500]);

%
brake_reach = reach_monitor('brake_reach', 'brake', time);
throttle_reach = reach_monitor('throttle_reach', 'throttle', time);
R_IG= BreachRequirement({throttle_reach,brake_reach});

F = FalsificationProblem(IG, R_IG);
F.display = 'off';
F.StopAtFalse = 0;
F.solve();


% Plotting
subplot(2,1,1);
throttle_reach.plot_enveloppe();
legend({'Throttle Enveloppe'});

%
subplot(2,1,2);
brake_reach.plot_enveloppe();
legend({'Brake Enveloppe'});

%% Reach Analysis for Speed and RPM and torques

speed_reach = reach_monitor('speed_reach', 'speed', time);
RPM_reach = reach_monitor('RPM_reach', 'RPM', time);
impellerTorque_reach = reach_monitor('impellerTorque_reach', 'impellerTorque', time);
outputTorque_reach = reach_monitor('outputTorque_reach', 'outputTorque', time);

Rsrt = BreachRequirement({speed_reach, RPM_reach, impellerTorque_reach, outputTorque_reach});
Fsrt = FalsificationProblem(B, Rsrt);
Fsrt.StopAtFalse = 0;
Fsrt.max_obj_eval = 1000;
Fsrt.solve();

figure;

%% Plotting
B100 = B.copy(); 
B100.SampleDomain(100);
B100.Sim();
%%
figure; B100.PlotSignals({'speed', 'RPM', 'impellerTorque', 'outputTorque'}, [], {'-b', 'LineWidth',0.5});

subplot(4,1,1);
speed_reach.plot_enveloppe();
legend({'speed Enveloppe'});

subplot(4,1,2);
RPM_reach.plot_enveloppe();
legend({'RPM Enveloppe'});

subplot(4,1,3);
impellerTorque_reach.plot_enveloppe();
legend({'impellerTorque Enveloppe'});


subplot(4,1,4);
outputTorque_reach.plot_enveloppe();
legend({'outputTorque Enveloppe'});


