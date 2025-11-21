function [SNST] = renormalize_Temp_sensitivity(SNST,CNST)
    GridsNames = fieldnames(SNST);
    FName = {'wT_p';'Heatrelease';'SYm_CH4';'SYm_O2';'SYm_CO2';'SYm_H2O'};
    factor = (CNST.Yu)/(CNST.Yb - CNST.Yu);
    for i = 1:length(GridsNames)
        GridName = GridsNames{i}
        for j = 1:length(FName)
            fprintf("Normalizing %s \n",FName{j});
            SNST.(GridName).(FName{j})= factor .* SNST.(GridName).(FName{j});
%             if strcmp(FName{j},'SYm_CH4')
%                 max_val = max(max(abs(SNST.(GridName).(FName{j}))));
%                 SNST.(GridName).(FName{j}) = SNST.(GridName).(FName{j}) ./ max_val;
%             end
        end
    end
end