clear;clc;close all;
%%
% Unit test for fit_spline function
addpath('../../src/functions');

% Prepare output directory for saving figures
% Determine script directory (fallback to pwd if unavailable) and
% create data/processed relative to the script location.
scriptFullPath = mfilename('fullpath');
if isempty(scriptFullPath)
	scriptDir = pwd;
else
	scriptDir = fileparts(scriptFullPath);
end
processedDir = fullfile(scriptDir, '..', '..', 'data', 'processed');
if ~exist(processedDir, 'dir')
	mkdir(processedDir);
end

% Generate synthetic data
eps = 1e-8; % Small constant to avoid division by zero
x = [0 0.1 0.3 0.5 0.7 0.9 1.0]';
x_interp = linspace(0, 1, 50)';
y1 = x.^2 + x + 1 + 0.1*randn(size(x));
y1_interp = x_interp.^2 + x_interp + 1 + 0.1*randn(size(x_interp));

y2 = sin(2*pi*x) + exp(-0.1*x) + 0.1*randn(size(x));
y2_interp = sin(2*pi*x_interp) + exp(-0.1*x_interp) + 0.1*randn(size(x_interp));

y3 = log(x + 1) + 0.5*x + 0.1*randn(size(x));
y3_interp = log(x_interp + 1) + 0.5*x_interp + 0.1*randn(size(x_interp));

y4 = 2*x.^3 - 5*x.^2 + 3*x + 7 + sin(2*pi*x) + cos(pi*x) + exp(-0.5*x) + log(x + 1) + tanh(0.1*x) + 0.2*randn(size(x));
y4_interp = 2*x_interp.^3 - 5*x_interp.^2 + 3*x_interp + 7 + sin(2*pi*x_interp) + cos(pi*x_interp) + exp(-0.5*x_interp) + log(x_interp + 1) + tanh(0.1*x_interp) + 0.2*randn(size(x_interp));

fs = 33; % Font size for plots
%% Plot original data
h = figure('WindowState','maximized');
plot(x, y1, '-ob', 'DisplayName', 'f : x^2 + x + 1','MarkerSize',15);
hold on;
plot(x_interp, y1_interp, '-ok', 'DisplayName', 'f (Interp) : x^2 + x + 1','MarkerSize',15);
xlabel('x');
ylabel('y');
legend('Location','northwest');
set(findall(gca,'-property','FontSize'),'FontSize',fs);
set(findall(gca,'-property','LineWidth'),'LineWidth',2);
% Save original data figure for y1
saveas(h, fullfile(processedDir, 'y1_original.png'));

%% Fit splines with y1 
[ys_c] = fit_spline(x, y1, 'clamping', true);
[ys] = fit_spline(x, y1);
ypp_c = ppval(ys_c, x_interp);
ypp = ppval(ys, x_interp);

%Compute error
perc_error_u = (abs(y1_interp - ypp)./(y1_interp + eps))*100;
perc_error_c = (abs(y1_interp - ypp_c)./(y1_interp + eps))*100;

% Plot results
h = figure('WindowState','maximized');
subplot(2,1,1);
plot(x_interp, y1_interp, '-ok', 'DisplayName', 'f : x^2 + x + 1','MarkerSize',15);
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
% Save fitted spline + error figure for y1
subplot(2,1,2);
plot(x_interp, perc_error_u, '-+b', 'DisplayName', 'Unclamped Spline Error','MarkerSize',12);
hold on;
plot(x_interp, perc_error_c, '-sr', 'DisplayName', 'Clamped Spline Error','MarkerSize',12);
% pbaspect([3 1 1]);
title('Spline Fitting Error');
xlabel('x');
ylabel('$(\frac{|y_{true} - y_{spline}|}{y_{true}})\times 100$','Interpreter','latex');
legend('Interpreter','latex','Location','northwest');
set(findall(gca,'-property','FontSize'),'FontSize',fs);
set(findall(gca,'-property','LineWidth'),'LineWidth',2);
pause(0.5)
saveas(h, fullfile(processedDir, 'y1_fit_and_error.png'));
%% Plot original data
h = figure('WindowState','maximized');
plot(x, y2, '-ob', 'DisplayName', 'f : sin(2\pi x) + exp(-0.1*x)','MarkerSize',15);
hold on;
plot(x_interp, y2_interp, '-ok', 'DisplayName', 'f (Interp) : sin(2\pi x) + exp(-0.1*x)','MarkerSize',15);
xlabel('x');
ylabel('y');
legend('Location','northwest');
set(findall(gca,'-property','FontSize'),'FontSize',fs);
set(findall(gca,'-property','LineWidth'),'LineWidth',2);
% Save original data figure for y2
pause(0.5) 
saveas(h, fullfile(processedDir, 'y2_original.png'));
%% Fit spline with y2
clear ys ys_c ypp ypp_c perc_error_u perc_error_c;
[ys_c] = fit_spline(x, y2, 'clamping', true);
[ys] = fit_spline(x, y2);
ypp_c = ppval(ys_c, x_interp);
ypp = ppval(ys, x_interp);

%Compute error
perc_error_u = (abs(y2_interp - ypp)./(y2_interp + eps))*100;
perc_error_c = (abs(y2_interp - ypp_c)./(y2_interp + eps))*100;

