% Demonstration script for Figure 11 reproduction (quick version)
% This runs a simplified version of the full analysis for demonstration
close all; clear; clc;

fprintf('============================================\n');
fprintf('SDO Figure 11 Reproduction - Demo Version\n');
fprintf('============================================\n\n');

% Simplified parameters for quick demonstration
pop_size = 15;
max_iter = 200;
dim = 20;
num_runs = 5;

% Test functions for demonstration
test_functions = [1, 2, 3, 5];  % Sphere, Rastrigin, Ackley, Rosenbrock
function_names = {'Sphere', 'Rastrigin', 'Ackley', 'Rosenbrock'};
num_functions = length(test_functions);

% Storage for results
all_convergence = cell(num_functions, 1);
all_tracking_data = cell(num_functions, 1);

% Run analysis for each test function
for func_idx = 1:num_functions
    func_num = test_functions(func_idx);
    func_name = function_names{func_idx};
    
    fprintf('Testing %s function...\n', func_name);
    
    % Get function bounds
    [~, lb, ub] = benchmark_functions(zeros(1, dim), func_num);
    
    % Storage for multiple runs
    convergence_runs = zeros(num_runs, max_iter);
    
    % Perform runs
    for run = 1:num_runs
        fitness_func = @(x) benchmark_functions(x, func_num);
        [~, ~, conv_curve, tracking_data] = SDO_enhanced(pop_size, max_iter, lb, ub, dim, fitness_func);
        
        convergence_runs(run, :) = conv_curve;
        
        if run == 1
            all_tracking_data{func_idx} = tracking_data;
        end
    end
    
    all_convergence{func_idx} = mean(convergence_runs, 1);
    fprintf('  Completed with final fitness: %.2e\n', all_convergence{func_idx}(end));
end

% Generate Figure 11 (simplified version)
fprintf('\nGenerating Figure 11...\n');

figure('Position', [50, 50, 1400, 1000]);
set(gcf, 'Name', 'Figure 11: SDO Qualitative Analysis (Demo)', 'NumberTitle', 'off');

colors = lines(num_functions);
iterations = 1:max_iter;

% Subplot 1: Convergence curves comparison
subplot(2, 2, 1);
for i = 1:num_functions
    semilogy(iterations, all_convergence{i}, 'Color', colors(i, :), 'LineWidth', 2.5);
    hold on;
end
xlabel('Iteration', 'FontSize', 12);
ylabel('Best Fitness (log scale)', 'FontSize', 12);
title('(a) Convergence Curves Comparison', 'FontSize', 14, 'FontWeight', 'bold');
legend(function_names, 'Location', 'northeast', 'FontSize', 10);
grid on;

# Subplot 2: Parameter evolution
subplot(2, 2, 2);
tracking_sample = all_tracking_data{1}; # Use first function as example

plot(iterations, tracking_sample.y_values, 'b-', 'LineWidth', 2); hold on;
plot(iterations, tracking_sample.p1_values, 'r-', 'LineWidth', 2);
plot(iterations, tracking_sample.w1_values, 'g-', 'LineWidth', 2);
plot(iterations, tracking_sample.CF_values, 'k--', 'LineWidth', 2);

xlabel('Iteration', 'FontSize', 12);
ylabel('Parameter Values', 'FontSize', 12);
title('(b) Parameter Evolution', 'FontSize', 14, 'FontWeight', 'bold');
legend({'y', 'p1', 'w1', 'CF'}, 'Location', 'northeast', 'FontSize', 10);
grid on;

% Subplot 3: Population diversity dynamics
subplot(2, 2, 3);
for i = 1:num_functions
    tracking_data = all_tracking_data{i};
    plot(iterations, tracking_data.population_diversity, 'Color', colors(i, :), 'LineWidth', 2);
    hold on;
end
xlabel('Iteration', 'FontSize', 12);
ylabel('Population Diversity', 'FontSize', 12);
title('(c) Population Diversity Dynamics', 'FontSize', 14, 'FontWeight', 'bold');
legend(function_names, 'Location', 'northeast', 'FontSize', 10);
grid on;

% Subplot 4: Final performance comparison
subplot(2, 2, 4);
final_values = zeros(num_functions, 1);
for i = 1:num_functions
    final_values(i) = all_convergence{i}(end);
end

bar_handle = bar(final_values, 'FaceColor', [0.3, 0.6, 0.9]);
set(gca, 'XTickLabel', function_names);
xtickangle(45);
ylabel('Final Best Fitness', 'FontSize', 12);
title('(d) Statistical Performance', 'FontSize', 14, 'FontWeight', 'bold');
grid on;

% Save figure
print('Figure_11_SDO_Demo.png', '-dpng');

fprintf('\nFigure 11 generated successfully!\n');
fprintf('Saved as: Figure_11_SDO_Demo.png\n');

% Print summary
fprintf('\n========== RESULTS SUMMARY ==========\n');
for i = 1:num_functions
    fprintf('%s: Final fitness = %.2e\n', function_names{i}, final_values(i));
end
fprintf('=====================================\n');