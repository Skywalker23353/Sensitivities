clear; clc; 
close all;
%%
addpath('~/MATLAB/');
addpath(genpath('/work/home/satyam/satyam_files/CH4_jet_PF/2025_Runs/Sensitivities/src/functions'));
addpath('/work/home/satyam/satyam_files/CH4_jet_PF/2025_Runs/Sensitivities/config');
%%
% Load paths and constants
sensitivity_constants_delc_0_1;  
global_hrr_LES = 163;
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
[Spline_fields,LES] = compute_function_using_beta_pdf(Spline_fields,"Comb",LES,'type','f_rz','epsilon',1e-3);
[Spline_fields,LES] = compute_function_using_beta_pdf(Spline_fields,"Noz",LES,'type','f_rz','epsilon',1e-3);
%%

hrrC = compute_hrr_global(Spline_fields.Heatrelease.Comb.f_rz,LES.Comb.R,LES.Comb.Z);
hrrN = compute_hrr_global(Spline_fields.Heatrelease.Noz.f_rz,LES.Noz.R,LES.Noz.Z);

F_FDM = global_hrr_LES./(hrrC + hrrN);
%%
save("/work/home/satyam/satyam_files/CH4_jet_PF/2025_Runs/Sensitivities/data/raw/F_FDM_Z10D_R5D.mat","F_FDM")