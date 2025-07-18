% Simple test script to verify the SDO implementation
close all; clear; clc;

fprintf('Testing SDO implementation...\n');

% Test benchmark function first
x_test = [1, 2, 3];
[fitness, lb, ub] = benchmark_functions(x_test, 1);
fprintf('Benchmark function test - Sphere(1,2,3) = %.6f\n', fitness);

% Test basic SDO
pop_size = 10;
max_iter = 50;
dim = 2;
func_num = 1; % Sphere function

[~, lb, ub] = benchmark_functions(zeros(1, dim), func_num);
fitness_func = @(x) benchmark_functions(x, func_num);

fprintf('Running basic SDO test...\n');
[best_pos, best_fit, conv_curve] = SDO(pop_size, max_iter, lb, ub, dim, fitness_func);

fprintf('Basic SDO completed:\n');
fprintf('  Best position: [%.6f, %.6f]\n', best_pos(1), best_pos(2));
fprintf('  Best fitness: %.6e\n', best_fit);
fprintf('  Initial fitness: %.6e\n', conv_curve(1));
fprintf('  Final fitness: %.6e\n', conv_curve(end));

% Test enhanced SDO
fprintf('Running enhanced SDO test...\n');
[best_pos_enh, best_fit_enh, conv_curve_enh, tracking_data] = SDO_enhanced(pop_size, max_iter, lb, ub, dim, fitness_func);

fprintf('Enhanced SDO completed:\n');
fprintf('  Best position: [%.6f, %.6f]\n', best_pos_enh(1), best_pos_enh(2));
fprintf('  Best fitness: %.6e\n', best_fit_enh);
fprintf('  Tracking data fields: %d\n', length(fieldnames(tracking_data)));

% Create a simple plot to verify plotting functions work
figure('Position', [100, 100, 800, 600]);
subplot(2, 2, 1);
plot(1:max_iter, conv_curve, 'b-', 'LineWidth', 2);
xlabel('Iteration');
ylabel('Best Fitness');
title('Basic SDO Convergence');
grid on;

subplot(2, 2, 2);
plot(1:max_iter, conv_curve_enh, 'r-', 'LineWidth', 2);
xlabel('Iteration');
ylabel('Best Fitness');
title('Enhanced SDO Convergence');
grid on;

subplot(2, 2, 3);
plot(1:max_iter, tracking_data.y_values, 'g-', 'LineWidth', 2);
xlabel('Iteration');
ylabel('y parameter');
title('Parameter y Evolution');
grid on;

subplot(2, 2, 4);
plot(1:max_iter, tracking_data.population_diversity, 'm-', 'LineWidth', 2);
xlabel('Iteration');
ylabel('Population Diversity');
title('Population Diversity');
grid on;

saveas(gcf, 'test_results.png', 'png');

fprintf('Test completed successfully! Figure saved as test_results.png\n');