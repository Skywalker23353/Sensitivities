function [SNST] = compute_hrr_src_term_sensitivities(SNST, SPD, LES, CNST, fName_numrtr, fName_denom, varargin)
    % Input parsing for optional threshold
    threshold_passed = any(strcmp(varargin(1:2:end),'threshold'));
    if ~threshold_passed
        warning('No threshold provided. Sensitivities will not be limited.');
    else
        p = inputParser;
        addParameter(p,'threshold',struct('dT',0.31,'dN2', 100), @(x) isstruct(x) && (isfield(x,'dT') || isfield(x,'dN2')));
        parse(p,varargin{:});
        threshold = p.Results.threshold;
    end
    % Main computation

    numrtr = SPD.(fName_numrtr).comb.dfdr;
    numrtr_n = SPD.(fName_numrtr).noz.dfdr;
    
    for i = 1:length(fName_denom)
        fName = sprintf('d%s_d%s',SPD.(fName_numrtr).opname,SPD.(fName_denom{i}).opname);

        denomtr = SPD.(fName_denom{i}).comb.dfdr;
        denomtr_n = SPD.(fName_denom{i}).noz.dfdr;

        snstvty = compute_sensitivities(numrtr,denomtr);
        snstvty_n = compute_sensitivities(numrtr_n,denomtr_n);

        % Limit sensitivities to avoid outliers
        if threshold_passed && strcmp(fName_denom{i},'Temperature') && isfield(threshold,'dT')
            snstvty(abs(snstvty) >= threshold.dT) = threshold.dT;
        elseif threshold_passed && strcmp(fName_denom{i},'N2') && isfield(threshold,'dN2')
            snstvty(snstvty > threshold.dN2) = threshold.dN2;
            snstvty(snstvty < -threshold.dN2) = -threshold.dN2; 
        end

        % Replace values outside C bounds with boundary sensitivities
        replace_idx = LES.Comb.C_field >= CNST.c_ref_mx;
        snstvty(replace_idx) = snstvty(CNST.z_ref_idx,CNST.r_ref_idx);
        replace_idx = LES.Comb.C_field <= CNST.c_ref_mn;
        snstvty(replace_idx) = snstvty(1,1);

        replace_idx = LES.Noz.C_field >= CNST.c_ref_mx;
        snstvty_n(replace_idx) = snstvty_n(end,end);
        replace_idx = LES.Noz.C_field <= CNST.c_ref_mn;
        snstvty_n(replace_idx) = snstvty(1,1);

        snstvty = apply_smoothing_ignore_boundaries_1(snstvty,3,'all',1,1);
        snstvty_n = apply_smoothing_ignore_boundaries_1(snstvty_n,3,'all',1,1);
        SNST.comb.(fName) =  snstvty;
        SNST.noz.(fName) =  snstvty_n;
    end
end