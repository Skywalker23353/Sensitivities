function [SNST] = compute_chem_src_term_sensitivities_test(SNST, SPD, LES, CNST, fName_numrtr, fName_denom,varargin)
    % Input parsing for optional remove_spikes
    p = inputParser;
    addParameter(p,'remove_spikes',false, @(x) islogical(x) || isnumeric(x));
    parse(p,varargin{:});
    remove_spikes = p.Results.remove_spikes;
    % Main computation
    for j = 1:length(fName_numrtr)
        numrtr = SPD.(fName_numrtr{j}).comb.dfdc;
        numrtr_n = SPD.(fName_numrtr{j}).noz.dfdc;

        for i = 1:length(fName_denom)
            
            fName = sprintf('d%s_d%s',SPD.(fName_numrtr{j}).opname,SPD.(fName_denom{i}).opname);
    
            denomtr = SPD.(fName_denom{i}).comb.dfdc;
            denomtr_n = SPD.(fName_denom{i}).noz.dfdc;
    
            snstvty = compute_sensitivities(numrtr,denomtr);
            snstvty_n = compute_sensitivities(numrtr_n,denomtr_n);

            snstvty = remove_spikes_interp2D(snstvty, 10);
            snstvty_n = remove_spikes_interp2D(snstvty_n,10);

            SNST.comb.(fName) =  snstvty;
            SNST.noz.(fName) =  snstvty_n;
        end
    end
end