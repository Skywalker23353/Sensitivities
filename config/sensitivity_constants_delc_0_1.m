%% Paths
Path.TempDir = '/work/home/satyam/satyam_files/CH4_jet_PF/2025_Runs/Sensitivities/data/raw/LES';
Path.OutpDir = '/work/home/satyam/satyam_files/CH4_jet_PF/2025_Runs/Sensitivities/data/processed/sensitivities_10D_spline_0.1_T';
Path.InpDir1 = '/work/home/satyam/satyam_files/CH4_jet_PF/2025_Runs/Sensitivities/data/raw//C_cond_fields_800_10D_0.1_T/Comb';
Path.InpDir2 = '/work/home/satyam/satyam_files/CH4_jet_PF/2025_Runs/Sensitivities/data/raw//C_cond_fields_800_10D_0.1_T/Noz';
Path.H5Outdir = '/work/home/satyam/satyam_files/CH4_jet_PF/2025_Runs/LES_base_case_v6/filtering_run3/sensitivities/10D_spline'; 
%% Filenames
Filename.LES_comb_file = 'interp_16_unilat_structured_pl_combustor_domain/interp_fields/Mean_field_azim_avg';
Filename.LES_noz_file = 'interp_16_unilat_structured_pl_nozzle_domain_with_zero/interp_fields/YO2_field_structured_grid_16_planes_1011260202_avg';
%% Constants
Constant.D = 2e-3;
Constant.window = 3; % Window size for smoothing
Constant.rmx = 5;
Constant.zmx = 10;
Constant.Yu = 800;
Constant.Yb = 2313.65;
Constant.c_ref_mx = 0.97; 
Constant.c_ref_mn = 1e-32;
Constant.CH4_c_ref_mx = 0.80; 
Constant.CH4_c_ref_mn = 0.01;
Constant.d0 = 0;
Constant.dN = 0;
load(fullfile(Path.TempDir,'comb_interpolted_hrr_field_10D.mat'),"model_scaling_factor"); % hrr scaling factor
Constant.model_scaling_factor = model_scaling_factor; clear model_scaling_factor;
Constant.rho_ref = 0.4237;
Constant.Cp_ref =  1100;
Constant.T_ref = 800;
Constant.l_ref = 2e-3;
Constant.U_ref = 65;
Constant.V_ref = (Constant.l_ref)^3;
Constant.Q_bar = 163;
Constant.r_ref = 2;
Constant.z_ref = 9;
Constant.CH4_r_ref = 0.25;
Constant.CH4_z_ref = 7.5;
Constant.omega_dot_T_scaling = (Constant.rho_ref*Constant.Cp_ref*Constant.T_ref*Constant.U_ref)/Constant.l_ref;
Constant.omega_dot_k_scaling = (Constant.rho_ref*Constant.U_ref)/Constant.l_ref;