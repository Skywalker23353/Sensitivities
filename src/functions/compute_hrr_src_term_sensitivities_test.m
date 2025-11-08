function [SNST] = compute_hrr_src_term_sensitivities_test(SNST, SPD, GridName, LES, CNST, fName_numrtr, fName_denom, varargin)
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

    numrtr = SPD.(fName_numrtr).(GridName).dfdc;
    
    for i = 1:length(fName_denom)
        fName = sprintf('d%s_d%s',SPD.(fName_numrtr).opname,SPD.(fName_denom{i}).opname);

        denomtr = SPD.(fName_denom{i}).(GridName).dfdc;

        snstvty = compute_sensitivities(numrtr,denomtr);

        snstvty = remove_spikes_interp2D(snstvty, 10);

        SNST.(GridName).(fName) =  snstvty;
    end
end