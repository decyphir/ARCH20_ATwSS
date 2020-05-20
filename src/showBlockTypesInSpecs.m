% Check all block types in the specifications, make sure that there are no
% "secret" blocks anywhere

listOfModels = dir([pwd filesep '*.slx']);

allowedBlocks = {'Inport', 'Abs', 'Constant', 'SubSystem', 'DataTypeConversion', ...
    'Logic', 'RelationalOperator', 'From', 'Goto', 'Switch', 'UnitDelay', ...
    'Outport', 'Sum', 'MultiPortSwitch', 'DataTypeDuplicate', 'Saturate', ...
    'Signum', 'MinMax', 'Clock'};

for modelCounter = 1:numel(listOfModels)
    thisModel = listOfModels(modelCounter).name;
    
    modelHandle = load_system(thisModel);
    
    blockHandles = find_system(modelHandle);
    
    % Exclude the first blockHandle when looking for block types (first is
    % the block diagram, it has no block type)
    blockTypes = get(blockHandles(2:end), 'BlockType');
    blockTypes = unique(blockTypes);
    for blockCounter = 2:numel(blockHandles)
        thisBlockHandle = blockHandles(blockCounter);
        thisBlockType = get(thisBlockHandle, 'BlockType');
        thisBlockPath = get(thisBlockHandle, 'Path');
        thisBlockName = get(thisBlockHandle, 'Name');
        thisBlockPathAndName = [thisBlockPath '/' thisBlockName];
        %thisBlockType = blockTypes{blockCounter};
        if ~contains(allowedBlocks, thisBlockType)
            disp(['*** Found blocktype ' thisBlockType ' for block ' thisBlockPathAndName]);
            disp(['*** Check whether this should be removed/changed!']);
        end
        
        thisMaskType = get(thisBlockHandle, 'MaskType');
        if contains(thisMaskType, 'VCC') || contains(thisMaskType, 'EPS')
            disp(['*** Found Mask Type ' thisMaskType ' for block ' thisBlockPathAndName]);
        end
        
        thisReferenceBlock = get(thisBlockHandle, 'ReferenceBlock');
        if contains(thisReferenceBlock, 'VCC') || contains(thisReferenceBlock, 'EPS')
            disp(['*** Found Reference Block ' thisReferenceBlock ' for block ' thisBlockPathAndName]);
        end
        
        try
            thisOutDataTypeStr = get(thisBlockHandle, 'OutDataTypeStr');
            listOfOkDataTypeStr = {'Inherit', 'boolean', 'double'};
            if ~contains(thisOutDataTypeStr, listOfOkDataTypeStr)
                disp(['*** Fix OutDataTypeStr for ' thisBlockPathAndName ': ''' thisOutDataTypeStr '''']);
            end
        end
        
    end

    close_system(thisModel);
    
    disp(['Finished checking ' thisModel]);
end