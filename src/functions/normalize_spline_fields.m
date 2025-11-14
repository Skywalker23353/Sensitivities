function [SPD] = normalize_spline_fields(SPD, GridName, CNST)
    % Normalize spline fields in SPD structure
    field_names = fieldnames(SPD);
    for i = 1:length(field_names)
        field_name = field_names{i};
        switch true
            case contains(field_name,'wT_p')
                fprintf('Normalizing field : %s\n',field_name);
                SPD.(field_name).(GridName).dfdr = (CNST.model_scaling_factor .* SPD.(field_name).(GridName).dfdr) ./ CNST.omega_dot_T_scaling;
                SPD.(field_name).(GridName).dfdc = (CNST.model_scaling_factor .* SPD.(field_name).(GridName).dfdc) ./ CNST.omega_dot_T_scaling;
            case contains(field_name,'wT')
                fprintf('Normalizing field : %s\n',field_name);
                SPD.(field_name).(GridName).dfdr = (CNST.model_scaling_factor .* SPD.(field_name).(GridName).dfdr) ./ CNST.omega_dot_T_scaling;
                SPD.(field_name).(GridName).dfdc = (CNST.model_scaling_factor .* SPD.(field_name).(GridName).dfdc) ./ CNST.omega_dot_T_scaling;
            case contains(field_name,'Heatrelease')
                fprintf('Normalizing field : %s\n',field_name);
                SPD.(field_name).(GridName).dfdr = (CNST.model_scaling_factor .* SPD.(field_name).(GridName).dfdr .* CNST.V_ref ) ./ CNST.Q_bar;
                SPD.(field_name).(GridName).dfdc = (CNST.model_scaling_factor .* SPD.(field_name).(GridName).dfdc .* CNST.V_ref ) ./ CNST.Q_bar;
            case contains(field_name,'Temperature')
                fprintf('No dnrmalizing field : %s\n',field_name);
                SPD.(field_name).(GridName).dfdr = SPD.(field_name).(GridName).dfdr ./ CNST.T_ref;
                SPD.(field_name).(GridName).dfdc = SPD.(field_name).(GridName).dfdc ./ CNST.T_ref;
            case contains(field_name,'density')
                fprintf('Normalizing field : %s\n',field_name);
                SPD.(field_name).(GridName).dfdr = SPD.(field_name).(GridName).dfdr ./ CNST.rho_ref;
                SPD.(field_name).(GridName).dfdc = SPD.(field_name).(GridName).dfdc ./ CNST.rho_ref;
            case contains(field_name,'SYm')
                fprintf('Normalizing field : %s\n',field_name);
                SPD.(field_name).(GridName).dfdr = (CNST.model_scaling_factor .* SPD.(field_name).(GridName).dfdr) ./ CNST.omega_dot_k_scaling;
                SPD.(field_name).(GridName).dfdc = (CNST.model_scaling_factor .* SPD.(field_name).(GridName).dfdc) ./ CNST.omega_dot_k_scaling;
            otherwise
                fprintf('Normalizing factor does not exist for field : %s\n',field_name);
        end
    end
end