function plot_surface_field(X_MAT, Y_MAT, data, tl1, xLabel, yLabel, tl2, figure_offset)
    % Plot original field, its derivative, and final result in a single
    % maximized figure
    
    base_figure =  figure_offset;
    
    % Create maximized figure with 3 subplots
    figure(base_figure);
    set(gcf, 'WindowState', 'maximized');  % Maximize the figure
    set(gcf, 'Position', get(0, 'Screensize'));  % Alternative maximization method

    myutils.plot_surf_field(gcf, X_MAT, Y_MAT, data, ...
            sprintf('$%s$',xLabel), sprintf('$%s$',yLabel), ...
            sprintf('$\\frac{\\partial %s}{\\partial %s}$', tl1, tl2));
    
    % Adjust subplot spacing
    set(gcf, 'Units', 'normalized');
   
end