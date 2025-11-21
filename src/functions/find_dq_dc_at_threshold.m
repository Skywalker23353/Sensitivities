function [CNST] = find_dq_dc_at_threshold(SPD,GridName,fName,CNST)
    fprintf("\n Finding threshold value");
    NZ = length(SPD.(fName).(GridName).dpp);
    for i = 1:NZ
        CNST.CH4_threshold_val(i) = ppval(SPD.(fName).(GridName).dpp{i},CNST.CH4_c_ref_mx);
    end  
end