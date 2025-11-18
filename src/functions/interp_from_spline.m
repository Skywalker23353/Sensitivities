function [SPD, LES] = interp_from_spline(SPD, GridName, LES, varargin)
    p = inputParser;
    addParameter(p, 'type', 'dfdc_rz');
    parse(p, varargin{:});  % For varargin-based functions
    deriv_type = p.Results.type;
    X_MAT = LES.(GridName).C_field; 
    Y_MAT = LES.(GridName).Z;
    field_names = fieldnames(SPD);
    if strcmp(deriv_type,'dfdc_rz')
        for i = 1:length(field_names)
            field_name = field_names{i};
            SPD.(field_name).(GridName).(deriv_type) = interp_from_spline_on_2D_data(SPD.(field_name).(GridName).dpp, X_MAT);
        end
    elseif strcmp(deriv_type,'f_rz')
        for i = 1:length(field_names)
            field_name = field_names{i};
            SPD.(field_name).(GridName).(deriv_type) = interp_from_spline_on_2D_data(SPD.(field_name).(GridName).pp, X_MAT);
        end
    elseif strcmp(deriv_type,'dfdc')
        x_vec = 0:1e-2:1;
        y_vec = Y_MAT(:,1);
        clear X_MAT Y_MAT ;
        [X_MAT,Y_MAT] = meshgrid(x_vec,y_vec);
        LES.Temp.(GridName).X_MAT = X_MAT;
        LES.Temp.(GridName).Y_MAT = Y_MAT;
        for i = 1:length(field_names)
            field_name = field_names{i};
            SPD.(field_name).(GridName).(deriv_type) = interp_from_spline_on_2D_data(SPD.(field_name).(GridName).dpp, X_MAT);
        end
    elseif strcmp(deriv_type,'f')
        x_vec = 0:1e-2:1;
        y_vec = Y_MAT(:,1);
        clear X_MAT Y_MAT;
        [X_MAT,Y_MAT] = meshgrid(x_vec,y_vec);
        LES.Temp.(GridName).X_MAT = X_MAT;
        LES.Temp.(GridName).Y_MAT = Y_MAT;
        for i = 1:length(field_names)
            field_name = field_names{i};
            SPD.(field_name).(GridName).(deriv_type) = interp_from_spline_on_2D_data(SPD.(field_name).(GridName).pp, X_MAT);
        end
    else
        fprintf('Incorrect type %d',deriv_type);
    end
end