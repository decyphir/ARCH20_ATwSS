function params= cfg2params(reqsNames)
% format is phi_modelname_req|act[_art],base|hard[ (1-9)]
if ~iscell(reqsNames)
    reqsNames={reqsNames};
end

[~, ~, base_cfg, hard_cfg] = initializeReqParameters();

for ispec = 1:numel(reqsNames)
    sp = strsplit(reqsNames{ispec},',');
    
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
cellfun(@(c)(assignin('base', c, params.(c))), fieldnames(params));
end