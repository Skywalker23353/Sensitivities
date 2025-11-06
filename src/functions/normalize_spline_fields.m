function [SPD] = normalize_spline_fields(SPD, CNST, field_names)
    % Normalize spline fields in SPD structure

    for i = 1:length(field_names)
        field_name = field_names{i};
        switch field_name
            case 'Heatrelease'
                % adding heat release norm field(different scaling from
                % hear release source term)
                fname = 'HeatreleaseNorm';
                SPD.(fname) = SPD.(field_name);

                SPD.(fname).comb.dfdr = (CNST.model_scaling_factor .* SPD.(fname).comb.dfdr .* CNST.V_ref ) ./ CNST.Q_bar;
                SPD.(fname).comb.dfdc = (CNST.model_scaling_factor .* SPD.(fname).comb.dfdc .* CNST.V_ref ) ./ CNST.Q_bar;

                SPD.(field_name).comb.dfdr = (CNST.model_scaling_factor .* SPD.(field_name).comb.dfdr) ./ CNST.omega_dot_T_scaling;
                SPD.(field_name).comb.dfdc = (CNST.model_scaling_factor .* SPD.(field_name).comb.dfdc) ./ CNST.omega_dot_T_scaling;

                SPD.(fname).noz.dfdr = (CNST.model_scaling_factor .* SPD.(fname).noz.dfdr .* CNST.V_ref ) ./ CNST.Q_bar;
                SPD.(fname).noz.dfdc = (CNST.model_scaling_factor .* SPD.(fname).noz.dfdc .* CNST.V_ref ) ./ CNST.Q_bar;

                SPD.(field_name).noz.dfdr = (CNST.model_scaling_factor .* SPD.(field_name).noz.dfdr) ./ CNST.omega_dot_T_scaling;
                SPD.(field_name).noz.dfdc = (CNST.model_scaling_factor .* SPD.(field_name).noz.dfdc) ./ CNST.omega_dot_T_scaling;
            case 'Temperature'
                SPD.(field_name).comb.dfdr = SPD.(field_name).comb.dfdr ./ CNST.T_ref;
                SPD.(field_name).comb.dfdc = SPD.(field_name).comb.dfdc ./ CNST.T_ref;

                SPD.(field_name).noz.dfdr = SPD.(field_name).noz.dfdr ./ CNST.T_ref;
                SPD.(field_name).noz.dfdc = SPD.(field_name).noz.dfdc ./ CNST.T_ref;
            case 'density'
                SPD.(field_name).comb.dfdr = SPD.(field_name).comb.dfdr ./ CNST.rho_ref;
                SPD.(field_name).comb.dfdc = SPD.(field_name).comb.dfdc ./ CNST.rho_ref;

                SPD.(field_name).noz.dfdr = SPD.(field_name).noz.dfdr ./ CNST.rho_ref;
                SPD.(field_name).noz.dfdc = SPD.(field_name).noz.dfdc ./ CNST.rho_ref;
            case {'SYm_CH4','SYm_O2','SYm_CO2','SYm_H2O'}
                SPD.(field_name).comb.dfdr = (CNST.model_scaling_factor .* SPD.(field_name).comb.dfdr) ./ CNST.omega_dot_k_scaling;
                SPD.(field_name).comb.dfdc = (CNST.model_scaling_factor .* SPD.(field_name).comb.dfdc) ./ CNST.omega_dot_k_scaling;

                SPD.(field_name).noz.dfdr = (CNST.model_scaling_factor .* SPD.(field_name).noz.dfdr) ./ CNST.omega_dot_k_scaling;
                SPD.(field_name).noz.dfdc = (CNST.model_scaling_factor .* SPD.(field_name).noz.dfdc) ./ CNST.omega_dot_k_scaling;

            otherwise
                % For species, no normalization needed
        end
    end
end