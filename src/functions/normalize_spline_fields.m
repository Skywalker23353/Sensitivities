function [SPD] = normalize_spline_fields(SPD, GridName, CNST)
    % Normalize spline fields in SPD structure
    field_names = fieldnames(SPD);
    for i = 1:length(field_names)
        field_name = field_names{i};
        switch true
            case contains(field_name,'wT_p')
                fprintf('Normalizing field : %s\n',field_name);
                datasetNames = fieldnames(SPD.(field_name).(GridName));
                for j = 1:length(datasetNames)
                    dataset = SPD.(field_name).(GridName).(datasetNames{j});
                    if ~iscell(dataset)
                        SPD.(field_name).(GridName).(datasetNames{j}) = (CNST.model_scaling_factor .* SPD.(field_name).(GridName).(datasetNames{j})) ./ CNST.omega_dot_T_scaling;
                        fprintf("Normalising dataset %s as it is not a cell\n",datasetNames{j});
                    else
                        fprintf("Skipping dataset %s as a cell\n",datasetNames{j});
                    end
                end
            case contains(field_name,'wT')
                fprintf('Normalizing field : %s\n',field_name);
                datasetNames = fieldnames(SPD.(field_name).(GridName));
                for j = 1:length(datasetNames)
                    dataset = SPD.(field_name).(GridName).(datasetNames{j});
                    if ~iscell(dataset)
                        SPD.(field_name).(GridName).(datasetNames{j}) = (CNST.model_scaling_factor .* SPD.(field_name).(GridName).(datasetNames{j})) ./ CNST.omega_dot_T_scaling;
                        fprintf("Normalising dataset %s as it is not a cell\n",datasetNames{j});
                    else
                        fprintf("Skipping dataset %s as a cell\n",datasetNames{j});
                    end
                end
            case contains(field_name,'Heatrelease')
                fprintf('Normalizing field : %s\n',field_name);
                datasetNames = fieldnames(SPD.(field_name).(GridName));
                for j = 1:length(datasetNames)
                    dataset = SPD.(field_name).(GridName).(datasetNames{j});
                    if ~iscell(dataset)
                        SPD.(field_name).(GridName).(datasetNames{j}) = (CNST.model_scaling_factor .* SPD.(field_name).(GridName).(datasetNames{j}).* CNST.V_ref) ./ CNST.Q_bar;
                        fprintf("Normalising dataset %s as it is not a cell\n",datasetNames{j});
                    else
                        fprintf("Skipping dataset %s as a cell\n",datasetNames{j});
                    end
                end
%                 SPD.(field_name).(GridName).dfdr = (CNST.model_scaling_factor .* SPD.(field_name).(GridName).dfdr .* CNST.V_ref ) ./ CNST.Q_bar;
%                 SPD.(field_name).(GridName).dfdc = (CNST.model_scaling_factor .* SPD.(field_name).(GridName).dfdc .* CNST.V_ref ) ./ CNST.Q_bar;
            case contains(field_name,'Temperature')
                fprintf('No dnrmalizing field : %s\n',field_name);
                datasetNames = fieldnames(SPD.(field_name).(GridName));
                for j = 1:length(datasetNames)
                    dataset = SPD.(field_name).(GridName).(datasetNames{j});
                    if ~iscell(dataset)
                        SPD.(field_name).(GridName).(datasetNames{j}) = (CNST.model_scaling_factor .* SPD.(field_name).(GridName).(datasetNames{j})) ./ CNST.T_ref;
                        fprintf("Normalising dataset %s as it is not a cell\n",datasetNames{j});
                    else
                        fprintf("Skipping dataset %s as a cell\n",datasetNames{j});
                    end
                end
%                 SPD.(field_name).(GridName).dfdr = SPD.(field_name).(GridName).dfdr ./ CNST.T_ref;
%                 SPD.(field_name).(GridName).dfdc = SPD.(field_name).(GridName).dfdc ./ CNST.T_ref;
            case contains(field_name,'density')
                fprintf('Normalizing field : %s\n',field_name);
                datasetNames = fieldnames(SPD.(field_name).(GridName));
                for j = 1:length(datasetNames)
                    dataset = SPD.(field_name).(GridName).(datasetNames{j});
                    if ~iscell(dataset)
                        SPD.(field_name).(GridName).(datasetNames{j}) = (CNST.model_scaling_factor .* SPD.(field_name).(GridName).(datasetNames{j})) ./ CNST.rho_ref;
                        fprintf("Normalising dataset %s as it is not a cell\n",datasetNames{j});
                    else
                        fprintf("Skipping dataset %s as a cell\n",datasetNames{j});
                    end
                end
%                 SPD.(field_name).(GridName).dfdr = SPD.(field_name).(GridName).dfdr ./ CNST.rho_ref;
%                 SPD.(field_name).(GridName).dfdc = SPD.(field_name).(GridName).dfdc ./ CNST.rho_ref;
            case contains(field_name,'SYm')
                fprintf('Normalizing field : %s\n',field_name);
                datasetNames = fieldnames(SPD.(field_name).(GridName));
                for j = 1:length(datasetNames)
                    dataset = SPD.(field_name).(GridName).(datasetNames{j});
                    if ~iscell(dataset)
                        SPD.(field_name).(GridName).(datasetNames{j}) = (CNST.model_scaling_factor .* SPD.(field_name).(GridName).(datasetNames{j})) ./ CNST.omega_dot_k_scaling;
                        fprintf("Normalising dataset %s as it is not a cell\n",datasetNames{j});
                    else
                        fprintf("Skipping dataset %s as a cell\n",datasetNames{j});
                    end
                end
%                 SPD.(field_name).(GridName).dfdr = (CNST.model_scaling_factor .* SPD.(field_name).(GridName).dfdr) ./ CNST.omega_dot_k_scaling;
%                 SPD.(field_name).(GridName).dfdc = (CNST.model_scaling_factor .* SPD.(field_name).(GridName).dfdc) ./ CNST.omega_dot_k_scaling;
            otherwise
                fprintf('Normalizing factor does not exist for field : %s\n',field_name);
        end
    end
end