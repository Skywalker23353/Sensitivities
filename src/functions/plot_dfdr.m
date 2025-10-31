function [] = plot_dfdr(SPD, LES, CNST,varargin)
    p = inputParser;
    addParameter(p,'grid','comb');
    parse(p,varargin{:});
    grid = p.Results.grid;
    fieldNames = fieldnames(SPD);
    if strcmp(grid,'noz')
        X_MAT = LES.Noz.R;
        Y_MAT = LES.Noz.Z;
        for i = 1:length(fieldNames)
            fName = fieldNames{i};
            data = SPD.(fName).noz.dfdr;
            latex_label = SPD.(fName).latexLabel;
            fig_idx = 100 + i;
            plot_surface_field(X_MAT,Y_MAT./CNST.D,data,latex_label,'r/D','z/D', 'r',fig_idx);
        end
    else
        X_MAT = LES.Comb.R;
        Y_MAT = LES.Comb.Z;
        for i = 1:length(fieldNames)
            fName = fieldNames{i};
            data = SPD.(fName).comb.dfdr;
            latex_label = SPD.(fName).latexLabel;
            fig_idx = 100 + i;
            plot_surface_field(X_MAT,Y_MAT./CNST.D,data,latex_label,'r/D','z/D', 'r',fig_idx);
        end
    end
end