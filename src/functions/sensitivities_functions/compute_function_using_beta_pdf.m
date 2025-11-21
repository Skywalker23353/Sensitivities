function [SPD,LES] = compute_function_using_beta_pdf(SPD,GridName,LES,varargin)
    p = inputParser;
    addParameter(p, 'type', 'dfdc_rz');
    addParameter(p, 'epsilon', 1e-3);
    parse(p, varargin{:});  % For varargin-based functions
    f_type = p.Results.type;
    eps = p.Results.epsilon;
    nZ = size(LES.(GridName).Z,1);
    nR = size(LES.(GridName).Z,2);
    F = NaN(nZ,nR);
    field_names = fieldnames(SPD);
    if strcmp(f_type,'dfdc_rz')
        for i = 1:length(field_names)
            field_name = field_names{i};
            for j = 1:nZ
                f_c = SPD.(field_name).(GridName).dpp{j};
                for k = 1:nR
                    c_mean = LES.(GridName).C_field(j,k);
                    c_rms = LES.(GridName).C_rms(j,k);
                    F(j,k) = integrate_f_with_pdf(f_c,c_mean,c_rms,eps);
                end
            end
            SPD.(field_name).(GridName).(f_type) = F;
        end
    elseif strcmp(f_type,'f_rz')
        for i = 1:length(field_names)
            field_name = field_names{i};
            for j = 1:nZ
                f_c = SPD.(field_name).(GridName).pp{j};
                for k = 1:nR
                    c_mean = LES.(GridName).C_field(j,k);
                    c_rms = LES.(GridName).C_rms(j,k);
                    F(j,k) = integrate_f_with_pdf(f_c,c_mean,c_rms,eps);
                end
            end
            SPD.(field_name).(GridName).(f_type) = F;
        end
    else
        fprintf('Incorrect type %d',f_type);
    end
end