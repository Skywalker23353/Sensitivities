function [SPD] = add_hrr_norm_field(SPD)
    % adding heat release norm field(different scaling from
    % hear release source term)
    field_name = 'Heatrelease';
    fprintf('Adding Heat release Norm field : %s\n',field_name);
    fname = 'HeatreleaseNorm';
    SPD.(fname) = SPD.(field_name);
    SPD.(fname).opname = sprintf("%sn",SPD.(field_name).opname);
    SPD.(fname).latexLabel = sprintf("%sn",SPD.(field_name).latexLabel);
end
