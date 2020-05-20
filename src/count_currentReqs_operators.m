for ireq = 1:numel(currentReqs)
    phi = currentReqs{ireq};
    [~, nop, tdepth] = STL_Break(phi);
    name = [get_id(phi) '                        '];
    fprintf('%s       temporal nested depth: %g       #operators: %g\n', name(1:25), tdepth, nop);
end