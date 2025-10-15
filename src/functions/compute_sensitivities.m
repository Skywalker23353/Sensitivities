function [snstvty] = compute_sensitivities(numrtr,denomtr)
% Placeholder function for computing sensitivities
    eps = 1e-8;
     zero_idx = find(abs(denomtr) < 1e-15);
    if ~isempty(zero_idx)
        fprintf('  Handling %d zero values in field derivative...\n', length(zero_idx));
        denomtr(zero_idx) = denomtr(zero_idx) + eps;
    end
    clear zero_idx;
    snstvty = numrtr./ denomtr;
end