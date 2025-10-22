function [SNST] = subtract_N2_sensitivities(SNST)
    % SUBTRACT_N2_SENSITIVITIES - Subtract N2 sensitivities from all species sensitivities
    %
    % This function automatically detects all fields ending with '_dN2' and
    % subtracts them from their corresponding fields with other species.
    % For example: dwTn_dN2 is subtracted from dwTn_dCH4, dwTn_dO2, etc.
    % Input:
    %   SNST - Structure containing sensitivity fields
    % Output:
    %   SNST - Structure with N2 sensitivities subtracted from all other species
    
    % Get all field names from the structure
    all_fields = fieldnames(SNST);
    
    % Find all fields ending with '_dN2'
    n2_fields = all_fields(endsWith(all_fields, '_dN2'));
    
    % Loop through each N2 sensitivity field
    for i = 1:length(n2_fields)
        n2_field = n2_fields{i};
        
        % Extract the prefix (everything before '_dN2')
        prefix = extractBefore(n2_field, '_dN2');
        
        % Find all fields with the same prefix but different species
        % Pattern: prefix_d* (e.g., dwTn_dCH4, dwTn_dO2, etc.)
        matching_fields = all_fields(startsWith(all_fields, [prefix, '_d']));
        
        % Subtract N2 sensitivity from each matching field
        for j = 1:length(matching_fields)
            field = matching_fields{j};
            
            % Skip the N2 field itself (don't subtract from itself)
            if strcmp(field, n2_field)
                continue;
            end
            
            % Perform the subtraction
            SNST.(field) = SNST.(field) - SNST.(n2_field);
        end
    end
    
end