classdef ATwSS_Gui < BreachGuiClass
    properties
     
       base_cfg
       hard_cfg
       
       reqs_cfg
       
       ARCH_reqs
       Volvo_reqs
       all_reqs
       
       
       custom_cfg
       
       %% Precgf        
       empty_cfg
       all_base_cfg
       all_ARCH_base_cfg
       all_hard_cfg              
       all_Volvo_base_cfg
                     
       all_hard_1_cfg
       all_hard_2_cfg
    
    end
    
    methods
        function this= ATwSS_Gui(cfg)
            set(this.hdle,'Name', 'ATwSS Gui Configurator');            
            
            %% Read available requirements
            [~,~, base_cfg, hard_cfg] = initializeReqParameters();
            this.base_cfg = base_cfg;
            this.hard_cfg = hard_cfg;
            this.reqs_cfg.artificial=0; 
                        
            %% layouts Volvo and arch
            this.Volvo_reqs = { 'ADA_req', 'ADA_act',...
                'ADI_req', 'ADI_act1','ADI_act2','ADI_act3',...
                'AFE_req', 'AFE_act',...
                'AOT_req', 'AOT_act',...
                'ASL_req', 'ASL_act',...
                'BTL_req', 'BTL_act1','BTL_act2',...
                'RFC_req', 'RFC_act'};
                                    
            Volvo_layout= {{'hsep.5'}};
            for idx_req = 1:numel(this.Volvo_reqs)
                req = this.Volvo_reqs{idx_req};
                if isempty(regexp(req, 'art','once'))
                    req_text= [req '_text'];
                    req_popup = ['popup_req_' req];
                    this.create_text(req_text, req,.3,1);
                    this.popup_req(req,'create');
                    Volvo_layout = [Volvo_layout ; {{req_text req_popup}}; ];
                end
            end
            
            this.ARCH_reqs = {'ARCH_AT1_req','ARCH_AT1_act', ...
                'ARCH_AT2_req','ARCH_AT2_act', ...
                'ARCH_AT51_req','ARCH_AT51_act', ...
                'ARCH_AT52_req','ARCH_AT52_act', ...
                'ARCH_AT53_req','ARCH_AT53_act', ...
                'ARCH_AT54_req','ARCH_AT54_act', ...
                'ARCH_AT6a_req','ARCH_AT6a_act', ...
                'ARCH_AT6b_req','ARCH_AT6b_act', ...
                'ARCH_AT6c_req','ARCH_AT6c_act', ...
                };
            
            
            ARCH_layout ={{'hsep.5'}};
            for idx_req = 1:numel(this.ARCH_reqs)
                req = this.ARCH_reqs{idx_req};
                if isempty(regexp(req, 'art','once'))
                    req_text= [req '_text'];
                    req_popup = ['popup_req_' req];
                    this.create_text(req_text, req,.4,1);
                    this.popup_req(req,'create');
                    ARCH_layout = [ARCH_layout; {{req_text req_popup}}];
                end
            end
            
            this.all_reqs= [this.ARCH_reqs this.Volvo_reqs];
            this.create_panel('panel_Volvo','Volvo Requirements',Volvo_layout);
            this.create_panel('panel_arch','ARCH Requirements',ARCH_layout);
            this.button_artif('create'); % instantiate artif button 
            this.create_group('right_column', { {'panel_Volvo'};{'ok_group'}});
            
            %% precfg 
            this.create_text('text_precfg', 'Config.', .3,1);
            this.setup_precfg();
            this.popup_precfg('create');
            
            %% Layout
            layout = {{'text_precfg', 'popup_precfg', 'button_artif' };
                {'panel_arch','right_column'};...
                };
                
            this.set_layout(layout);
            this.set_for_all('Units', 'Normalized');
            
            %% load if needed            
            if nargin>=1
                this.load_cfg(cfg)
                this.custom_cfg = cfg;
            else
                this.custom_cfg.artificial = 0;
            end
            
        end
        
        function setup_precfg(this)
            
           this.empty_cfg.artificial=0;
           
           %% all base
           this.all_base_cfg = struct;           
           for idx_req = 1:numel(this.all_reqs)
               this.all_base_cfg.(this.all_reqs{idx_req}) = 'base';
           end
           
           this.all_ARCH_base_cfg = struct;           
           for idx_req = 1:numel(this.ARCH_reqs)
               this.all_ARCH_base_cfg.(this.ARCH_reqs{idx_req}) = 'base';
           end
           
           this.all_Volvo_base_cfg = struct;
           this.all_Volvo_base_cfg.artificial=0; 
           for idx_req = 1:numel(this.Volvo_reqs)
               this.all_Volvo_base_cfg.(this.Volvo_reqs{idx_req}) = 'base';
           end
                                 
           %% all hard
           this.all_hard_1_cfg = struct;          
           for idx_req = 1:numel(this.all_reqs)
               req= this.all_reqs{idx_req};
               if isfield(this.hard_cfg, req)                    
                   this.all_hard_1_cfg.(req) = 'hard,1';
               else
                   this.all_hard_1_cfg.(req) = 'base';
               end
           end
    
           
           %% all hard
           this.all_hard_2_cfg = struct;           
           for idx_req = 1:numel(this.all_reqs)
               req= this.all_reqs{idx_req};
               if isfield(this.hard_cfg, req)                    
                   if numel(this.get_by_id(['popup_req_' req], 'String'))>=4
                       this.all_hard_2_cfg.(req) = 'hard,2';
                   else
                        this.all_hard_2_cfg.(req) = 'hard,1';
                   end
               else
                   this.all_hard_2_cfg.(req) = 'base';
               end
           end                          
        end
        
        function load_cfg(this,cfg)
            if isfield(cfg,'artificial')
                this.set_by_id('button_artif', 'Value', cfg.artificial);
                this.button_artif('callback');
            end
            
            % clear all states
            for idx_req = 1:numel(this.all_reqs)
                req = this.all_reqs{idx_req};                
                this.set_by_id(['popup_req_' req],'Value', 1);
                this.popup_req(req, 'callback');         
            end
            
            % read cfg req states
            reqs = setdiff(fieldnames(cfg), 'artificial');
            for idx_req = 1:numel(reqs)
               req = reqs{idx_req};
               state = cfg.(req);
               label = ['popup_req_' req];               
               all_states = this.get_by_id(label, 'String');
               idx_state= find(strcmp(all_states,state),1);
               this.set_by_id(label,'Value',idx_state);
               this.popup_req(req, 'callback');
            end
            
        end
        
        function this = text_info(this, mode)
            % Global variables
            label = 'text_info';
            string  = '';
            
            % sizes
            w = 1.3;
            h = 2;
            
            % Resolve call
            switch mode
                case 'create'
                    create_text_info()
                case 'callback'
                    callback_text_info();
                    update_text_info();
                case 'update'
                    update_text_info();
            end
            
            % Sub functions
            function create_text_info()
                this.data_gui.truc.num_clicked = 0;
                this.create_text(label, string, w,h);
                this.set_by_id(label,'BackgroundColor', [0.831; 0.816;0.784])
            end
            
            function callback_text_info()                            
            end
            
            function update_text_info()
                text = 'Need to update this';
                this.set_by_id(label, 'String', text);
            end
            
        end
                
        function this = popup_req(this,name, mode)
            % Global variables
            label = ['popup_req_' name];
            string  = '';
            
            % sizes
            w = 1;
            h = 1;
            
            % Resolve call
            switch mode
                case 'create'
                    create_popup_req()
                case 'callback'
                    callback_popup_req();                    
                case 'update'
                    update_popup_req();
            end
            
            % Sub functions
            function create_popup_req()                
                string = {'', 'base'};
                if isfield(this.hard_cfg, name)
                    p = fieldnames(this.hard_cfg.(name));
                    for idx_hard_cfg = 1:numel(this.hard_cfg.(name).(p{1}))
                        string = [string {['hard,' num2str(idx_hard_cfg)]}];
                    end
                end
                
                this.create_popup(label, string, @(hObj,evt) (popup_req(this,name, 'callback')), w/2,h);                            
            end                                    
            
            function callback_popup_req()
                value = this.get_by_id(label, 'Value');
                states = this.get_by_id(label, 'String');
                state_req = states{value};
                this.reqs_cfg.(name)= state_req;   
                this.custom_cfg = this.reqs_cfg;
                this.set_by_id('popup_precfg', 'Value',1);
            end
            
            function update_popup_req()
                if isfield(this.reqs_cfg, name)
                   all_states = this.get_by_id(label, 'String');
                   idx_state= find(strcmp(all_states,this.reqs_cfg.(name)),1);
                   this.set_by_id(label,'Value',idx_state);
                end
            end
            
        end
        
        function this = button_artif(this, mode)
            % Global variables
            label = 'button_artif';
            string  = 'Use artificial signals?';
            
            % sizes
            w = 1;
            h = 1;
            
            % Resolve call
            switch mode
                case 'create'
                    create_button_artif()
                case 'callback'
                    callback_button_artif();                    
                case 'update'
                    update_button_artif();
            end
            
            % Sub functions
            function create_button_artif()                                
                this.create_checkbox(label, string, @(hObj,evt) (button_artif(this,'callback')), w,h);                            
            end                                    
            
            function callback_button_artif()                
                value = this.get_by_id(label, 'Value');                
                this.reqs_cfg.artificial = value;                
                this.custom_cfg = this.reqs_cfg;                 
            end
            
            function update_button_artif()
                this.set_by_id(label,'Value',this.reqs_cfg.artificial);                
            end
            
        end
                  
        function this = popup_precfg(this, mode)
            % Global variables
            label = 'popup_precfg';
            string  = {'custom' 'empty' 'all_base' 'all_hard_1' 'all_hard_2'  ...
                                'all_ARCH_base' 'all_Volvo_base' ...                                
                                };
            
            % sizes
            w = .7;
            h = 1;
            
            % Resolve call
            switch mode
                case 'create'
                    create_popup_precfg()
                case 'callback'
                    callback_popup_precfg();                    
                case 'update'
                    update_popup_precfg();
            end
            
            % Sub functions
            function create_popup_precfg()                                                
                this.create_popup(label, string, @(hObj,evt) (popup_precfg(this, 'callback')), w,h);                            
            end                                    
            
            function callback_popup_precfg()
                saved_cfg= this.custom_cfg;
                value = this.get_by_id(label, 'Value');
                cfgs = this.get_by_id(label, 'String');
                cfg = [cfgs{value} '_cfg'];
                this.load_cfg(this.(cfg));
                this.set_by_id(label, 'Value',value); % load_cfg will have changed that                
                this.custom_cfg = saved_cfg;
            end
            
            function update_popup_precfg()
                if isfield(this.reqs_cfg, name)
                   all_states = this.get_by_id(label, 'String');
                   idx_state= find(strcmp(all_states,this.reqs_cfg.(name)),1);
                   this.set_by_id(label,'Value',idx_state);
                end
            end
            
        end
        
        
    end
    
    
    
    
    
end

