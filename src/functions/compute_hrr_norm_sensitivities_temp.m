function [SNST] = compute_hrr_norm_sensitivities_temp(SNST, SPD, GridName, LES, CNST, fName_numrtr,fName_denom,varargin)
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
    
    
    data = SPD.(fName_numrtr).(GridName).dfdc;
    numrtr = data;
    
    for i = 1:length(fName_denom)
        fName = sprintf('d%sn_d%s',SPD.(fName_numrtr).opname,SPD.(fName_denom{i}).opname);

        denomtr = SPD.(fName_denom{i}).(GridName).dfdc;

        
        snstvty = compute_sensitivities(numrtr,denomtr);


        snstvty = remove_spikes_interp2D(snstvty, 5);

       
        % Replace values outside C bounds with boundary sensitivities
%         replace_idx = LES.Comb.C_field >= CNST.c_ref_mx;
%         snstvty(replace_idx) = snstvty(CNST.z_ref_idx,CNST.r_ref_idx);
%         replace_idx = LES.Noz.C_field >= CNST.c_ref_mx;
%         snstvty_n(replace_idx) = snstvty_n(end,end);
%         replace_idx = LES.Comb.C_field <= CNST.c_ref_mn;
%         snstvty(replace_idx) = snstvty(1,1);
%         replace_idx = LES.Noz.C_field <= CNST.c_ref_mn;
%         snstvty_n(replace_idx) = snstvty_n(1,1);

%         snstvty = apply_smoothing_ignore_boundaries_1(snstvty,3,'all',1,1);
%         snstvty_n = apply_smoothing_ignore_boundaries_1(snstvty_n,3,'all',1,1);
        SNST.(GridName).(fName) =  snstvty;

    end
end