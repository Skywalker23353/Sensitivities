function [SNST] = compute_hrr_norm_sensitivities(SNST, SPD, GridName, LES, CNST, fName_numrtr,fName_denom,varargin)
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
    
    
    data = SPD.(fName_numrtr).(GridName).dfdr;
    numrtr = data;
    
    for i = 1:length(fName_denom)
        fName = sprintf('d%sn_d%s',SPD.(fName_numrtr).opname,SPD.(fName_denom{i}).opname);

        denomtr = SPD.(fName_denom{i}).(GridName).dfdr;
        
        snstvty = compute_sensitivities(numrtr,denomtr);

%         snstvty = remove_spikes_interp2D(snstvty, 25);
        
        % Limit sensitivities to avoid outliers
        if threshold_passed 
            if strcmp(fName_denom{i},'Temperature') && isfield(threshold,'dT')
                snstvty(snstvty > threshold.dT) = threshold.dT;
                snstvty(snstvty < -threshold.dT) = -threshold.dT;
            elseif strcmp(fName_denom{i},'CH4') && isfield(threshold,'dCH4')
                snstvty(snstvty > threshold.dCH4) = threshold.dCH4;
                snstvty(snstvty < -threshold.dCH4) = -threshold.dCH4;
            elseif strcmp(fName_denom{i},'N2') && isfield(threshold,'dN2')
                snstvty(snstvty > threshold.dN2) = threshold.dN2;
                snstvty(snstvty < -threshold.dN2) = -threshold.dN2; 
            end
        end
        % Replace values outside C bounds with boundary sensitivities
        if ~strcmp(GridName,'Noz')
            if strcmp(fName_denom{i},'CH4')
                replace_idx = LES.(GridName).C_field >= CNST.CH4_c_ref_mx;
                snstvty(replace_idx) = snstvty(CNST.CH4_z_ref_idx,CNST.CH4_r_ref_idx);
                clear replace_idx;
                replace_idx = LES.(GridName).C_field <= CNST.c_ref_mn;
                snstvty(replace_idx) = snstvty(1,1);
    
            else
                replace_idx = LES.(GridName).C_field >= CNST.c_ref_mx;
                snstvty(replace_idx) = snstvty(CNST.z_ref_idx,CNST.r_ref_idx);
    
                replace_idx = LES.(GridName).C_field <= CNST.c_ref_mn;
                snstvty(replace_idx) = snstvty(1,1);
            end
        end

        snstvty = apply_smoothing_ignore_boundaries_1(snstvty,3,'all',1,1);
        SNST.(GridName).(fName) =  snstvty;
    end
    if ~strcmp(GridName,'Noz')
        replace_idx = LES.(GridName).C_field >= CNST.c_ref_mx;
        data(replace_idx) = data(CNST.z_ref_idx,CNST.r_ref_idx);
    
        replace_idx = LES.(GridName).C_field <= CNST.c_ref_mn;
        data(replace_idx) = data(1,1);
    end
    SNST.(GridName).(fName_numrtr) = data;
end