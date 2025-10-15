clear; clc; 
close all;
%%
addpath('~/MATLAB/');
addpath('/work/home/satyam/satyam_files/CH4_jet_PF/2025_Runs/Sensitivities/src/functions');
addpath('/work/home/satyam/satyam_files/CH4_jet_PF/2025_Runs/Sensitivities/config');
%%
write_to_h5_file_flag = true;
h5filename = 'Reactants_6';
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
% plot_dfdr(Spline_fields, LES, Constant);
% plot_dfdc(Spline_fields, LES, Constant);

%% Compute hrr norm sensitivities
Sensitivities = struct();
[Sensitivities] = compute_hrr_norm_sensitivities(Sensitivities,Spline_fields, LES, Constant);

%% Plot hrr norm sensitivities
% plot_sensitivities(Sensitivities, LES.Comb.R1, LES.Comb.Z1, Constant);

%%  Compute hrr src term sensitivities
[Sensitivities] = compute_hrr_src_term_sensitivities(Sensitivities,Spline_fields, LES, Constant);

%% Plot hrr norm and src term sensitivities
% plot_sensitivities(Sensitivities, LES.Comb.R1, LES.Comb.Z1, Constant);

%%  Compute chem src terms sensitivities
[Sensitivities] = compute_chem_src_term_sensitivities(Sensitivities,Spline_fields, LES, Constant);

%% Set nozzle sensitivities 
[Sensitivities] = set_noz_sensitivities(Sensitivities,LES.Noz);

%% Plotting
plot_sensitivities(Sensitivities, LES.Comb.R, LES.Comb.Z, Constant);

%%  Write to H5 file
if write_to_h5_file_flag
    fprintf('\n=== Writing to H5 File ===\n');
    processed_fields = fieldnames(Sensitivities.comb);
    N_fields = length(processed_fields);
% 
    try
        write_field_to_h5_file(processed_fields, N_fields, Sensitivities.comb, Sensitivities.noz, LES.Comb, LES.Noz, Path.H5Outdir, h5filename);
        fprintf('✓ Successfully wrote to H5 file: %s/%s.h5\n', Path.H5Outdir, h5filename);
    catch ME
        fprintf('✗ Error writing to H5 file: %s\n', ME.message);
    end
end