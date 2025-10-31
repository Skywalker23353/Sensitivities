function [interp_values] = interp_from_spline_on_2D_data(spline, X_MAT,varargin)
    p = inputParser;
    addParameter(p,'grid','comb');
    parse(p,varargin{:});
    grid = p.Results.grid;
    interp_values = zeros(size(X_MAT));
    
    if strcmp(grid,'noz')
        for i = 1:size(X_MAT,1)
            interp_values(i,:) = ppval(spline{1}, X_MAT(i,:)');
        end
    else
        for i = 1:size(X_MAT,1)
            interp_values(i,:) = ppval(spline{i}, X_MAT(i,:)');
        end
    end
end