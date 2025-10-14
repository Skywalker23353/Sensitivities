clear; clc; close all;
%%
addpath('~/MATLAB/');
addpath('/work/home/satyam/satyam_files/CH4_jet_PF/2025_Runs/Sensitivities/src/functions');
addpath('/work/home/satyam/satyam_files/CH4_jet_PF/2025_Runs/Sensitivities/config');
%%
% Load paths and constants
sensitivity_constants;  %adding vars to workspace
% Load input field configurations
C_cond_field_name; % Load field configurations
% Load LES data
getLESdata; % Load LES data and compute C fields
%% Fit spline to C cond field
fprintf('Fitting splines to C fields...\n');
[C_MAT, ~] = get_C_cond_CZ_data(Path.InpDir);
[Spline_fields] = fit_spline_for_C_cond_data(field_configs, Path.InpDir, C_MAT);
[Spline_fields] = set_latex_labels(Spline_fields,field_configs);
[Spline_fields, LES] = interp_from_spline(Spline_fields, LES,'type','dfdr');
[Spline_fields, LES] = interp_from_spline(Spline_fields, LES,'type','dfdc');
%% Plot dfdr
plot_dfdr(Spline_fields, LES, Constant);
% plot_dfdc(Spline_fields, LES, Constant);
%% Compute sensitivities
[Sensitivities] = compute_hrr_norm_sensitivities(Spline_fields, Constant);
%% Plot sensitivities
plot_sensitivities(Sensitivities, LES, Constant);




% [Sensitivities] = compute_hrr_norm_sensitivities(Spline_fields, Constant);