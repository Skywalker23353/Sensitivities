function [Spline_fields] = fit_spline_for_C_cond_data(field_names, path, C_MAT)
    % Fit splines for the specified C fields
    Spline_fields = struct();
    for i = 1:length(field_names)
        field_name = field_names{i};
        fprintf('Fitting spline for %s...\n', field_name);
        load(fullfile(path, [field_name, '.mat']), "DF");
        if ismember(field_name, {'SYm_CH4','SYm_CH2O','SYm_CH3','SYm_CO', 'SYm_O2', 'SYm_CO2', 'SYm_H2O', 'SYm_H2', 'SYm_H', 'SYm_HO2', 'SYm_O', 'SYm_OH'})
            clamp_flag = true; % Clamping for reaction rates
        else
            clamp_flag = false; % No clamping for other fields
        end
        [dpp, pp] = fit_spline_and_diff_2D_data(C_MAT, DF, 'clamping', clamp_flag, 'derivative_order', 1, 'fit_dimension', 1);
        Spline_fields.(field_name).pp = pp;
        Spline_fields.(field_name).dpp = dpp;
        clear field dpp pp;
    end
end
