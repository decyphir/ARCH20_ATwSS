function [B, R, cfg] = setup_ATwSS_system_and_reqs(cfg, artif)
%  
% [B, R, cfg] = setup_B_R()
% Configures ATwSS benchmark interactively using a GUI. 
%
% [B, R, cfg] = setup_B_R(cfg)
% Configures ATwSS benchmark using a struct.
%
% [B, R, cfg] = setup_B_R(pre_cfg, artif)
% Configures ATwSS benchmark using a pre configured setting. If artif
% is true, then artificial signals and requirements are used. Pre
% configured options are:  
%    
%
% Outputs:
%    - B    Breach interface to the model, configured with default input
%           generator and parameters for the requirements
%    - R    BreachRequirement object storing the chosen requirements 
%    - cfg  structure describing the configuration. 
%
% B and R can be used directly with the FalsificationProblem class of
% Breach, e.g.,
%
% pb = FalsificationProblem(B,R);
% pb.StopAtFalse = false; % don't stop at first falsified requirement
% pb.solve();
%


%% Init path and stuff
init_ATwSS

%% Run Gui and get result (or not)
g = ATwSS_Gui();        

switch nargin

    case 0 % no argument, we use the GUI interactively
    uiwait(g.hdle);
    if isempty(g.output) % cancel
        B= [];
        R= [];
        cfg = struct();
        return
    end
        
    case 1  % expects a valid struct cfg
        try
            g.load_cfg(cfg);
            close(g.hdle);
        catch
            close(g.hdle);
            error('First argument is not a valid configuration structure');
            
        end
        
    case 2  % expects a pre cfg string and a boolean for artificial signals
        pre_cfg = cfg;
        % checks if pre_cfg is a valid pre configuration
        all_cfg = g.get_by_id('popup_precfg','string');
        valid_pre_cfg= setdiff( all_cfg, {'empty', 'custom'});
        if ismember(pre_cfg,valid_pre_cfg)
            idx_cfg = find(strcmp(pre_cfg, all_cfg),1);            
            g.set_by_id('popup_precfg', 'value', idx_cfg);
            g.popup_precfg('callback');
        else
            close(g.hdle);
            error('setup_ATwSS:invalid_pre_cfg','%s is an invalid configuration, options are ''all_base'', ''all_hard_1'', ''all_hard_2'',''all_ARCH_base'' and ''all_Volvo_base''', pre_cfg);
        end           
        close(g.hdle);
        g.reqs_cfg.artificial = artif;       
end

%% Init model, requirements and configure inputs

% Load params and init them in workspace once.
params = initializeReqParameters;
cellfun(@(c)(assignin('base', c, params.(c))), fieldnames(params));
cfg = g.reqs_cfg;    

%% 
AllReqs = setdiff(fieldnames(cfg), 'artificial');

if cfg.artificial
   mdl = 'AT_and_specifications_artificial';
   currentReqs= {}; 
   for idx_req = 1:numel(AllReqs)
        req = AllReqs{idx_req};
        if ~isempty(cfg.(req))
            %% Load base and artificial formulas and compose them
            req_file = [req '.stl'];
            req_art_file = regexprep(req_file, '_act', '_art');
            req_art_file = regexprep(req_art_file, '_req', '_art');
            req_art_file = regexprep(req_art_file, '[0-9]+\.stl', '.stl');
            fprintf('Loading %s ...', req_file);
            [~, phis] = STL_ReadFile(req_file);
            phi_base = phis{1};
            fprintf('done.\n');
            fprintf('Loading %s ...', req_art_file);
            [~, phis] = STL_ReadFile(req_art_file);
            fprintf('done.\n');
            phi_art = phis{1};
            
            phi = STL_Formula(['phi_' req '_art'],'or', phi_base, phi_art);
            
            %% recover local parameters from base and art formulas
            pbase = get_params(phi_base);
            phi = set_params(phi, pbase);
            part = get_params(phi_art);
            phi = set_params(phi, part);            
            currentReqs{end+1} = phi;            
            cfg2params([req ',' cfg.(req)]); % for this req., pick the specific config and adjust parameters in the base workspace       
        else
            cfg=rmfield(cfg, req); % clean cfg struct output by removing empty requirements
        end
    end
    R = BreachRequirement(currentReqs);
    
    param_names = fieldnames(params)';
    B = BreachSimulinkSystem(mdl, param_names); % faster to specify explicitly param_names
    B.SetTime(30)
    B.SetupDiskCaching();
    
    %% Input generation default config
    % For artificial signals, we use 3 control points between 0 and 100, 3 for
    % brake and 7 for throttle
    
    art_inputs = B.expand_signal_name('artificial_*');
    inputs = [{'throttle' 'brake'} art_inputs];
    n_cp = [7 3 3*ones(1, numel(art_inputs))];
    ig = fixed_cp_signal_gen(inputs, n_cp, 'pchip');
    B.SetInputGen(ig);
    
    %% Set variable domain for artificial inputs
    art_inputs_params = B.expand_param_name('artificial.+u');
    B.SetParamRanges(art_inputs_params, [0 100]);
    
    throttle_input_params = B.expand_param_name('throttle_u');
    B.SetParamRanges(throttle_input_params, [0 100]);
    
    brake_input_params = B.expand_param_name('brake_u');
    B.SetParamRanges(brake_input_params, [0 325]);

else
    mdl = 'AT_and_specifications';
    currentReqs={};
    for idx_req = 1:numel(AllReqs)
        
        req = AllReqs{idx_req};
        
        if ~isempty(cfg.(req))
            req_file = [req '.stl'];
            fprintf('Loading %s ...', req_file);
            [~, phi] = STL_ReadFile(req_file);
            currentReqs{end+1} = phi{1}; % replace text with STL_Formula
            fprintf('done.\n');
            cfg2params([req ',' cfg.(req)]);
        else
            cfg=rmfield(cfg, req); % clean cfg struct output by removing empty requirements        
        end
    end
    R = BreachRequirement(currentReqs);
    
    param_names = fieldnames(params)';
    B = BreachSimulinkSystem(mdl, param_names); % faster to specify explicitly param_names
    B.SetTime(30)
    B.SetupDiskCaching();
    
    %%
    % Input generation config
    % For artificial signals, we use 3 control points between 0 and 100, 3 for
    % brake and 7 for throttle
    
    inputs = {'throttle' 'brake'};
    n_cp = [7 3];
    ig = fixed_cp_signal_gen(inputs, n_cp, 'pchip');
    B.SetInputGen(ig);
    
    %% Set variable domain for artificial inputs
    throttle_input_params = B.expand_param_name('throttle_u');
    B.SetParamRanges(throttle_input_params, [0 100]);
    
    brake_input_params = B.expand_param_name('brake_u');
    B.SetParamRanges(brake_input_params, [0 325]);
    
end