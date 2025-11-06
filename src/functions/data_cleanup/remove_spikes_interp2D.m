function data_clean = remove_spikes_interp2D(data, k)
%REMOVE_SPIKES_INTERP2D  Detect and repair spikes in a 2D dataset.
%
%   data_clean = remove_spikes_interp2D(data, k)
%
%   Detects abnormal spikes in a 2D matrix 'data' using a statistical
%   threshold and replaces them with interpolated values from nearby points.
%
%   INPUTS:
%       data : 2D numeric array
%       k    : threshold multiplier (default = 5)
%
%   OUTPUT:
%       data_clean : 2D array with spikes replaced by interpolated values
%
%   EXAMPLE:
%       data_clean = remove_spikes_interp2D(a./b, 5);
%
%   Reference:
%       Gonzalez & Woods, "Digital Image Processing", 4th ed., Pearson.
%       Press et al., "Numerical Recipes", 3rd ed., Cambridge Univ. Press.

    if nargin < 2
        k = 5;  % Default threshold = 5?
    end

    % Step 1: Compute mean and std while ignoring NaNs
    mu = mean(data(:), 'omitnan');
    sigma = std(data(:), 'omitnan');

    % Step 2: Identify spikes (values far from mean)
    spikeMask = abs(data - mu) > k * sigma;

    % Step 3: Replace spikes with NaN
    data_nan = data;
    data_nan(spikeMask) = NaN;

    % Step 4: Interpolate missing (NaN) values
    [nRows, nCols] = size(data_nan);
    [X, Y] = meshgrid(1:nCols, 1:nRows);

    % Prepare mask for valid (non-NaN) entries
    validMask = ~isnan(data_nan);

    % Use scatteredInterpolant on valid data points
    F = scatteredInterpolant(X(validMask), Y(validMask), data_nan(validMask), 'linear', 'nearest');

    % Interpolate entire grid
    data_clean = F(X, Y);

    % Step 5 (optional): Light smoothing to remove local discontinuities
    % Uncomment if desired
    % h = fspecial('gaussian', [3 3], 0.5);
    % data_clean = imfilter(data_clean, h, 'replicate');
end
