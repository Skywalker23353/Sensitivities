clear;clc;close all;
%%
% Unit test for fit_spline function
addpath('../../src/functions');

save_figs = true;

% Prepare output directory for saving difference figures
scriptFullPath = mfilename('fullpath');
if isempty(scriptFullPath)
	scriptDir = pwd;
else
	scriptDir = fileparts(scriptFullPath);
end
diffDir = fullfile(scriptDir, '..', '..', 'data', 'processed', 'diff_figs_old');
if ~exist(diffDir, 'dir')
	mkdir(diffDir);
end

% Generate synthetic data
eps = 1e-8;
x = [0 0.1 0.3 0.5 0.7 0.9 1.0]';
x_interp = linspace(0, 1, 50)';
y1 = (x.^2) + (x) + 1 ;%+ 0.1*randn(size(x));
y1_interp = (x_interp.^2) + (x_interp.^2) + 1 ;%+ 0.1*randn(size(x_interp));
y1_interp_prime = 2.*(x_interp) + 1;%+ 0.1*randn(size(x_interp));

y2 = sin(2*pi*x) + exp(-0.1*x) ;%+ 0.1*randn(size(x));
y2_interp = sin(2*pi*x_interp) + exp(-0.1*x_interp) ;%+ 0.1*randn(size(x_interp));
y2_interp_prime = 2*pi*cos(2*pi*x_interp) - 0.1*exp(-0.1*x_interp) ;%+ 0.1*randn(size(x_interp));

fs = 33; % Font size for plots
%% Plot original data
h = figure('WindowState','maximized');
plot(x, y1, '-ob', 'DisplayName', 'y : x^2 + x + 1','MarkerSize',15);
hold on;
plot(x_interp, y1_interp, '-ok', 'DisplayName', 'y (Interp) : x^2 + x + 1','MarkerSize',15);
hold on
plot(x_interp, y1_interp_prime, '-+r', 'DisplayName', 'y''(Interp) : 2x + 1','MarkerSize',15);
xlabel('x');
% ylabel('y');
legend('Location','northwest');
set(findall(gca,'-property','FontSize'),'FontSize',fs);
set(findall(gca,'-property','LineWidth'),'LineWidth',2);
% Save original data + derivative figure for y1
pause(0.3);
if save_figs
    saveas(h, fullfile(diffDir, 'y1_original_and_derivative.png'));
end
%% Fit splines with y1 
[dys_c, ys_c] = fit_spline_and_diff(x, y1, 'clamping', true, 'derivative_order', 1);
[dys, ys] = fit_spline_and_diff(x, y1,'derivative_order', 1);
ypp_c = ppval(ys_c, x_interp);
dypp_c = ppval(dys_c, x_interp);

ypp = ppval(ys, x_interp);
dypp = ppval(dys, x_interp);

%Compute percentage error
p_error_u = (abs(y1_interp - ypp)./(y1_interp + eps))*100;
p_error_u_prime = (abs(y1_interp_prime - dypp)./(y1_interp_prime + eps))*100;

p_error_c = (abs(y1_interp - ypp_c)./(y1_interp + eps))*100;
p_error_c_prime = (abs(y1_interp_prime - dypp_c)./(y1_interp_prime + eps))*100;

% Plot results
h = figure('WindowState','maximized');
subplot(2,1,1);
plot(x_interp, y1_interp, '-ok', 'DisplayName', 'y : x^2 + x + 1','MarkerSize',15);
hold on;
plot(x_interp, ypp, '+-b', 'DisplayName', 'Fitted Spline','MarkerSize',12);
plot(x_interp, ypp_c, '-sr', 'DisplayName', 'Fitted Spline(clamped)','MarkerSize',12);
% pbaspect([3 1 1]);
title('Spline Fitting');
xlabel('x');
ylabel('y');
legend('Location','northwest');
set(findall(gca,'-property','FontSize'),'FontSize',fs);
set(findall(gca,'-property','LineWidth'),'LineWidth',2);

subplot(2,1,2);
plot(x_interp, p_error_u, '-+b', 'DisplayName', 'Unclamped Spline Error','MarkerSize',12);
hold on;
plot(x_interp, p_error_c, '-sr', 'DisplayName', 'Clamped Spline Error','MarkerSize',12);
% pbaspect([3 1 1]);
title('Spline Fitting Error');
xlabel('x');
ylabel('Percentage Error(%)');
legend('Interpreter','latex','Location','south');
set(findall(gca,'-property','FontSize'),'FontSize',fs);
set(findall(gca,'-property','LineWidth'),'LineWidth',2);
if save_figs
    pause(0.3);
    saveas(h, fullfile(diffDir, 'y1_fit_and_error.png'));
end
% Plot derivative results
h = figure('WindowState','maximized');
subplot(2,1,1);
plot(x_interp, y1_interp_prime, '-ok', 'DisplayName', 'y'' : 2x + 1','MarkerSize',15);
hold on;
plot(x_interp, dypp, '+-b', 'DisplayName', 'Fitted Spline Derivative','MarkerSize',12);
plot(x_interp, dypp_c, '-sr', 'DisplayName', 'Fitted Spline Derivative(clamped)','MarkerSize',12);
% pbaspect([3 1 1]);
title('Spline Derivative Fitting');
xlabel('x');
ylabel('y^''');
legend('Location','northwest');
set(findall(gca,'-property','FontSize'),'FontSize',fs);
set(findall(gca,'-property','LineWidth'),'LineWidth',2);

