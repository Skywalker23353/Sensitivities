function [SNST] = normalize_sensitivities(SNST, CNST)
    % Normalize spline fields in SNST structure
    T_factor = CNST.Yu/(CNST.Yb - CNST.Yu);
    GridNames = fieldnames(SNST);
    for g = 1:length(GridNames)
        GridName = GridNames{g};
        field_names = fieldnames(SNST.(GridName));
        for i = 1:length(field_names)
            field_name = field_names{i};
            switch true
                case contains(field_name,'wT_p')
                    fprintf('Normalizing field : %s\n',field_name);
                    datasetNames = fieldnames(SNST.(GridName).(field_name));
                    for j = 1:length(datasetNames)
                        dataset = SNST.(GridName).(field_name).(datasetNames{j});
                        if ~iscell(dataset)
                            SNST.(GridName).(field_name).(datasetNames{j}) = (CNST.model_scaling_factor .* T_factor .* dataset) ./ CNST.omega_dot_T_scaling;
                            fprintf("Normalising dataset %s as it is not a cell\n",datasetNames{j});
                        else
                            fprintf("Skipping dataset %s as a cell\n",datasetNames{j});
                        end
                    end
                case contains(field_name,'wT')
                    fprintf('Normalizing field : %s\n',field_name);
                    datasetNames = fieldnames(SNST.(GridName).(field_name));
                    for j = 1:length(datasetNames)
                        dataset = SNST.(GridName).(field_name).(datasetNames{j});
                        if ~iscell(dataset)
                            SNST.(GridName).(field_name).(datasetNames{j}) = (CNST.model_scaling_factor .* T_factor .* dataset) ./ CNST.omega_dot_T_scaling;
                            fprintf("Normalising dataset %s as it is not a cell\n",datasetNames{j});
                        else
                            fprintf("Skipping dataset %s as a cell\n",datasetNames{j});
                        end
                    end
                case contains(field_name,'Heatrelease')
                    fprintf('Normalizing field : %s\n',field_name);
                    datasetNames = fieldnames(SNST.(GridName).(field_name));
                    for j = 1:length(datasetNames)
                        dataset = SNST.(GridName).(field_name).(datasetNames{j});
                        if ~iscell(dataset)
                            SNST.(GridName).(field_name).(datasetNames{j}) = (CNST.model_scaling_factor .* T_factor .* dataset.* CNST.V_ref) ./ CNST.Q_bar;
                            fprintf("Normalising dataset %s as it is not a cell\n",datasetNames{j});
                        else
                            fprintf("Skipping dataset %s as a cell\n",datasetNames{j});
                        end
                    end
    %                 SNST.(GridName).(field_name).(GridName).dfdr = (CNST.model_scaling_factor .* SNST.(GridName).(field_name).(GridName).dfdr .* CNST.V_ref ) ./ CNST.Q_bar;
    %                 SNST.(GridName).(field_name).(GridName).dfdc = (CNST.model_scaling_factor .* SNST.(GridName).(field_name).(GridName).dfdc .* CNST.V_ref ) ./ CNST.Q_bar;
                case contains(field_name,'Temperature')
                    fprintf('No dnrmalizing field : %s\n',field_name);
                    datasetNames = fieldnames(SNST.(GridName).(field_name));
                    for j = 1:length(datasetNames)
                        dataset = SNST.(GridName).(field_name).(datasetNames{j});
                        if ~iscell(dataset)
                            SNST.(GridName).(field_name).(datasetNames{j}) = (CNST.model_scaling_factor .* T_factor .* dataset) ./ CNST.T_ref;
                            fprintf("Normalising dataset %s as it is not a cell\n",datasetNames{j});
                        else
                            fprintf("Skipping dataset %s as a cell\n",datasetNames{j});
                        end
                    end
    %                 SNST.(GridName).(field_name).(GridName).dfdr = SNST.(GridName).(field_name).(GridName).dfdr ./ CNST.T_ref;
    %                 SNST.(GridName).(field_name).(GridName).dfdc = SNST.(GridName).(field_name).(GridName).dfdc ./ CNST.T_ref;
                case contains(field_name,'density')
                    fprintf('Normalizing field : %s\n',field_name);
                    datasetNames = fieldnames(SNST.(GridName).(field_name));
                    for j = 1:length(datasetNames)
                        dataset = SNST.(GridName).(field_name).(datasetNames{j});
                        if ~iscell(dataset)
                            SNST.(GridName).(field_name).(datasetNames{j}) = (CNST.model_scaling_factor .*T_factor .* dataset) ./ CNST.rho_ref;
                            fprintf("Normalising dataset %s as it is not a cell\n",datasetNames{j});
                        else
                            fprintf("Skipping dataset %s as a cell\n",datasetNames{j});
                        end
                    end
    %                 SNST.(GridName).(field_name).(GridName).dfdr = SNST.(GridName).(field_name).(GridName).dfdr ./ CNST.rho_ref;
    %                 SNST.(GridName).(field_name).(GridName).dfdc = SNST.(GridName).(field_name).(GridName).dfdc ./ CNST.rho_ref;
                case contains(field_name,'SYm')
                    fprintf('Normalizing field : %s\n',field_name);
                    datasetNames = fieldnames(SNST.(GridName).(field_name));
                    for j = 1:length(datasetNames)
                        dataset = SNST.(GridName).(field_name).(datasetNames{j});
                        if ~iscell(dataset)
                            SNST.(GridName).(field_name).(datasetNames{j}) = (CNST.model_scaling_factor .* T_factor .* dataset) ./ CNST.omega_dot_k_scaling;
                            fprintf("Normalising dataset %s as it is not a cell\n",datasetNames{j});
                        else
                            fprintf("Skipping dataset %s as a cell\n",datasetNames{j});
                        end
                    end
    %                 SNST.(GridName).(field_name).(GridName).dfdr = (CNST.model_scaling_factor .* SNST.(GridName).(field_name).(GridName).dfdr) ./ CNST.omega_dot_k_scaling;
    %                 SNST.(GridName).(field_name).(GridName).dfdc = (CNST.model_scaling_factor .* SNST.(GridName).(field_name).(GridName).dfdc) ./ CNST.omega_dot_k_scaling;
                otherwise
                    fprintf('Normalizing factor does not exist for field : %s\n',field_name);
            end
        end
    end
end