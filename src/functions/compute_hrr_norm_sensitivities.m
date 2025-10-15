function [SNST] = compute_hrr_norm_sensitivities(SNST, SPD, LES, CNST, threshold)
    fName_numrtr = 'Heatrelease';
    fName_denom = {'density','Temperature','CH4','O2','CO2','H2O'};
    
    data = SPD.(fName_numrtr).comb.dfdr;
    numrtr = (CNST.model_scaling_factor .* data .* CNST.V_ref )./ CNST.Q_bar;
    
    for i = 1:length(fName_denom)
        fName = sprintf('d%sn_d%s',SPD.(fName_numrtr).opname,SPD.(fName_denom{i}).opname);

        denomtr = SPD.(fName_denom{i}).comb.dfdr;
        % Normalization
        if strcmp(fName_denom{i},'Temperature')
            denomtr = denomtr ./ CNST.T_ref;
        elseif strcmp(fName_denom{i},'density')
            denomtr = denomtr ./ CNST.rho_ref;
        end
        
        snstvty = compute_sensitivities(numrtr,denomtr);

        % Limit sensitivities to avoid outliers
        if strcmp(fName_denom{i},'Temperature') && isfield(threshold,'T')
            snstvty(abs(snstvty) >= threshold.T) = threshold.T;
        elseif strcmp(fName_denom{i},'CH4') && isfield(threshold,'CH4')
            snstvty(abs(snstvty) >= threshold.CH4) = threshold.CH4;
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