function [SNST] = renormalize_Temp_sensitivity(SNST,CNST)
    GridsNames = fieldnames(SNST);
    factor = 1/(CNST.Yb - CNST.Yu);
    for i = 1:length(GridsNames)
        GridName = GridsNames{i};
        SNST.(GridName).Heatrelease = factor .* SNST.(GridName).Heatrelease;
        SNST.(GridName).HeatreleaseNorm = factor .* SNST.(GridName).HeatreleaseNorm;
    end
end