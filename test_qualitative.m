% Quick test of the main qualitative analysis script
close all; clear; clc;

fprintf('Testing qualitative analysis (reduced version)...\n');

% Reduced parameters for quick testing
pop_size = 10;
max_iter = 100;
dim = 10;
num_runs = 3;

% Test functions
test_functions = [1, 2];  % Just Sphere and Rastrigin for quick test
function_names = {'Sphere', 'Rastrigin'};
num_functions = length(test_functions);

% Storage for results
all_convergence = cell(num_functions, 1);
all_tracking_data = cell(num_functions, 1);

% Run analysis for each test function
for func_idx = 1:num_functions
    func_num = test_functions(func_idx);
    func_name = function_names{func_idx};
    
    fprintf('Analyzing function %d: %s\n', func_num, func_name);
    
    % Get function bounds
    [~, lb, ub] = benchmark_functions(zeros(1, dim), func_num);
    
    % Storage for multiple runs
    convergence_runs = zeros(num_runs, max_iter);
    
    % Perform multiple independent runs
    for run = 1:num_runs
        % Create fitness function handle
        fitness_func = @(x) benchmark_functions(x, func_num);
        
        % Run enhanced SDO
        [best_pos, best_fit, conv_curve, tracking_data] = SDO_enhanced(pop_size, max_iter, lb, ub, dim, fitness_func);
        
        convergence_runs(run, :) = conv_curve;
        
        % Store tracking data from first run
        if run == 1
            all_tracking_data{func_idx} = tracking_data;
        end
        
        fprintf('  Run %d completed, Best fitness: %.6e\n', run, best_fit);
    end
    
    % Calculate mean convergence
    mean_convergence = mean(convergence_runs, 1);
    all_convergence{func_idx} = mean_convergence;
end

% Generate test figure
fprintf('Generating test figure...\n');

figure('Position', [50, 50, 1200, 800]);

% Subplot 1: Convergence curves
subplot(2, 2, 1);
colors = lines(num_functions);
iterations = 1:max_iter;

for i = 1:num_functions
    conv_data = all_convergence{i};
    semilogy(iterations, conv_data, 'Color', colors(i, :), 'LineWidth', 2);
    hold on;
end

xlabel('Iteration');
ylabel('Best Fitness (log scale)');
title('Convergence Curves Comparison');
legend(function_names, 'Location', 'best');
grid on;

% Subplot 2: Parameter evolution
subplot(2, 2, 2);
tracking_sample = all_tracking_data{1};

plot(iterations, tracking_sample.y_values, 'b-', 'LineWidth', 2); hold on;
plot(iterations, tracking_sample.p1_values, 'r-', 'LineWidth', 2);
plot(iterations, tracking_sample.w1_values, 'g-', 'LineWidth', 2);

xlabel('Iteration');
ylabel('Parameter Values');
title('Parameter Evolution');
legend({'y', 'p1', 'w1'}, 'Location', 'best');
grid on;

% Subplot 3: Population diversity
subplot(2, 2, 3);
for i = 1:num_functions
    tracking_data = all_tracking_data{i};
    plot(iterations, tracking_data.population_diversity, 'Color', colors(i, :), 'LineWidth', 2);
    hold on;
end
xlabel('Iteration');
ylabel('Population Diversity');
title('Population Diversity Dynamics');
legend(function_names, 'Location', 'best');
grid on;

% Subplot 4: Final fitness comparison
subplot(2, 2, 4);
final_values = zeros(num_functions, 1);
for i = 1:num_functions
    final_values(i) = all_convergence{i}(end);
end
bar(final_values);
set(gca, 'XTickLabel', function_names);
ylabel('Final Best Fitness');
title('Final Performance Comparison');
grid on;

% sgtitle('SDO Qualitative Analysis Test', 'FontSize', 14); % Not available in older Octave

saveas(gcf, 'qualitative_analysis_test.png', 'png');

fprintf('Test completed successfully!\n');
fprintf('Generated qualitative_analysis_test.png\n');