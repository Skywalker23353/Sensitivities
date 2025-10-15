clear; clc; 
close all;
%%
addpath('~/MATLAB/');
addpath('/work/home/satyam/satyam_files/CH4_jet_PF/2025_Runs/Sensitivities/src/functions');
addpath('/work/home/satyam/satyam_files/CH4_jet_PF/2025_Runs/Sensitivities/config');
%%
write_to_h5_file_flag = true;
h5filename = 'Reactants_9';
% Load paths and constants
sensitivity_constants_fine;  
% Load input field configurations
C_cond_field_name; 
% Load LES data
[LES,Constant] = load_LES_mean_data(Constant,Path,Filename); 
%% Fit spline to C cond field
fprintf('Fitting splines to C fields...\n');
[C_MAT, ~] = get_C_cond_CZ_data(Path.InpDir);
[Spline_fields] = fit_spline_for_C_cond_data(field_configs, Path.InpDir, C_MAT);
[Spline_fields] = set_latex_labels(Spline_fields,field_configs);
%% Interpolate from splines to LES grid
[Spline_fields, LES] = interp_from_spline(Spline_fields, LES,'type','dfdr');
%% Interpolate from splines to temporary grid
[Spline_fields, LES] = interp_from_spline(Spline_fields, LES,'type','dfdc');

%% Plot dfdr
% plot_dfdr(Spline_fields, LES, Constant);
% plot_dfdc(Spline_fields, LES, Constant);

%% Compute hrr norm sensitivities
Sensitivities = struct();
threshold.CH4 = 100;
threshold.T = 1e4;
[Sensitivities] = compute_hrr_norm_sensitivities(Sensitivities,Spline_fields, LES, Constant, threshold);

%% Plot hrr norm sensitivities
% plot_sensitivities(Sensitivities, LES.Comb.R1, LES.Comb.Z1, Constant);

%%  Compute hrr src term sensitivities
threshold.C = 1e4;
[Sensitivities] = compute_hrr_src_term_sensitivities(Sensitivities,Spline_fields, LES, Constant, threshold);

%% Plot hrr norm and src term sensitivities
% plot_sensitivities(Sensitivities, LES.Comb.R1, LES.Comb.Z1, Constant);

%%  Compute chem src terms sensitivities
[Sensitivities] = compute_chem_src_term_sensitivities(Sensitivities,Spline_fields, LES, Constant);

%% Set nozzle sensitivities 
[Sensitivities] = set_noz_sensitivities(Sensitivities,LES.Noz);

%% Plotting
% plot_sensitivities(Sensitivities, LES.Comb.R, LES.Comb.Z, Constant);

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