function [C_MAT, Z_MAT] = get_C_cond_CZ_data(path)
        % Load coordinate data (C_MAT and Z_MAT) from CZ_data.mat
    fprintf('Loading coordinate data from CZ_data.mat...\n');

    try
        coord_data = load(fullfile(path, 'CZ_data.mat'));
        C_MAT = coord_data.C_MAT;
        Z_MAT = coord_data.Z_MAT;
        fprintf(' Successfully loaded coordinate data\n');
    catch ME
        fprintf(' Error loading coordinate data: %s\n', ME.message);
        fprintf('Please ensure CZ_data.mat exists in: %s\n', path);
        % Return empty matrices on error
        C_MAT = [];
        Z_MAT = [];
        return;
    end
end