function [SPD, LES] = interp_from_spline(SPD, LES, varargin)
    p = inputParser;
    addParameter(p, 'type', 'dfdr');
    parse(p, varargin{:});  % For varargin-based functions
    deriv_type = p.Results.type;
    X_MAT = LES.Comb.C_field;
    X_MAT_n = LES.Noz.C_field; 
    Y_MAT = LES.Comb.Z;
    field_names = fieldnames(SPD);
    if strcmp(deriv_type,'dfdr')
        for i = 1:length(field_names)
            field_name = field_names{i};
            SPD.(field_name).comb.(deriv_type) = interp_from_spline_on_2D_data(SPD.(field_name).dpp, X_MAT);
            SPD.(field_name).noz.(deriv_type) = interp_from_spline_on_2D_data(SPD.(field_name).dpp, X_MAT_n,'grid','noz');
        end
    elseif strcmp(deriv_type,'dfdc')
        x_vec = 0:1e-2:1;
        y_vec = Y_MAT(:,1);
        clear X_MAT Y_MAT;
        [X_MAT,Y_MAT] = meshgrid(x_vec,y_vec);
        LES.Temp.X_MAT = X_MAT;
        LES.Temp.Y_MAT = Y_MAT;
        for i = 1:length(field_names)
            field_name = field_names{i};
            SPD.(field_name).comb.(deriv_type) = interp_from_spline_on_2D_data(SPD.(field_name).dpp, X_MAT);
        end
    elseif strcmp(deriv_type,'f')
        x_vec = 0:1e-2:1;
        y_vec = Y_MAT(:,1);
        clear X_MAT Y_MAT;
        [X_MAT,Y_MAT] = meshgrid(x_vec,y_vec);
        LES.Temp.X_MAT = X_MAT;
        LES.Temp.Y_MAT = Y_MAT;
        for i = 1:length(field_names)
            field_name = field_names{i};
            SPD.(field_name).comb.(deriv_type) = interp_from_spline_on_2D_data(SPD.(field_name).pp, X_MAT);
        end
    else
        fprintf('Incorrect type %d',deriv_type);
    end
end