function [interp_values] = interp_from_spline_on_2D_data(spline, X_MAT)
    interp_values = zeros(size(X_MAT));
    for i = 1:size(spline,1)
        interp_values(i,:) = ppval(spline{i}, X_MAT(i,:)');
    end
end