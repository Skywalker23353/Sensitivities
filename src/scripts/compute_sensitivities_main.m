clear; clc; close all;
%%
addpath('../functions');
addpath('../config');
% Load paths and constants
sensitivity_constants;  %adding vars to workspace
% Load input field configurations
field_config_Norm_sensitivites; % Load field configurations
% Load LES data
getLESdata; % Load LES data and compute C fields
%% Fit spline to C cond field
Spline_fields = struct();
fprintf('Fitting splines to C fields...\n');
for i = 1:length(field_configs)
    field_name = field_configs{i, 1};
    fprintf('Fitting spline for %s...\n', field_name);
    field = load(fullfile(InpDir, [field_name, '.mat']),"DF");
    if ismember(field_name, {'SYm_CH4', 'SYm_O2', 'SYm_CO2', 'SYm_H2O'})
        clamp_flag = true; % Clamping for reaction rates
    else
        clamp_flag = false; % No clamping for other fields
    end
    [dpp,pp] = fit_spline_and_diff_2D_data(LES.comb.C_field, field.DF, 'clamping', clamp_flag, 'derivative_order', 1, 'fit_dimension', 1);
    Spline_fields.(field_name).pp = pp;
    Spline_fields.(field_name).dpp = dpp;
    clear field dpp pp;
end