subplot(2,1,2);
plot(x_interp, p_error_u_prime, '-+b', 'DisplayName', 'Unclamped Spline Derivative Error','MarkerSize',12);
hold on;
plot(x_interp, p_error_c_prime, '-sr', 'DisplayName', 'Clamped Spline Derivative Error','MarkerSize',12);
% pbaspect([3 1 1]);
title('Spline Derivative Fitting Error');
xlabel('x');
% ylabel('$(\frac{|y''_{true} - y''_{spline}|}{y''_{true}})\times 100$','Interpreter','latex');
ylabel('Percentage Error (%)')
legend('Interpreter','latex','Location','north');   
set(findall(gca,'-property','FontSize'),'FontSize',fs);
set(findall(gca,'-property','LineWidth'),'LineWidth',2);
if save_figs
    pause(0.3);
    saveas(h, fullfile(diffDir, 'y1_derivative_fit_and_error.png'));
end
%% Plot original data
h = figure('WindowState','maximized');
plot(x, y2, '-ob', 'DisplayName', 'y : sin(2\pi x) + exp(-0.1*x)','MarkerSize',15);
hold on;
plot(x_interp, y2_interp, '-ok', 'DisplayName', 'y (Interp) : sin(2\pi x) + exp(-0.1*x)','MarkerSize',15);
hold on
plot(x_interp, y2_interp_prime, '-+r', 'DisplayName', 'y''(Interp) : 2\pi cos(2\pi x) - 0.1exp(-0.1*x)','MarkerSize',15);
xlabel('x');
% ylabel('y');
legend('Location','north');
set(findall(gca,'-property','FontSize'),'FontSize',fs);
set(findall(gca,'-property','LineWidth'),'LineWidth',2);
if save_figs
    pause(0.3);
    saveas(h, fullfile(diffDir, 'y2_original_and_derivative.png'));
end
%% Fit spline with y2
clear ys ys_c ypp ypp_c p_error_u p_error_u_prime p_error_c p_error_c_prime dypp dypp_c dys dys_c;
[dys_c, ys_c] = fit_spline_and_diff(x, y2, 'clamping', true, 'derivative_order', 1);
[dys, ys] = fit_spline_and_diff(x, y2, 'derivative_order', 1);
ypp_c = ppval(ys_c, x_interp);
dypp_c = ppval(dys_c, x_interp);
ypp = ppval(ys, x_interp);
dypp = ppval(dys, x_interp);
%Compute error
p_error_u = (abs(y2_interp - ypp)./(y2_interp + eps))*100;
p_error_u_prime = (abs(y2_interp_prime - dypp)./(y2_interp_prime + eps))*100;
p_error_c = (abs(y2_interp - ypp_c)./(y2_interp + eps))*100;
p_error_c_prime = (abs(y2_interp_prime - dypp_c)./(y2_interp_prime + eps))*100;

% Plot results
h = figure('WindowState','maximized');
subplot(2,1,1);
plot(x_interp, y2_interp, '-ok', 'DisplayName', '$y : sin(2\pi x) + exp(-0.1*x)$','MarkerSize',15);
hold on;
plot(x_interp, ypp, '+-b', 'DisplayName', '$Fitted Spline$','MarkerSize',12);
plot(x_interp, ypp_c, '-sr', 'DisplayName', '$Fitted Spline(clamped)$','MarkerSize',12);
title('Spline Fitting');
xlabel('x');
ylabel('y');
legend('Interpreter','latex','Location','southwest');
set(findall(gca,'-property','FontSize'),'FontSize',fs);
set(findall(gca,'-property','LineWidth'),'LineWidth',2);

subplot(2,1,2);
plot(x_interp, p_error_u, '-+b', 'DisplayName', 'Unclamped Spline Error','MarkerSize',12);
hold on;
plot(x_interp, p_error_c, '-or', 'DisplayName', 'Clamped Spline Error','MarkerSize',12);
title('Spline Fitting Error');
xlabel('x');
ylabel('Percentage Error (%)');
legend('Interpreter','latex','Location','northwest');
set(findall(gca,'-property','FontSize'),'FontSize',fs);
set(findall(gca,'-property','LineWidth'),'LineWidth',2);
if save_figs
    pause(0.3);
    saveas(h, fullfile(diffDir, 'y2_fit_and_error.png'));
end
% Plot derivative results
h = figure('WindowState','maximized');
subplot(2,1,1);
plot(x_interp, y2_interp_prime, '-ok', 'DisplayName', '$y'' : 2\pi cos(2\pi x) - 0.1exp(-0.1*x)$','MarkerSize',15);
hold on;
plot(x_interp, dypp, '+-b', 'DisplayName', '$Fitted Spline Derivative$','MarkerSize',12);
plot(x_interp, dypp_c, '-sr', 'DisplayName', '$Fitted Spline Derivative(clamped)$','MarkerSize',12);
% pbaspect([3 1 1]);    
title('Spline Derivative Fitting');
xlabel('x');
ylabel('y^''');
legend('Interpreter','latex','Location','north');
set(findall(gca,'-property','FontSize'),'FontSize',fs);
set(findall(gca,'-property','LineWidth'),'LineWidth',2);

subplot(2,1,2);
plot(x_interp, p_error_u_prime, '-+b', 'DisplayName', 'Unclamped Spline Derivative Error','MarkerSize',12);
hold on;
plot(x_interp, p_error_c_prime, '-or', 'DisplayName', 'Clamped Spline Derivative Error','MarkerSize',12);
% pbaspect([3 1 1]);
title('Spline Derivative Fitting Error');
xlabel('x');
ylabel('Percentage Error (%)');
legend('Interpreter','latex','Location','north');
set(findall(gca,'-property','FontSize'),'FontSize',fs);
set(findall(gca,'-property','LineWidth'),'LineWidth',2);
if save_figs
    pause(0.3);
    saveas(h, fullfile(diffDir, 'y2_derivative_fit_and_error.png'));
end
%% Clean up