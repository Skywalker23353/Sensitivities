function [SNST] = compute_hrr_src_term_sensitivities_test(SNST, SPD, LES, CNST, fName_numrtr, fName_denom, varargin)
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

    numrtr = SPD.(fName_numrtr).comb.dfdc;
    numrtr_n = SPD.(fName_numrtr).noz.dfdc;
    
    for i = 1:length(fName_denom)
        fName = sprintf('d%s_d%s',SPD.(fName_numrtr).opname,SPD.(fName_denom{i}).opname);

        denomtr = SPD.(fName_denom{i}).comb.dfdc;
        denomtr_n = SPD.(fName_denom{i}).noz.dfdc;

        snstvty = compute_sensitivities(numrtr,denomtr);
        snstvty_n = compute_sensitivities(numrtr_n,denomtr_n);

        SNST.comb.(fName) =  snstvty;
        SNST.noz.(fName) =  snstvty_n;
    end
end