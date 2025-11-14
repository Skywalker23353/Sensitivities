function [SNST] = compute_all_sensitivities(SNST, SPD, GridName, LES, CNST, fName_numrtr, fName_denom,varargin)
    % Input parsing for optional remove_spikes
    p = inputParser;
    addParameter(p,'remove_spikes',false, @(x) islogical(x) || isnumeric(x));
    parse(p,varargin{:});
    remove_spikes = p.Results.remove_spikes;
    % Main computation
    for j = 1:length(fName_numrtr)
        numrtr = SPD.(fName_numrtr{j}).(GridName).dfdr;

        for i = 1:length(fName_denom)
            i
            fName = sprintf('d%s_d%s',SPD.(fName_numrtr{j}).opname,SPD.(fName_denom{i}).opname);
    
            denomtr = SPD.(fName_denom{i}).(GridName).dfdr;
            
            snstvty = compute_sensitivities(numrtr,denomtr);

%             snstvty = remove_spikes_interp2D(snstvty, 10);
%             snstvty_n = remove_spikes_interp2D(snstvty_n,10);

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
            if ~strcmp(GridName,'Noz')
                if strcmp(fName_denom{i},'CH4')
                    replace_idx = LES.(GridName).C_field >= CNST.CH4_c_ref_mx;
                    snstvty(replace_idx) = snstvty(CNST.CH4_z_ref_idx,CNST.CH4_r_ref_idx);
                    clear replace_idx;
                    replace_idx = LES.(GridName).C_field <= CNST.c_ref_mn;
                    snstvty(replace_idx) = snstvty(1,1);
    
                else
                    replace_idx = LES.(GridName).C_field >= CNST.c_ref_mx;
                    snstvty(replace_idx) = snstvty(CNST.z_ref_idx,CNST.r_ref_idx);
    
                    replace_idx = LES.(GridName).C_field <= CNST.c_ref_mn;
                    snstvty(replace_idx) = snstvty(1,1);
                end
            end
    
            snstvty = apply_smoothing_ignore_boundaries_1(snstvty,3,'all',1,1);

            SNST.(GridName).(fName) =  snstvty;
        end
        if ~strcmp(GridName,'Noz')
            replace_idx = LES.(GridName).C_field >= CNST.c_ref_mx;
            numrtr(replace_idx) = numrtr(CNST.z_ref_idx,CNST.r_ref_idx);
        
            replace_idx = LES.(GridName).C_field <= CNST.c_ref_mn;
            numrtr(replace_idx) = numrtr(1,1);
        end
        SNST.(GridName).(fName_numrtr{j}) = numrtr;
    end
end