% Plot results
h = figure('WindowState','maximized');
subplot(2,1,1);
plot(x_interp, y2_interp, '-ok', 'DisplayName', '$f : sin(2\pi x) + exp(-0.1*x)$','MarkerSize',15);
hold on;
plot(x_interp, ypp, '+-b', 'DisplayName', '$Fitted Spline$','MarkerSize',12);
plot(x_interp, ypp_c, '-sr', 'DisplayName', '$Fitted Spline(clamped)$','MarkerSize',12);
title('Spline Fitting');
xlabel('x');
ylabel('y');
legend('Interpreter','latex','Location','northwest');
set(findall(gca,'-property','FontSize'),'FontSize',fs);
set(findall(gca,'-property','LineWidth'),'LineWidth',2);
subplot(2,1,2);
plot(x_interp, perc_error_u, '-+b', 'DisplayName', 'Unclamped Spline Error','MarkerSize',12);
hold on;
plot(x_interp, perc_error_c, '-or', 'DisplayName', 'Clamped Spline Error','MarkerSize',12);
title('Spline Fitting Error');
xlabel('x');
ylabel('$(\frac{|y_{true} - y_{spline}|}{y_{true}})\times 100$','Interpreter','latex');
legend('Interpreter','latex','Location','northwest');
set(findall(gca,'-property','FontSize'),'FontSize',fs);
set(findall(gca,'-property','LineWidth'),'LineWidth',2);
% Save fitted spline + error figure for y2
pause(0.5)
saveas(h, fullfile(processedDir, 'y2_fit_and_error.png'));
%% Fit spline with y3
clear ys ys_c ypp ypp_c perc_error_u perc_error_c;
[ys_c] = fit_spline(x, y3, 'clamping', true);
[ys] = fit_spline(x, y3);
ypp_c = ppval(ys_c, x_interp);
ypp = ppval(ys, x_interp);

% Error
perc_error_u = (abs(y3_interp - ypp)./y3_interp)*100;
perc_error_c = (abs(y3_interp - ypp_c)./y3_interp)*100;

% Plot results
h = figure('WindowState','maximized');
subplot(2,1,1);
plot(x_interp, y3_interp, '-ok', 'DisplayName', '$f : log(x + 1) + 0.5x$','MarkerSize',15);
hold on;
plot(x_interp, ypp, '+-b', 'DisplayName', '$Fitted Spline$','MarkerSize',12);
plot(x_interp, ypp_c, '-sr', 'DisplayName', '$Fitted Spline(clamped)$','MarkerSize',12);
title('Spline Fitting');        
xlabel('x');
ylabel('y');
legend('Interpreter','latex','Location','northwest');
set(findall(gca,'-property','FontSize'),'FontSize',fs);
set(findall(gca,'-property','LineWidth'),'LineWidth',2);
subplot(2,1,2);
plot(x_interp, perc_error_u, '-+b', 'DisplayName', 'Unclamped Spline Error','MarkerSize',12);
hold on;
plot(x_interp, perc_error_c, '-or', 'DisplayName', 'Clamped Spline Error','MarkerSize',12);
title('Spline Fitting Error');
xlabel('x');
ylabel('$(\frac{|y_{true} - y_{spline}|}{y_{true}})\times 100$','Interpreter','latex');
legend('Interpreter','latex','Location','northwest');
set(findall(gca,'-property','FontSize'),'FontSize',fs);
set(findall(gca,'-property','LineWidth'),'LineWidth',2);
% Save fitted spline + error figure for y3
pause(0.5)
saveas(h, fullfile(processedDir, 'y3_fit_and_error.png'));
%% Fit spline with y4
clear ys ys_c ypp ypp_c perc_error_u perc_error_c;
[ys_c] = fit_spline(x, y4, 'clamping', true);
[ys] = fit_spline(x, y4);
ypp_c = ppval(ys_c, x_interp);
ypp = ppval(ys, x_interp);
% Error
perc_error_u = (abs(y4_interp - ypp)./y4_interp)*100; 
perc_error_c = (abs(y4_interp - ypp_c)./y4_interp)*100;

% Plot results
h = figure('WindowState','maximized');
subplot(2,1,1);
plot(x_interp, y4_interp, '-ok','DisplayName','Actual f','MarkerSize',15);
hold on;
plot(x_interp, ypp, '+-b', 'DisplayName', '$Fitted Spline$','MarkerSize',12);
plot(x_interp, ypp_c, '-sr', 'DisplayName', '$Fitted Spline(clamped)$','MarkerSize',12);
title('$f : 2x^3 - 5x^2 \newline + 3x + 7 + sin(2\pi x) \\+ cos(\pi x) + exp(-0.5x) \\+ log(x + 1) + tanh(0.1x)$','Interpreter','latex');
xlabel('x');
ylabel('y');
legend('Interpreter','latex','Location','northwest');
set(findall(gca,'-property','FontSize'),'FontSize',fs);
set(findall(gca,'-property','LineWidth'),'LineWidth',2);
subplot(2,1,2);
plot(x_interp, perc_error_u, '-+b', 'DisplayName', 'Unclamped Spline Error','MarkerSize',12);
hold on;
plot(x_interp, perc_error_c, '-or', 'DisplayName', 'Clamped Spline Error','MarkerSize',12);
title('Spline Fitting Error');
xlabel('x');
ylabel('$(\frac{|y_{true} - y_{spline}|}{y_{true}})\times 100$','Interpreter','latex');
legend('Interpreter','latex','Location','northwest');
set(findall(gca,'-property','FontSize'),'FontSize',fs);
set(findall(gca,'-property','LineWidth'),'LineWidth',2);
% Save fitted spline + error figure for y4
pause(0.5)
saveas(h, fullfile(processedDir, 'y4_fit_and_error.png'));
%% Clean up