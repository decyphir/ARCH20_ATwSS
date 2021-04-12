function disp_ATwSS_results(pb)
    
    if isa(pb, 'FalsificationProblem')
       R = pb.GetLog(); 
    else       
       R = pb;
    end

    summary = R.GetSummary();
    
    for idx_req = 1:numel(summary.requirements.names)
        name= summary.requirements.names{idx_req};
        rob = summary.requirements.rob(:, idx_req);
        idx_first_falsif_this = find(rob<0,1);
        if isempty(idx_first_falsif_this)
           idx_first_falsif(idx_req) = 1e9+min(rob);
        else
           idx_first_falsif(idx_req) = idx_first_falsif_this;
        end
    end
       
    [~,sorted_idx] = sort(idx_first_falsif);
    
    step =0; 
    for idx_req = sorted_idx
        step = step+1;
        fprintf('%g:  ', step);
        name= summary.requirements.names{idx_req};
        rob = summary.requirements.rob(:, idx_req);
        idx_first_falsif = find(rob<0,1);
        if isempty(idx_first_falsif)
           fprintf('%s was not falsified, rob= %g\n', name, min(rob));
        else
           fprintf('%s was falsified at step %g\n', name, idx_first_falsif);
        end
    end
    
end
