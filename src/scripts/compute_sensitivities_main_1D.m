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
h5filename = 'Reactants_40';
% Load paths and constants
sensitivity_constants_1D_dataset;  
% Load input field configurations
C_cond_field_name_with_all_minor; 
% Load LES data
[LES,Constant] = load_LES_mean_data(Constant,Path,Filename,'T_mean');  
%% Fit spline to C cond field
fprintf('Fitting splines to C fields...\n');
Spline_fields = struct();
[C_MAT, ~] = get_C_cond_CZ_data(Path.InpDir1);
[Spline_fields] = fit_spline_for_C_cond_data(Spline_fields,"Comb",field_configs, Path.InpDir1, C_MAT);
[Spline_fields] = set_latex_labels(Spline_fields,field_configs);
[C_MAT_n, ~] = get_C_cond_CZ_data(Path.InpDir2);
% [Spline_fields] = fit_spline_for_C_cond_data(Spline_fields,"Noz",field_configs, Path.InpDir2, C_MAT_n);
% [Spline_fields] = set_latex_labels(Spline_fields,field_configs);
%% Interpolate from splines to LES grid
[Spline_fields, LES] = interp_from_spline(Spline_fields,"Comb", LES,'type','dfdc_rz');
% [Spline_fields, LES] = interp_from_spline(Spline_fields,"Noz", LES,'type','dfdc_rz');
%% Interpolate from splines to temporary grid
[Spline_fields, LES] = interp_from_spline(Spline_fields,"Comb", LES,'type','dfdc');
% [Spline_fields, LES] = interp_from_spline(Spline_fields,"Noz", LES,'type','dfdc');
%% Interpolate from splines to temporary grid
[Spline_fields, LES] = interp_from_spline(Spline_fields,"Comb", LES,'type','f');
% [Spline_fields, LES] = interp_from_spline(Spline_fields,"Noz", LES,'type','f');
%% ADD HeatreleaseNorm field
% [Spline_fields] = add_hrr_norm_field(Spline_fields);
%% Normalize fields
[Spline_fields] = normalize_spline_fields(Spline_fields, "Comb", Constant);
% [Spline_fields] = normalize_spline_fields(Spline_fields, "Noz", Constant);
%% Plot dfdr
if plot_fields
    plot_dfdr(Spline_fields, "Comb", LES, Constant);
%         plot_dfdr(Spline_fields, LES, Constant,'grid','noz');
    plot_f(Spline_fields,"Comb", LES, Constant);
    plot_f(Spline_fields,"Noz", LES, Constant);
    plot_dfdc(Spline_fields,"Comb", LES, Constant);
%     plot_dfdc(Spline_fields,"Noz", LES, Constant);
end
%%
% fName_denom = {'density','Temperature','CH4','O2','CO2','H2O','N2'};
fName_denom = {'density','Temperature','CH4','O2','CO2','H2O'};%,'CH2O','CH3','CO','H','H2','HO2','O','OH'};
%% Find dYCH4_dc at thresholding values
[Constant] = find_dq_dc_at_threshold(Spline_fields,'Comb','CH4',Constant);
%% Compute sensitivities
Sensitivities = struct();
fName_numrtr = {'wT_p';'wT';'Heatrelease';'SYm_CH4';'SYm_O2';'SYm_CO2';'SYm_H2O'};%'SYm_CH2O';'SYm_H2';'SYm_CH3';'SYm_CO';;'SYm_HO2';'SYm_H';'SYm_O';'SYm_OH';
[Sensitivities] = compute_all_sensitivities(Sensitivities,Spline_fields,'Comb', LES, Constant, fName_numrtr,fName_denom);
[Sensitivities] = compute_all_sensitivities(Sensitivities,Spline_fields,'Noz', LES, Constant, fName_numrtr,fName_denom);
%%
% %% Compute hrr norm sensitivities
% Sensitivities = struct();
% Sensitivities_test = struct();
% Thld.dT = 0.2;
% Thld.dCH4 = 30;
% Thld.dN2 = 100;
% fName_numrtr = 'Heatrelease';
% [Sensitivities] = compute_hrr_norm_sensitivities(Sensitivities,Spline_fields,'Comb', LES, Constant, fName_numrtr,fName_denom);
% [Sensitivities] = compute_hrr_norm_sensitivities(Sensitivities,Spline_fields,'Noz', LES, Constant, fName_numrtr,fName_denom);

