clear; clc; 
close all;
%%
addpath('~/MATLAB/');
addpath(genpath('/work/home/satyam/satyam_files/CH4_jet_PF/2025_Runs/Sensitivities/src/functions'));
addpath('/work/home/satyam/satyam_files/CH4_jet_PF/2025_Runs/Sensitivities/config');
%%
write_to_h5_file_flag = true;
plot_fields = false;
plot_sensitivities_flag = false;
h5filename = 'Reactants_41';
% Load paths and constants
sensitivity_constants_delc_0_1;  
% Load input field configurations
C_cond_field_name_source_terms_and_heatrelease; 
% Load LES data
[LES,Constant] = load_LES_mean_and_rms_data(Constant,Path,Filename,'T_mean');  
%% Fit spline to C cond field
fprintf('Fitting splines to C fields...\n');
Spline_fields = struct();
[C_MAT, ~] = get_C_cond_CZ_data(Path.InpDir1);
[Spline_fields] = fit_spline_for_C_cond_data(Spline_fields,"Comb",field_configs, Path.InpDir1, C_MAT);
[Spline_fields] = set_latex_labels(Spline_fields,field_configs);
[C_MAT_n, ~] = get_C_cond_CZ_data(Path.InpDir2);
[Spline_fields] = fit_spline_for_C_cond_data(Spline_fields,"Noz",field_configs, Path.InpDir2, C_MAT_n);
[Spline_fields] = set_latex_labels(Spline_fields,field_configs);
%%
[Spline_fields,LES] = compute_function_using_beta_pdf(Spline_fields,"Comb",LES,'type','f_rz','epsilon',1e-2);
[Spline_fields,LES] = compute_function_using_beta_pdf(Spline_fields,"Noz",LES,'type','f_rz','epsilon',1e-2);
%% Normalize fields
[Spline_fields] = normalize_spline_fields(Spline_fields, "Comb", Constant);
[Spline_fields] = normalize_spline_fields(Spline_fields, "Noz", Constant);
%% Plot dfdr
if plot_fields
    plot_dfdr(Spline_fields, "Comb", LES, Constant);
        plot_f_rz(Spline_fields, "Comb", LES, Constant);
%         plot_dfdr(Spline_fields, LES, Constant,'grid','noz');
    plot_f(Spline_fields,"Comb", LES, Constant);
    plot_f(Spline_fields,"Noz", LES, Constant);
    plot_dfdc(Spline_fields,"Comb", LES, Constant);
%     plot_dfdc(Spline_fields,"Noz", LES, Constant);
end
%% Populate sensitivities structure
Sensitivities = struct();
fieldNames = fieldnames(Spline_fields);
nfields = size(fieldNames,1);
for i = 1:nfields
    Sensitivities.Comb.(fieldNames{i}) = Spline_fields.(fieldNames{i}).Comb.f_rz;
    Sensitivities.Noz.(fieldNames{i}) = Spline_fields.(fieldNames{i}).Noz.f_rz;
end
%% Plot hrr norm and src term sensitivities
% plot_sensitivities(Sensitivities, LES.Comb.R1, LES.Comb.Z1, Constant);
%%
[Sensitivities] = renormalize_Temp_sensitivity(Sensitivities,Constant);
Sensitivities.Comb.C_field = LES.Comb.C_field;
Sensitivities.Noz.C_field = LES.Noz.C_field;
%% Plotting
if plot_sensitivities_flag
%     plot_sensitivities(Sensitivities, LES.Comb.R, LES.Comb.Z, Constant);
        plot_sensitivities(Sensitivities_test, LES.Temp.X_MAT, LES.Temp.Y_MAT, Constant, 40);
end
%%  Write to H5 file
if write_to_h5_file_flag
    fprintf('\n=== Writing to H5 File ===\n');
    processed_fields = fieldnames(Sensitivities.Comb);
    N_fields = length(processed_fields);
% 
    try
        write_field_to_h5_file(processed_fields, N_fields, Sensitivities.Comb, Sensitivities.Noz, LES.Comb, LES.Noz, Path.H5Outdir, h5filename);
        fprintf('✓ Successfully wrote to H5 file: %s/%s.h5\n', Path.H5Outdir, h5filename);
    catch ME
        fprintf('✗ Error writing to H5 file: %s\n', ME.message);
    end
end