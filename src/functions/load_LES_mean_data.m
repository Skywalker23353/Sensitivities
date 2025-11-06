function [LES,CNST] = load_LES_mean_data(CNST,PATH,FILENAME,FNAME)
    LES.Comb.MeanField = load(fullfile(PATH.TempDir, FILENAME.LES_comb_file));
    LES.Noz.MeanField = load(fullfile(PATH.TempDir, FILENAME.LES_noz_file));
    % Load structured grid coordinates
    load(fullfile(PATH.TempDir, 'structured_grid_from_LES_grid_with_zero_16_unilat_planes.mat'));
    
    % Create C field using YO2 field
    fprintf('Computing C fields...\n');
    LES.Comb.C_field = (CNST.Yu - LES.Comb.MeanField.(FNAME))/(CNST.Yu - CNST.Yb);
    LES.Noz.C_field = (CNST.Yu - LES.Noz.MeanField.(FNAME))/(CNST.Yu - CNST.Yb);
    
    LES.Comb.C_field(LES.Comb.C_field >= CNST.c_ref_mx) = CNST.c_ref_mx;
    LES.Noz.C_field(LES.Noz.C_field >= CNST.c_ref_mx) = CNST.c_ref_mx;
    
    LES.Comb.C_field(LES.Comb.C_field < CNST.c_ref_mn) = CNST.c_ref_mn;
    LES.Noz.C_field(LES.Noz.C_field < CNST.c_ref_mn) = CNST.c_ref_mn;
    
    % Apply Z restriction logic
    Z_idx_mx = find((Z1)/CNST.D >= CNST.zmx, 1);
    r_idx_mx = find(R1(1,:)/CNST.D >= CNST.rmx,1);
    
    LES.Comb.R = R1(1:Z_idx_mx, 1:r_idx_mx);
    LES.Comb.Z = Z1(1:Z_idx_mx, 1:r_idx_mx);
    LES.Noz.R = R2;
    LES.Noz.Z = Z2;
    
    LES.Comb.C_field = LES.Comb.C_field(1:Z_idx_mx, 1:r_idx_mx);
    
    clear r_idx_mx Z_idx_mx;
    
    % Set reference index 
    CNST.r_ref_idx = find(R1(1,:)/CNST.D > CNST.r_ref,1);
    CNST.z_ref_idx = find(Z1(:,1)/CNST.D > CNST.z_ref,1);
    
    clear R1 R2 Z1 Z2;
    
    % Limiting C field
    % LES.comb.C_field(find(LES.comb.C_field < CNSTs.Min_c_limit)) = 0;
    % comb_data.C_field(find(comb_data.C_field > CNSTs.Max_c_limit)) = 1;
end