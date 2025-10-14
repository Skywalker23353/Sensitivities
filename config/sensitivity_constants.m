%% Paths
Path.TempDir = '/work/home/satyam/satyam_files/CH4_jet_PF/2025_Runs/Sensitivities/data/raw/LES';
Path.OutpDir = '/work/home/satyam/satyam_files/CH4_jet_PF/2025_Runs/Sensitivities/data/processed/sensitivities_10D_spline';
Path.InpDir = '/work/home/satyam/satyam_files/CH4_jet_PF/2025_Runs/Sensitivities/data/raw/C_cond_fields_800_10D_coarse/BC';
Path.H5Outdir = '/work/home/satyam/satyam_files/CH4_jet_PF/2025_Runs/LES_base_case_v6/filtering_run3/sensitivities/10D_spline'; 
%% Filenames
Filename.h5filename = 'Reactants_5';
Filename.LES_comb_file = 'interp_16_unilat_structured_pl_combustor_domain/interp_fields/Mean_field_azim_avg';
Filename.LES_noz_file = 'interp_16_unilat_structured_pl_nozzle_domain_with_zero/interp_fields/YO2_field_structured_grid_16_planes_1011260202_avg';
%% Constants
Constant.D = 2e-3;
Constant.window = 3; % Window size for smoothing
Constant.rmx = 5;
Constant.zmx = 10;
Constant.Yu = 0.222606; % Yb = 0.0423208;
Constant.Yb = 0.0411;
Constant.c_ref_mx = 0.79; 
Constant.c_ref_mn = 4e-2;
%Constant.c_ref_mx = 0.85; 
%Constant.c_ref_mn = 2e-2;
Constant.d0 = 0;
Constant.dN = 0;
Constant.model_scaling_factor = load(fullfile(Path.TempDir,'comb_interpolted_hrr_field_10D.mat'),"model_scaling_factor"); % hrr scaling factor
Constant.rho_ref = 0.4237;
Constant.Cp_ref =  1100;
Constant.T_ref = 800;
Constant.l_ref = 2e-3;
Constant.U_ref = 65;
Constant.V_ref = (Constant.l_ref)^3;
Constant.Q_bar = 163;
Constant.r_ref = 3;
Constant.z_ref = 9;
Constant.omega_dot_T_scaling = (Constant.rho_ref*Constant.Cp_ref*Constant.T_ref*Constant.U_ref)/Constant.l_ref;
Constant.omega_dot_k_scaling = (Constant.rho_ref*Constant.U_ref)/Constant.l_ref;