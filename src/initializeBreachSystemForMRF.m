function B = initializeBreachSystemForMRF(model, params)

if nargin<2
    B = BreachSimulinkSystem(model);
else
    B = BreachSimulinkSystem(model, params);
end

nCP = [7 3];
input_gen.type = 'UniStep';   % uniform time steps
input_gen.cp = nCP;           % number of control points
input_gen.method = {'pchip', 'pchip'};
B.SetInputGen(input_gen);
for k = 1:nCP(1)
    % Set range of accelerator to [0 100]
    eval(['B.SetParamRanges({''throttle_u' num2str(k-1) '''}, [0 100]);']);
end

for k = 1:nCP(2)
    % Set range of brake to [0 325]
    eval(['B.SetParamRanges({''brake_u' num2str(k-1) '''}, [0 325]);']);
end

% Setup disk caching
B.SetupDiskCaching();

% Set the simulation time to 10 seconds
B.SetTime(30);

% Try to turn on FastRestart
try
    load_system(B.Sys.mdl);
    set_param(B.Sys.mdl, 'FastRestart', 'on');
    save_system(B.Sys.mdl);
    disp(['Enabled fast restart for ' B.Sys.mdl]);
catch ME
    disp(['Did not manage to enable fast restart for ' B.Sys.mdl]);
end


end