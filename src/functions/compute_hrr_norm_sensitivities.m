function [SNST] = compute_hrr_norm_sensitivities(SPD, CNST)
    eps = 1e-8;
    SNST = struct();
    fName_numrtr = 'Heatrelease';
    fName_denom = {'density','Temperature','CH4','O2','CO2','H2O'};
    nmrtr = SPD.(fName_numrtr).comb.dfdr./ CNST.Q_bar;
    for i = 1:length(fName_denom)
        fName = sprintf('d%sn_d%s',SPD.(fName_numrtr).opname,SPD.(fName_denom{i}).opname);
        denomtr = SPD.(fName_denom{i}).comb.dfdr + eps;
        if strcmp(fName_denom{i},'Temperature')
            denomtr = denomtr ./ CNST.T_ref;
        elseif strcmp(fName_denom{i},'density')
            denomtr = denomtr ./ CNST.rho_ref;
        end
        SNST.comb.(fName) =  nmrtr./ (denomtr + eps);
    end
end