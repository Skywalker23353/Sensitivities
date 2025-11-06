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
h5filename = 'Reactants_26';
% Load paths and constants
sensitivity_constants_delc_0_1;  
% Load input field configurations
C_cond_field_name_with_all_minor; 
% Load LES data
[LES,Constant] = load_LES_mean_data(Constant,Path,Filename,'T_mean');  
%% Fit spline to C cond field
fprintf('Fitting splines to C fields...\n');
[C_MAT, ~] = get_C_cond_CZ_data(Path.InpDir);
[Spline_fields] = fit_spline_for_C_cond_data(field_configs, Path.InpDir, C_MAT);
[Spline_fields] = set_latex_labels(Spline_fields,field_configs);
%% Interpolate from splines to LES grid
[Spline_fields, LES] = interp_from_spline(Spline_fields, LES,'type','dfdr');
%% Interpolate from splines to temporary grid
[Spline_fields, LES] = interp_from_spline(Spline_fields, LES,'type','dfdc');
%% Interpolate from splines to temporary grid
[Spline_fields, LES] = interp_from_spline(Spline_fields, LES,'type','f');
%% Normalize fields
[Spline_fields] = normalize_spline_fields(Spline_fields, Constant, field_configs);
%% Plot dfdr
if plot_fields
%     plot_dfdr(Spline_fields, LES, Constant);
%         plot_dfdr(Spline_fields, LES, Constant,'grid','noz');
    plot_f(Spline_fields, LES, Constant);
%     plot_dfdc(Spline_fields, LES, Constant);
end
%%
% fName_denom = {'density','Temperature','CH4','O2','CO2','H2O','N2'};
fName_denom = {'density','Temperature','CH4','O2','CO2','H2O','CH2O','CH3','CO','H','H2','HO2','O','OH'};
%% Compute hrr norm sensitivities
Sensitivities = struct();
Sensitivities_test = struct();
% Thld.dT = 0.2;
% Thld.dCH4 = 30;
% Thld.dN2 = 100;
fName_numrtr = 'HeatreleaseNorm';
[Sensitivities] = compute_hrr_norm_sensitivities(Sensitivities,Spline_fields, LES, Constant, fName_numrtr,fName_denom);
[Sensitivities_test] = compute_hrr_norm_sensitivities_temp(Sensitivities_test,Spline_fields, LES, Constant,fName_numrtr,fName_denom);

%% Plot hrr norm sensitivities
% plot_sensitivities(Sensitivities, LES.Comb.R1, LES.Comb.Z1, Constant);

%%  Compute hrr src term sensitivities
% Thld.dT = 0.31;
% Thld.dN2 = 100;
fName_numrtr = 'Heatrelease';
[Sensitivities] = compute_hrr_src_term_sensitivities(Sensitivities,Spline_fields, LES, Constant, fName_numrtr,fName_denom);
[Sensitivities_test] = compute_hrr_src_term_sensitivities_test(Sensitivities_test,Spline_fields, LES, Constant, fName_numrtr,fName_denom);

%% Plot hrr norm and src term sensitivities
% plot_sensitivities(Sensitivities, LES.Comb.R1, LES.Comb.Z1, Constant);

%%  Compute chem src terms sensitivities
% [Sensitivities] = compute_chem_src_term_sensitivities(Sensitivities,Spline_fields, LES, Constant,'remove_spikes',true);
fName_numrtr = {'SYm_CH4';'SYm_CH3';'SYm_CO';'SYm_O2';'SYm_O';'SYm_OH';'SYm_CO2';'SYm_H2O';'SYm_HO2';'SYm_H';};%'SYm_CH2O';'SYm_H2';
[Sensitivities] = compute_chem_src_term_sensitivities(Sensitivities,Spline_fields, LES, Constant, fName_numrtr,fName_denom);
[Sensitivities_test] = compute_chem_src_term_sensitivities_test(Sensitivities_test,Spline_fields, LES, Constant, fName_numrtr,fName_denom);

%% Subtract N2 sensitivities from all sensitivities
% [Sensitivities] = subtract_N2_sensitivities(Sensitivities);

%% Set nozzle sensitivities 
% [Sensitivities] = set_noz_sensitivities(Sensitivities,LES.Noz);

%% Plotting
if plot_sensitivities_flag
%     plot_sensitivities(Sensitivities, LES.Comb.R, LES.Comb.Z, Constant);
        plot_sensitivities(Sensitivities_test, LES.Temp.X_MAT, LES.Temp.Y_MAT, Constant, 40);
end
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