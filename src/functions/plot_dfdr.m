function [] = plot_dfdr(SPD, GridName, LES, CNST)
    p = inputParser;
    fieldNames = fieldnames(SPD);
    X_MAT = LES.(GridName).R;
    Y_MAT = LES.(GridName).Z;
    for i = 1:length(fieldNames)
        fName = fieldNames{i};
        data = SPD.(fName).(GridName).dfdr;
        latex_label = SPD.(fName).latexLabel;
        fig_idx = 100 + i;
        plot_surface_field(X_MAT,Y_MAT./CNST.D,data,latex_label,'r/D','z/D', 'r',fig_idx);
    end  
end