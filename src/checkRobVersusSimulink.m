function checkRobVersusSimulink(res, R)
% This function checks whether the robustness values calculated for the
% STL formulas give the correct Boolean evaluation with respect to the
% corresponding Simulink signal values. 

% res is a structure that contains, among other things, the robustness
% values for each requirement and simulation performed. 
% R is a BreachRequirement object that contains information about the
% specs, as well as signal values. 

for monitorCounter = 1:numel(R.req_monitors)
    thisMonitor = R.req_monitors{monitorCounter};
    monitorID = thisMonitor.formula_id;
    
    if contains(monitorID, 'ARCH_AT6') && ...
            contains(monitorID, '_req')
        % Special case! The ARCH_AT6 req specs are of type 'none'
        specType = 'none';
    elseif contains(monitorID, '_req')
        specType = 'safety';
    elseif contains(monitorID, '_act')
        specType = 'activation';
    else
        error('Unexpected specType');
    end
    
    outputName = strrep(monitorID, 'phi_', '');
    simulinkValues = R.GetSignalValues(outputName);
    time = R.GetTime;
    
    % The formula only checks satisfaction for times between t_init and
    % t_final. Extract these parameters from the STL formula and make sure
    % we only look between these times. 
    modelName = strrep(outputName, '_req', ''); % Ugly way to get model name ...
    modelName = regexprep(modelName, '_act.*', '');
    allParams = get_params(thisMonitor.formula); %#ok<*NASGU>
    t_init = getStartTime(thisMonitor, allParams);
    
    try
        t_final = eval(['allParams.t_final_' modelName]);
    catch
        t_final = time(end);
    end
    
    timeIndices = (time >= t_init & time <= t_final);
    
    
    incorrectTrajsForThisSpec = [];
    for trajCounter = 1:numel(simulinkValues)
        simulinkTraj = simulinkValues{trajCounter};
        % Only check signal values for the times we care about
        simulinkTraj = simulinkTraj(timeIndices);
        
        rob = res{1, monitorCounter}.rob(trajCounter);
        if rob < 0
            % robustness says spec is falsified
            if strcmp(specType, 'none')
                if simulinkTraj(end) ~= 0
                    incorrectTrajsForThisSpec(end+1) = trajCounter; %#ok<*AGROW>
                end
            elseif strcmp(specType, 'safety')
                if all(simulinkTraj == 1)
                    incorrectTrajsForThisSpec(end+1) = trajCounter;
                end
            elseif strcmp(specType, 'activation')
                % We managed to activate the spec
                if all(simulinkTraj == 0)
                    incorrectTrajsForThisSpec(end+1) = trajCounter;
                end
            end
        else
            % robustness says spec is fulfilled
            if strcmp(specType, 'none')
                if simulinkTraj(end) ~= 1
                    incorrectTrajsForThisSpec(end+1) = trajCounter; 
                end
            elseif strcmp(specType, 'safety')
                if any(simulinkTraj == 0)
                    incorrectTrajsForThisSpec(end+1) = trajCounter;
                end
            elseif strcmp(specType, 'activation')
                % We did not manage to activate the spec
                if any(simulinkTraj == 1)
                    incorrectTrajsForThisSpec(end+1) = trajCounter; 
                end
            end
        end
    end
    
    if ~isempty(incorrectTrajsForThisSpec)
        disp(['checkRobVersusSimulink: INCORRECT rob values for spec ' monitorID ' at trajs']);
        disp(incorrectTrajsForThisSpec);
    end
    
end

end


function specTransformerStartTime = getStartTime(req, allParams)
% Get the start time where we start to evaluate the spec
% For example, if the spec is alw_[t_init + 5*dt,...](...),
%   with t_init = 0 and dt = 0.04, then the specTransformerStartTime will
%   be 0.2. 

% Get all params evaluated in this workspace
fnames = fieldnames(allParams);
for paramCounter = 1:numel(fnames)
    value = allParams.(fnames{paramCounter});
    eval([fnames{paramCounter} '=' num2str(value) ';']);
end

req = disp(req); % We analyze the string to get the start time

assignIndex = strfind(req, ':=');
alwString = req(assignIndex+3:assignIndex+6);

if ~strcmp(alwString, 'alw_')
    specTransformerStartTime = 0;
    return
end

startIndex = regexp(req, '[', 'once');
endIndex = regexp(req, ',', 'once');

startTimeString = req(startIndex+1:endIndex-1);

specTransformerStartTime = eval(startTimeString);

end