function [] = plot_f(SPD, GridName, LES, CNST)
    fieldNames = fieldnames(SPD);
    X_MAT = LES.Temp.(GridName).X_MAT;
    Y_MAT = LES.Temp.(GridName).Y_MAT;
    for i = 1:length(fieldNames)
        fName = fieldNames{i};
        data = SPD.(fName).(GridName).f;
        latex_label = SPD.(fName).latexLabel;
        fig_idx = 500 + i;
        plot_surface_field_1(X_MAT,Y_MAT./CNST.D,data,latex_label,'c','z/D',fig_idx);
    end
end