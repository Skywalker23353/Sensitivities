function [pp] = fit_spline(x, y, varargin)
    % Fit a spline to the given data points (x, y) and return the spline object.
    % x: vector of x-coordinates of data points
    % y: vector of y-coordinates of data points
    % pp: piecewise polynomial structure representing the spline
    % Optional parameters can be passed as name-value pairs.
    p = inputParser;
    addParameter(p, 'clamping', false, @islogical);
    parse(p, varargin{:});
    if p.Results.clamping
        % Clamped spline (first derivative at endpoints is zero)
        pp = spline(x, [0; y; 0]);
    else
        % Natural spline
        pp = spline(x, y);
    end