% [Sensitivities_test] = compute_hrr_norm_sensitivities_temp(Sensitivities_test,Spline_fields,'Comb', LES, Constant,fName_numrtr,fName_denom);
% [Sensitivities_test] = compute_hrr_norm_sensitivities_temp(Sensitivities_test,Spline_fields,'Noz', LES, Constant,fName_numrtr,fName_denom);

%% Plot hrr norm sensitivities
% plot_sensitivities(Sensitivities, LES.Comb.R1, LES.Comb.Z1, Constant);

%%  Compute hrr src term sensitivities
% Thld.dT = 0.31;
% Thld.dN2 = 100;
% fName_numrtr = 'Heatrelease';
% [Sensitivities] = compute_hrr_src_term_sensitivities(Sensitivities,Spline_fields, 'Comb', LES, Constant, fName_numrtr,fName_denom);
% [Sensitivities] = compute_hrr_src_term_sensitivities(Sensitivities,Spline_fields, 'Noz', LES, Constant, fName_numrtr,fName_denom);

% [Sensitivities_test] = compute_hrr_src_term_sensitivities_test(Sensitivities_test,Spline_fields,'Comb', LES, Constant, fName_numrtr,fName_denom);
% [Sensitivities_test] = compute_hrr_src_term_sensitivities_test(Sensitivities_test,Spline_fields,'Noz', LES, Constant, fName_numrtr,fName_denom);

%% Plot hrr norm and src term sensitivities
% plot_sensitivities(Sensitivities, LES.Comb.R1, LES.Comb.Z1, Constant);

%%  Compute chem src terms sensitivities
% [Sensitivities] = compute_chem_src_term_sensitivities(Sensitivities,Spline_fields, LES, Constant,'remove_spikes',true);
% fName_numrtr = {'SYm_CH4';'SYm_O2';'SYm_CO2';'SYm_H2O'};%'SYm_CH2O';'SYm_H2';'SYm_CH3';'SYm_CO';;'SYm_HO2';'SYm_H';'SYm_O';'SYm_OH';
% [Sensitivities] = compute_chem_src_term_sensitivities(Sensitivities,Spline_fields,'Comb', LES, Constant, fName_numrtr,fName_denom);
% [Sensitivities] = compute_chem_src_term_sensitivities(Sensitivities,Spline_fields,'Noz', LES, Constant, fName_numrtr,fName_denom);
% [Sensitivities_test] = compute_chem_src_term_sensitivities_test(Sensitivities_test,Spline_fields, LES, Constant, fName_numrtr,fName_denom);
%% Subtract N2 sensitivities from all sensitivities
% [Sensitivities] = subtract_N2_sensitivities(Sensitivities);

%% Set nozzle sensitivities 
% [Sensitivities] = set_noz_sensitivities(Sensitivities,LES.Noz);
%%
[Sensitivities] = renormalize_Temp_sensitivity(Sensitivities,Constant);
Sensitivities.Comb.C_field = LES.Comb.C_field;
Sensitivities.Noz.C_field = LES.Noz.C_field;
%% Plotting
if plot_sensitivities_flag
%     plot_sensitivities(Sensitivities, LES.Comb.R, LES.Comb.Z, Constant);
        plot_sensitivities(Sensitivities_test, LES.Temp.X_MAT, LES.Temp.Y_MAT, Constant, 40);
end
%% Reshape fields 
% [Sensitivities,LES] = reshape_sensitivities_and_grid(Sensitivities,LES);
% [Sensitivities] = smooth_sensitivities_near_dump_plane(Sensitivities,LES.Inner);
% % Write to h5
% if write_to_h5_file_flag
%     fprintf('\n=== Writing to H5 File ===\n');
%     processed_fields = fieldnames(Sensitivities.Inner);
%     N_fields = length(processed_fields);
% % 
%     try
%         write_field_to_h5_file_reshaped(processed_fields, N_fields, Sensitivities.Inner, Sensitivities.Outer, LES.Inner, LES.Outer, Path.H5Outdir, h5filename);
%         fprintf('✓ Successfully wrote to H5 file: %s/%s.h5\n', Path.H5Outdir, h5filename);
%     catch ME
%         fprintf('✗ Error writing to H5 file: %s\n', ME.message);
%     end
% end
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