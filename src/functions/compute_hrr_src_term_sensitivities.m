function [SNST] = compute_hrr_src_term_sensitivities(SNST, SPD, LES, CNST, varargin)
    % Input parsing for optional threshold
    threshold_passed = any(strcmp(varargin(1:2:end),'threshold'));
    if ~threshold_passed
        warning('No threshold provided. Sensitivities will not be limited.');
    else
        p = inputParser;
        addParameter(p,'threshold',struct('dT',0.31), @(x) isstruct(x) && isfield(x,'dT'));
        parse(p,varargin{:});
        threshold = p.Results.threshold;
    end
    % Main computation
    fName_numrtr = 'Heatrelease';
    fName_denom = {'density','Temperature','CH4','O2','CO2','H2O','N2'};

    numrtr = SPD.(fName_numrtr).comb.dfdr;
    
    for i = 1:length(fName_denom)
        fName = sprintf('d%s_d%s',SPD.(fName_numrtr).opname,SPD.(fName_denom{i}).opname);

        denomtr = SPD.(fName_denom{i}).comb.dfdr;

        snstvty = compute_sensitivities(numrtr,denomtr);

        % Limit sensitivities to avoid outliers
        if threshold_passed && strcmp(fName_denom{i},'Temperature') && isfield(threshold,'dT')
            snstvty(abs(snstvty) >= threshold.dT) = threshold.dT;
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