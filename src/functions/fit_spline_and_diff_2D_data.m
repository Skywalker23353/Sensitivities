function [dpp, pp] = fit_spline_and_diff_2D_data(X_MAT, Y_MAT, varargin)
    % Fit splines to 2D data points (X_MAT, Y_MAT) and return the spline object.
    % Additionally, compute the first and second derivatives of the spline.
    % X_MAT: matrix of x-coordinates of data points
    % Y_MAT: matrix of y-coordinates of data points
    % pp: piecewise polynomial structure representing the spline
    % dpp: derivative of the spline
    % Splines are fitted for each row/column vector in the matrix based on input to function.

    % Input parse
    p = inputParser;
    addParameter(p, 'clamping', false, @islogical);
    addParameter(p, 'derivative_order', 1, @(x) isnumeric(x) && ismember(x, [0, 1, 2, 3]));
    addParameter(p, 'fit_dimension', 1, @(x) isnumeric(x) && ismember(x, [1, 2])); % 1: fit along rows, 2: fit along columns
    parse(p, varargin{:});  % For varargin-based functions


    % Fit splines for each row/column of the matrix
    [num_rows, num_cols] = size(X_MAT);
    if p.Results.fit_dimension == 1
         pp = cell(1, size(X_MAT,2));
         dpp = cell(1,size(X_MAT,2));
       for i = 1:num_rows
          x_vec = (X_MAT(i, :))';
          y_vec = (Y_MAT(i, :))';
          [dpp{i}, pp{i}] = fit_spline_and_diff(x_vec, y_vec, 'clamping', p.Results.clamping,  'derivative_order', p.Results.derivative_order);
       end
    elseif p.Results.fit_dimension == 2
         pp = cell(1, size(X_MAT,1));
         dpp = cell(1,size(X_MAT,1));
       for i = 1:num_cols
          x_vec = X_MAT(:,i);
          y_vec = Y_MAT(:,i);
          [dpp{i}, pp{i}] = fit_spline_and_diff(x_vec, y_vec, 'clamping', p.Results.clamping, 'derivative_order', p.Results.derivative_order);
       end
    else
       error('fit_dimension must be either 1 (rows) or 2 (columns).');
    end
end