function [B, R, currentReqs, params] = setup_ATwSS_artificial(reqs, params) 

B = []; 
R = []; 
currentReqs = {}; 
initializeReqParameters;
bdclose('AT_and_specifications_artificial_breach');

switch nargin
    case 0 
        % interactive mode
        list_models_original = arrayfun(@(c)(c.name), dir('specRefModels/*.slx'), 'UniformOutput', false);
        list_models_artificial = arrayfun(@(c)(c.name), dir('specRefModelsArtificial/*.slx'), 'UniformOutput', false);
        list_models = [list_models_original(:)' list_models_artificial(:)']';
        list_models = setdiff(list_models, {'specifications_artificial.slx'});
        list_models = setdiff(list_models, {'specifications.slx'});
        select_models = select_cell_gui(list_models, list_models, 'Pick one or more requirement models');
        if isequal(select_models,0)
            return;
        end
                
        fixedStepSize = evalin('base', 'fixedStepSize');
        [allReqs, ~] = ...
            createAndLoadRequirements(fixedStepSize, select_models);
        
        allReqsNames = cellfun(@(c)(get_id(c)),allReqs, 'UniformOutput', false);
        
        % detect hard instances
        allReqsNamesPlusHard ={};  
        for ir = 1:numel(allReqsNames)
            allReqsNamesPlusHard{end+1} = [allReqsNames{ir}(5:end) ',base'];
            if isfield(hard_cfg, allReqsNames{ir}(5:end)) % we have hard configs for this
                hparams= fieldnames(hard_cfg.(allReqsNames{ir}(5:end)));
                for id = 1:size(hard_cfg.(allReqsNames{ir}(5:end)).(hparams{1}),2)
                    allReqsNamesPlusHard{end+1} = [allReqsNames{ir}(5:end) ',hard,' num2str(id)];
                end
            end
            allReqsNames{ir} = [allReqsNames{ir}(5:end) ',base'];
        end
        
        currentReqsNames = select_cell_gui(allReqsNamesPlusHard,{}, 'Pick one (or more) requirement(s) to falsify;');
        
        if isequal(currentReqsNames,0)
            return;
        end
        
        %% Detect currentReqs and hard instances
        currentReqs = {};
        for ispec = 1:numel(currentReqsNames)
            sp = strsplit(currentReqsNames{ispec},',');
            currentReqs{end+1} = STL_Formula(['phi_' sp{1}]);  % add STL_Formula object to currentReqs
            
            % Fix: For _art specs, the field in base_cfg and hard cfg don't
            % contain _act or _req. 
            % For example, for spec 'ADA_act_art', the field in base_cfg is
            % 'ADA_art' (since the parameters are the same for both _req
            % and _act). 
            % To remedy this, we remove the middle part, e.g. '_act' from
            % 'ADA_act_art'. 
            if contains(sp{1}, '_art')
                sp{1} = regexprep(sp{1}, '_act.*_', '_');
                sp{1} = regexprep(sp{1}, '_req.*_', '_');
            end
            
            switch sp{2}
                case 'base'
                    this_spec_params = fieldnames(base_cfg.(sp{1}));
                    for iparam = 1:numel(this_spec_params)
                        params.(this_spec_params{iparam})= base_cfg.(sp{1}).(this_spec_params{iparam});
                    end
                    
                case 'hard'
                    idx = str2double(sp{3});
                    this_spec_params = fieldnames(base_cfg.(sp{1}));
                    for iparam = 1:numel(this_spec_params)
                        params.(this_spec_params{iparam})= base_cfg.(sp{1}).(this_spec_params{iparam});
                    end
                    
                    hard_spec_params = fieldnames(hard_cfg.(sp{1}));
                    for iparam = 1:numel(hard_spec_params)
                        params.(hard_spec_params{iparam})= hard_cfg.(sp{1}).(hard_spec_params{iparam})(idx);
                    end
            end
        end
        
        
    case 1 % missing params 
        error('setup_ATwSS takes 0 (interactive mode) or 2 arguments: requirements and parameters structure.')
        
    case 2
        currentReqs = reqs;
end
cellfun(@(c)(assignin('base', c, params.(c))), fieldnames(params));
R = BreachRequirement(currentReqs);
B = initializeBreachSystemForMRF('AT_and_specifications_artificial', fieldnames(params)');
values = cell2mat(struct2cell(params))';
B.SetParam(fieldnames(params),values);
end

