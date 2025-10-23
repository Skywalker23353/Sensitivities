function [SNST] = set_noz_sensitivities(SNST,NOZ)
        op_field = zeros(size(NOZ.R));
        fName_list = fieldnames(SNST.comb);
        for i = 1:length(fName_list)
            fName = fName_list{i};
            temp = SNST.comb.(fName);
            op_field(end,:) = temp(1, 1:size(NOZ.R, 2));
            % Apply smoothing to nozzle
            SNST.noz.(fName) = myutils.f_return_smooth_field(op_field, 3, 'col');
        end
end