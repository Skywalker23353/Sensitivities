function [SNST] = construct_hrr_sensitivities(SNST,CNST)
    % Heat release rate expression
    % w_T = - sum(h_f * w_k) k=1..N_species
    % Heat release rate for Norm
    GridNames = fieldnames(SNST);
    for i = 1:length(GridNames)
        GridName = GridNames{i};
        SpeciesNames = fieldnames(SNST.(GridName));
        hrr = zeros(size(SNST.(GridName).(SpeciesNames{1})));
        hrr_s = zeros(size(SNST.(GridName).(SpeciesNames{1})));
        for j = 1:length(CNST.hf)
            hrr = hrr + CNST.delta_hf(j) * SNST.(GridName).(SpeciesNames{j});
            hrr_s = hrr_s + CNST.hf(j) * SNST.(GridName).(SpeciesNames{j});
        end
        SNST.(GridName).Heatrelease = -hrr;
        SNST.(GridName).wT_p = -hrr_s;
    end
end