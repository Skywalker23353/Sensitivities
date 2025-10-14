function [dpp, pp] = fit_spline_and_diff(x, y, varargin)
    % Fit a spline to the given data points (x, y) and return the spline object.
    % Additionally, compute the first and second derivatives of the spline.
    % x: vector of x-coordinates of data points
    % y: vector of y-coordinates of data points
    % pp: piecewise polynomial structure representing the spline
    % dpp: derivative of the spline

    % Optional parameters can be passed as name-value pairs.
    p = inputParser;
    addParameter(p, 'clamping', false, @islogical);
    addParameter(p, 'derivative_order', 1, @(x) isnumeric(x) && ismember(x, [0, 1, 2, 3]));
    parse(p, varargin{:});  % For varargin-based functions
    
    pp = fit_spline(x, y, 'clamping', p.Results.clamping);
    dpp = fnder(pp, p.Results.derivative_order);
end