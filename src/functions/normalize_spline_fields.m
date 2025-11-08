function [SPD] = normalize_spline_fields(SPD, GridName, CNST, field_names)
    % Normalize spline fields in SPD structure

    for i = 1:length(field_names)
        field_name = field_names{i};
        switch field_name
            case 'Heatrelease'
                % adding heat release norm field(different scaling from
                % hear release source term)
                fprintf('Normalizing field : %s\n',field_name);
                fname = 'HeatreleaseNorm';
                SPD.(fname) = SPD.(field_name);

                SPD.(fname).(GridName).dfdr = (CNST.model_scaling_factor .* SPD.(fname).(GridName).dfdr .* CNST.V_ref ) ./ CNST.Q_bar;
                SPD.(fname).(GridName).dfdc = (CNST.model_scaling_factor .* SPD.(fname).(GridName).dfdc .* CNST.V_ref ) ./ CNST.Q_bar;

                SPD.(field_name).(GridName).dfdr = (CNST.model_scaling_factor .* SPD.(field_name).(GridName).dfdr) ./ CNST.omega_dot_T_scaling;
                SPD.(field_name).(GridName).dfdc = (CNST.model_scaling_factor .* SPD.(field_name).(GridName).dfdc) ./ CNST.omega_dot_T_scaling;

            case 'Temperature'
                fprintf('Normalizing field : %s\n',field_name);
                SPD.(field_name).(GridName).dfdr = SPD.(field_name).(GridName).dfdr ./ CNST.T_ref;
                SPD.(field_name).(GridName).dfdc = SPD.(field_name).(GridName).dfdc ./ CNST.T_ref;

            case 'density'
                fprintf('Normalizing field : %s\n',field_name);
                SPD.(field_name).(GridName).dfdr = SPD.(field_name).(GridName).dfdr ./ CNST.rho_ref;
                SPD.(field_name).(GridName).dfdc = SPD.(field_name).(GridName).dfdc ./ CNST.rho_ref;

            otherwise
                % For species, no normalization needed
                fprintf('Normalizing field : %s\n',field_name);
                SPD.(field_name).(GridName).dfdr = (CNST.model_scaling_factor .* SPD.(field_name).(GridName).dfdr) ./ CNST.omega_dot_k_scaling;
                SPD.(field_name).(GridName).dfdc = (CNST.model_scaling_factor .* SPD.(field_name).(GridName).dfdc) ./ CNST.omega_dot_k_scaling;

        end
    end
end