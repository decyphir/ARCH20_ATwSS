% Remove all spec data, meaning:
% - Delete all generated .stl files in the folder STLFiles
% - Clear all signal names in all requirement models (.slx)
% - Remove all signal loggers in all requirement models (.slx)

% Delete all generated STL files
fclose all;
allStlFiles = dir(['STLFiles' filesep '*.stl']);

for k = 1:numel(allStlFiles)
    thisFile = ['STLFiles' filesep allStlFiles(k).name];
    delete(thisFile);
end

% Clear signal data inside all Simulink requirement models
allRequirementModels = dir(['specRefModels' filesep '*.slx']);

for k = 1:numel(allRequirementModels)
    thisFile = allRequirementModels(k).name;
    clearSignalsNamesAndLoggers(strrep(thisFile, '.slx', ''));
end

