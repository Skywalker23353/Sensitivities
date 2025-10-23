function [SNST] = compute_chem_src_term_sensitivities(SNST, SPD, LES, CNST, fName_numrtr, fName_denom,varargin)
    % Input parsing for optional remove_spikes
    p = inputParser;
    addParameter(p,'remove_spikes',false, @(x) islogical(x) || isnumeric(x));
    parse(p,varargin{:});
    remove_spikes = p.Results.remove_spikes;
    % Main computation
    for j = 1:length(fName_numrtr)
        numrtr = SPD.(fName_numrtr{j}).comb.dfdr;

        for i = 1:length(fName_denom)
            i
            fName = sprintf('d%s_d%s',SPD.(fName_numrtr{j}).opname,SPD.(fName_denom{i}).opname);
    
            denomtr = SPD.(fName_denom{i}).comb.dfdr;
    
            snstvty = compute_sensitivities(numrtr,denomtr);

            % Limit sensitivities to handle outliers in dT
            if remove_spikes && contains(fName,'dT')
                fprintf("Removing spikes in %s :",fName);
                if strcmp(fName,'dwCO2_dT')
                    fprintf(" by smoothing \n");
                    snstvty = apply_smoothing_ignore_boundaries_1(snstvty,5,'all',1,1);
                else
                    fprintf(" by threholding \n");
                    max_val = max(max(abs(snstvty)));
                    snstvty(abs(snstvty) > 0.05*max_val) = 0.05*max_val;
                end
            end
    
            % Replace values outside C bounds with boundary sensitivities
            replace_idx = LES.Comb.C_field >= CNST.c_ref_mx;
            snstvty(replace_idx) = snstvty(CNST.z_ref_idx,CNST.r_ref_idx);
            replace_idx = LES.Comb.C_field <= CNST.c_ref_mn;
            snstvty(replace_idx) = snstvty(1,1);
    
            snstvty = apply_smoothing_ignore_boundaries_1(snstvty,3,'all',1,1);
            SNST.comb.(fName) =  snstvty;
        end
    end
end