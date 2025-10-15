function [] = plot_dfdr(SPD, LES, CNST)
    fieldNames = fieldnames(SPD);
    X_MAT = LES.Comb.R1;
    Y_MAT = LES.Comb.Z1;
    for i = 1:length(fieldNames)
        fName = fieldNames{i};
        data = SPD.(fName).comb.dfdr;
        latex_label = SPD.(fName).latexLabel;
        fig_idx = 100 + i;
        plot_surface_field(X_MAT,Y_MAT./CNST.D,data,latex_label,'r/D','z/D', 'r',fig_idx);
    end
end