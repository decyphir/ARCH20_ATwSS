function [allReqs, allEndTimes] = ...
    createAndLoadRequirements(sampleTime, modelsSearch, modelsToDebug)
%CREATEANDLOADREQUIREMENTS Create and load all requirements
%   This function will generate .stl files for all specifications inside
%   the model. The final specification in each .stl file will be loaded
%   into the cell array allReqs, which is returned from this function.
%   allReqs is a cell array of STL formulas
%   allEndTimes is a vector of equal length to allReqs. Each element
%       contains the end time for evaluation for the corresponding formula 
%       in allReqs.

if nargin<2
    modelsSearch = 'specRefModels/*.slx';
end
if nargin < 3
    modelsToDebug = {};
end

if ischar(modelsSearch)
allSpecificationModels = dir(modelsSearch);
elseif iscell(modelsSearch)
    if all(contains(modelsSearch, '_artificial'))
        % Initializing for model with artificial inputs
        % Use another folder specifically
        resultsFolder = 'STLFiles_artificial';
        allSpecificationModels = cell2mat(cellfun(@(c)(dir(sprintf('specRefModelsArtificial/%s',c))),  modelsSearch,  'UniformOutput',  false));
    else
        % Use normal folder
        resultsFolder = 'STLFiles';
        allSpecificationModels = cell2mat(cellfun(@(c)(dir(sprintf('specRefModels/%s',c))),  modelsSearch,  'UniformOutput',  false));
    end
end
    
allReqs = {};
allEndTimes = [];

% We need to keep track of the "logCounter" that specTransformer uses when
% generating STL_formulas. 
% If logCounter = 5, then when we log a UnitDelay block, the name will be
% UnitDelay5. If we do not keep track of the counter, it will reset for
% each new spec, meaning that we can have the same signal name in several
% different specs. 
logCounter = 1;

