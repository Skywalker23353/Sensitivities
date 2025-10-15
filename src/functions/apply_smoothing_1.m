function smoothed_data = apply_smoothing_1(data, window)
    % Apply the multi-step smoothing operation
    
    % Apply smoothing sequence: row -> row -> col -> col
%     fprintf('    Step 1: Row smoothing...\n');
    smoothed_data = myutils.f_return_smooth_field(data, window, 'row');
    
%     fprintf('    Step 2: Row smoothing (second pass)...\n');
    smoothed_data = myutils.f_return_smooth_field(smoothed_data, window, 'row');
    
%     fprintf('    Step 3: Column smoothing...\n');
    smoothed_data = myutils.f_return_smooth_field(smoothed_data, window, 'col');
    
%     fprintf('    Step 4: Column smoothing (second pass)...\n');
    smoothed_data = myutils.f_return_smooth_field(smoothed_data, window, 'col');

end