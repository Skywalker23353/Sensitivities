sensitivity_constants; % Load constants
LES.Comb.MeanField = load(fullfile(Path.TempDir, Filename.LES_comb_file));
LES.Noz.MeanField = load(fullfile(Path.TempDir, Filename.LES_noz_file));
% Load structured grid coordinates
load(fullfile(Path.TempDir, 'structured_grid_from_LES_grid_with_zero_16_unilat_planes.mat'));

% Create C field using YO2 field
fprintf('Computing C fields...\n');
LES.Comb.C_field = (Constant.Yu - LES.Comb.MeanField.O2_mean)/(Constant.Yu - Constant.Yb);
LES.Noz.C_field = (Constant.Yu - LES.Noz.MeanField.O2_mean)/(Constant.Yu - Constant.Yb);

LES.Comb.C_field(LES.Comb.C_field >= Constant.c_ref_mx) = Constant.c_ref_mx;
LES.Noz.C_field(LES.Noz.C_field >= Constant.c_ref_mx) = Constant.c_ref_mx;

LES.Comb.C_field(LES.Comb.C_field < Constant.c_ref_mn) = Constant.c_ref_mn;
LES.Noz.C_field(LES.Noz.C_field < Constant.c_ref_mn) = Constant.c_ref_mn;

% Apply Z restriction logic
Z_idx_mx = find((Z1)/Constant.D >= Constant.zmx, 1);
r_idx_mx = find(R1(1,:)/Constant.D >= Constant.rmx,1);

LES.Comb.R = R1(1:Z_idx_mx, 1:r_idx_mx);
LES.Comb.Z = Z1(1:Z_idx_mx, 1:r_idx_mx);
LES.Noz.R = R2;
LES.Noz.Z = Z2;

LES.Comb.C_field = LES.Comb.C_field(1:Z_idx_mx, 1:r_idx_mx);

clear r_idx_mx Z_idx_mx;

% Set reference index 
Constant.r_ref_idx = find(R1(1,:)/Constant.D > Constant.r_ref,1);
Constant.z_ref_idx = find(Z1(:,1)/Constant.D > Constant.z_ref,1);

clear R1 R1 Z1 Z2;

% Limiting C field
% LES.comb.C_field(find(LES.comb.C_field < Constants.Min_c_limit)) = 0;
% comb_data.C_field(find(comb_data.C_field > Constants.Max_c_limit)) = 1;