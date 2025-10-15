function [] = plot_dfdc(SPD, LES, CNST)
    fieldNames = fieldnames(SPD);
    X_MAT = LES.Temp.X_MAT;
    Y_MAT = LES.Temp.Y_MAT;
    for i = 1:length(fieldNames)
        fName = fieldNames{i};
        data = SPD.(fName).comb.dfdc;
        latex_label = SPD.(fName).latexLabel;
        fig_idx = 200 + i;
        plot_surface_field(X_MAT,Y_MAT./CNST.D,data,latex_label,'c','z/D', 'c',fig_idx);
    end
end