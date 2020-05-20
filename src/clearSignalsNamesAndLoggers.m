function clearSignalsNamesAndLoggers(modelName)
load_system(modelName);
lh=find_system(modelName, 'FindAll', 'on', 'LookUnderMasks','On','FollowLinks','On','type', 'line');
for i_lh=1:length(lh)
    set(lh(i_lh), 'DataLogging', 0);
    set(lh(i_lh), 'Name', '');
end
save_system(modelName);
end