%% Performs corners and pseudo-random falsification on a subset of the ATwSS specifications

%Initialize benchmarks and tools (Breach, specTransformer)
init_ATwSS;

% Start timing of this function
startTime = tic;


%% Interactive initialization
[B, R, currentReqs, params]= setup_ATwSS;


%% Initialize corners falsification problem
max_num_corners = 50;
pbc = FalsificationProblem(B,R);
pbc.setup_corners('num_corners',max_num_corners);
pbc.StopAtFalse = false;
pbc.solve();

%% Initialize random falsification problem
max_num_simulations = 100;
rand_seed = 1;
pbr = FalsificationProblem(B,R);
pbr.max_obj_eval = max_num_simulations;
pbr.setup_random('num_rand_samples',max_num_simulations,...
                'rand_seed',rand_seed);

pbr.StopAtFalse = false;
pbr.solve();

%% Print falsification rates
if max_num_corners >= 50 && max_num_simulations >= 100
    objLogCorners = pbc.obj_log;
    objLogRandom = pbr.obj_log;
    fprintf('****** FALSIFICATION RATES (%g corner samples, %g random samples) ********\n', max_num_corners, max_num_simulations);
    
    for monitorCounter = 1:numel(currentReqs)
        nCorners = 50;
        nRandom = 100;
        
        nFalsifiedCorners = sum(objLogCorners(monitorCounter, 1:nCorners) < 0);
        nFalsifiedRandom = sum(objLogRandom(monitorCounter, 1:nRandom) < 0);
        nFalsifiedTotal = nFalsifiedCorners + nFalsifiedRandom;
        
        rateCorners = nFalsifiedCorners/nCorners;
        rateRandom = nFalsifiedRandom/nRandom;
        rateTotal = nFalsifiedTotal/(nCorners + nRandom);
        
        formula_id = R.req_monitors{monitorCounter}.formula_id;
        disp([formula_id ': ' num2str(100*rateTotal) ' % (' ...
            num2str(100*rateCorners) ' % corners, ' ...
            num2str(100*rateRandom) ' % random)']);        
    end
end

R_LoggedCorners = pbc.GetLog;
R_LoggedRandom = pbr.GetLog;

% Display time spent
timeSinceStart = toc(startTime);
timeNow = datestr(now);
disp(['Finished on ' timeNow ' (after running for ' ...
    num2str(timeSinceStart) ' seconds)']);