for specCounter = 1:numel(allSpecificationModels)
    % Load the Simulink model
    fileName = allSpecificationModels(specCounter).name;
    load_system(fileName);
    
    thisModelName = strrep(fileName, '.slx', '');
    
    
    if ~isfolder(resultsFolder)
        mkdir(resultsFolder);
    end
    
    % Find all blocks and blockTypes
    evalin('base',[thisModelName '([], [], [], ''compile'')']);
    allBlocks = find_system(thisModelName, 'LookUnderMasks','On','FollowLinks','On');
    allBlockTypes = {};
    allBlockDimensions = {};
    for blockCounter = 1:numel(allBlocks)
        thisBlock = allBlocks{blockCounter};
        try
            allBlockTypes{blockCounter} = get_param(thisBlock, 'CompiledPortDataTypes'); %#ok<*AGROW>
            allBlockDimensions{blockCounter} = get_param(thisBlock, 'CompiledPortDimensions');
        catch
            % For example, block_diagram does not have this property
            allBlockTypes{blockCounter} = 'undefined';
            allBlockDimensions{blockCounter} = {0};
        end
    end
    eval([thisModelName '([], [], [], ''term'')']);
    
    outports = find_system(thisModelName,'SearchDepth', 1, 'BlockType', 'Outport');
    
    % First, check if there is ANY outport that does NOT have .stl file
    % generated - in that case, we will generate all.
    allFilesGenerated = 1;
    for outportCounter = 1:numel(outports)
        load_system(thisModelName);
        thisRequirement = get_param(outports{outportCounter}, 'Name');
        
        if ~isfile([resultsFolder '/' thisRequirement '.stl'])
            allFilesGenerated = 0;
        end
    end
    
    % Get the evaluation time (set in initializeReqParameters.m)
    evalTimeVariable = [thisModelName '_evalTime'];
    try
        thisEvalTime = evalin('base', evalTimeVariable);
    catch
        thisEvalTime = [0 30];  % default 
        %error(['No eval time set for ' thisModelName ...
        %    '! It needs to be set in initializeReqParameters.m']);
    end
    
    
    % If all files are generated, we just load them
    if allFilesGenerated
        % Load the STL file
        for outportCounter = 1:numel(outports)
            thisRequirement = get_param(outports{outportCounter}, 'Name');
            fprintf([thisRequirement ...
                ' has already been created! Loading spec from file ... ']);
            % Store the requirement
            [~, props, ~, ~] = ...
                STL_ReadFile([resultsFolder '/' thisRequirement '.stl']);
            % The generated full requirement is the last one in the file
            thisReq = props{end};
            allReqs{end+1} = thisReq;
            allEndTimes(end+1) = thisEvalTime(2);
            fprintf(' Done!\n');
        end
    else
        % All files are NOT generated
        % First, clear all the signal names and remove all loggers from the
        % model
        clearSignalsNamesAndLoggers(thisModelName);
        
        % Then, generate STL files for each outport
        for outportCounter = 1:numel(outports)
            load_system(thisModelName);
            thisRequirement = get_param(outports{outportCounter}, 'Name');
            
            % If this particular .stl file exists, delete it (because we
            % will now generate it again, since some other outport for this
            % model is NOT generated)
            if isfile([resultsFolder '/' thisRequirement '.stl'])
                delete([resultsFolder '/' thisRequirement '.stl']);
            end
            
            specObj = specTransformer(thisModelName, thisRequirement, resultsFolder, sampleTime);
            specObj.startTime = thisEvalTime(1);
            specObj.endTime = thisEvalTime(2);
            specObj.charLimit = 1e6;
            if contains(thisRequirement, 'ARCH_AT6') && ...
                    contains(thisRequirement, '_req')
                % Special case! The ARCH_AT6 req specs are of type 'none'
                specObj.specType = 'none';
            elseif contains(thisRequirement, '_req')
                specObj.specType = 'safety';
            elseif contains(thisRequirement, '_act')
                specObj.specType = 'activation';
            end
            
            % Set the corresponding variables in the testronSTL object
            specObj.allBlocks = allBlocks;
            specObj.allTypes = allBlockTypes;
            specObj.allDimensions = allBlockDimensions;
            
            % Potentially temporary: Do not generate explicitly (everything
            % will be one big formula in the end)
            specObj.createSubRequirements = 0;
            
            % Set the logCounter to the value we are keeping track of
            specObj.logCounter = logCounter;
            
            % Generate the requirement
            specObj.requirementToSTL;
            
            % Store the requirement
            [~, props, ~, ~] = ...
                STL_ReadFile([resultsFolder '/' thisRequirement '.stl']);
            % The generated full requirement is the last one in the file
            thisReq = props{end};
            allReqs{end+1} = thisReq;
            allEndTimes(end+1) = specObj.endTime;
            
            % Load the logCounter after transformation has finished
            logCounter = specObj.logCounter;
        end
        
        % Finally, if we are in debug mode, log all signals in the model
        if any(contains(modelsToDebug, thisModelName))
            subCounter = specObj.subCounter + 1;
            load_system(thisModelName);
            allLines = find_system(thisModelName, 'FindAll', 'on', 'Type', 'line');
            for blockCounter = 1:numel(allLines)
                thisLine = allLines(blockCounter);
                lineName = get(thisLine, 'Name');
                %dataLogging = get(thisLine, 'DataLogging')
                if ~isempty(lineName) && ~get(thisLine, 'DataLogging')
                    set(thisLine, 'Name', [thisModelName '_' lineName]);
                    set(thisLine, 'DataLogging', 1);
                elseif isempty(lineName) && ~get(thisLine, 'DataLogging')
                    % We need to set a new signal name!
                    set(thisLine, 'Name', ...
                        [thisModelName '_sub' num2str(subCounter)]);
                    subCounter = subCounter + 1;
                    set(thisLine, 'DataLogging', 1);
                end
            end
            save_system(thisModelName);
        end
    end
    
    
end

% Close all opened .stl files
fclose('all');

end

