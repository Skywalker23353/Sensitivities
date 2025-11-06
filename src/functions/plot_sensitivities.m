function [] = plot_sensitivities(SNST,X_MAT, Y_MAT,CNST,nplimit)
    fieldNames = fieldnames(SNST.comb);
    nFields = length(fieldNames);
    if nplimit < nFields
        nFields = nplimit
    end
    for i = 1:nFields
        fieldName = fieldNames{i};
        data = SNST.comb.(fieldName);
        fName = split(fieldName,'_');
        tl1 = fName{1}; tl1 = strrep(tl1,'d',' ');
        tl2 = fName{2}; tl2 = strrep(tl2,'d',' ');
        fig_idx = 300 + i;
%         plot_surface_field(X_MAT./CNST.D, Y_MAT./CNST.D, data, tl1, 'r/D', 'z/D', tl2, fig_idx);
                plot_surface_field(X_MAT, Y_MAT./CNST.D, data, tl1, 'c', 'z/D', tl2, fig_idx);

    end
end