sensitivity_constants; % Load constants
LES.Comb.MeanField = load(fullfile(Path.TempDir, Path.Filename.LES_comb_file));
LES.Noz.MeanField = load(fullfile(Path.TempDir, Path.Filename.LES_noz_file));
% Load structured grid coordinates
load(fullfile(Path.TempDir, 'structured_grid_from_LES_grid_with_zero_16_unilat_planes.mat'));

% Create C field using YO2 field
fprintf('Computing C fields...\n');
LES.Comb.C_field_comb = (Constant.Yu - LES.Comb.MeanField.O2_mean)/(Constant.Yu - Constant.Yb);
LES.Comb.C_field_noz = (Constant.Yu - LES.Noz.MeanField.O2_mean)/(Constant.Yu - Constant.Yb);

% Apply Z restriction logic
Z_idx_mx = find((Z1)/Constant.D >= Constant.zmx, 1);
r_idx_mx = find(R1(1,:)/Constant.D >= Constant.rmx,1);
LES.comb.R1 = R1(1:Z_idx_mx, 1:r_idx_mx);
LES.comb.Z1 = Z1(1:Z_idx_mx, 1:r_idx_mx);
LES.comb.C_field = LES.comb.C_field(1:Z_idx_mx, 1:r_idx_mx);

% Limiting C field
% LES.comb.C_field(find(LES.comb.C_field < Constants.Min_c_limit)) = 0;
% comb_data.C_field(find(comb_data.C_field > Constants.Max_c_limit)) = 1;