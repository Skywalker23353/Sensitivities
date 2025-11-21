function [C_RMS,CNST] = get_C_rms_field(FIELDS,CNST)
    C_RMS = sqrt(abs(FIELDS.MeanField.T_sq - (FIELDS.MeanField.T_mean).^2)) ./ (CNST.Yb - CNST.Yu);
end