function [SNST] = compute_hrr_norm_sensitivities(SNST, SPD, LES, CNST, fName_numrtr,fName_denom,varargin)
    % Input parsing for optional threshold
    threshold_passed = any(strcmp(varargin(1:2:end),'threshold'));
    if ~threshold_passed
        warning('No threshold provided. Sensitivities will not be limited.');
    else
        p = inputParser;
        addParameter(p,'threshold',struct('dT',0.2,'dCH4',30,'dN2', 100), @(x) isstruct(x) && (isfield(x,'dT') || isfield(x,'dCH4') || isfield(x,'dN2')));
        parse(p,varargin{:});
        threshold = p.Results.threshold;
    end
    % Main computation
    
    
    data = SPD.(fName_numrtr).comb.dfdr;
    numrtr = data;
    
    for i = 1:length(fName_denom)
        fName = sprintf('d%sn_d%s',SPD.(fName_numrtr).opname,SPD.(fName_denom{i}).opname);

        denomtr = SPD.(fName_denom{i}).comb.dfdr;
        
        snstvty = compute_sensitivities(numrtr,denomtr);
        
        % Limit sensitivities to avoid outliers
        if threshold_passed && strcmp(fName_denom{i},'Temperature') && isfield(threshold,'dT')
            snstvty(snstvty > threshold.dT) = threshold.dT;
            snstvty(snstvty < -threshold.dT) = -threshold.dT;
        elseif threshold_passed && strcmp(fName_denom{i},'CH4') && isfield(threshold,'dCH4')
            snstvty(snstvty > threshold.dCH4) = threshold.dCH4;
            snstvty(snstvty < -threshold.dCH4) = -threshold.dCH4;
       elseif threshold_passed && strcmp(fName_denom{i},'N2') && isfield(threshold,'dN2')
            snstvty(snstvty > threshold.dN2) = threshold.dN2;
            snstvty(snstvty < -threshold.dN2) = -threshold.dN2; 
        end

        % Replace values outside C bounds with boundary sensitivities
        replace_idx = LES.Comb.C_field >= CNST.c_ref_mx;
        snstvty(replace_idx) = snstvty(CNST.z_ref_idx,CNST.r_ref_idx);
        replace_idx = LES.Comb.C_field <= CNST.c_ref_mn;
        snstvty(replace_idx) = snstvty(1,1);

        snstvty = apply_smoothing_ignore_boundaries_1(snstvty,3,'all',1,1);
        SNST.comb.(fName) =  snstvty;
    end
end