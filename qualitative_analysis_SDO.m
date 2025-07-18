function qualitative_analysis_SDO()
% Main script to reproduce Figure 11: Qualitative Analysis of SDO
% This script generates comprehensive analysis plots including:
% - Convergence curves for different test functions
% - Parameter evolution analysis
% - Population dynamics analysis
% - Statistical analysis of algorithm performance

    close all;
    clc;
    
    fprintf('Starting SDO Qualitative Analysis - Reproducing Figure 11\n');
    fprintf('=========================================================\n\n');
    
    % Algorithm parameters
    pop_size = 30;        % Population size
    max_iter = 500;       % Maximum iterations
    dim = 30;             % Problem dimension
    num_runs = 10;        % Number of independent runs for statistical analysis
    
    % Test functions to analyze
    test_functions = [1, 2, 3, 5];  % Sphere, Rastrigin, Ackley, Rosenbrock
    function_names = {'Sphere', 'Rastrigin', 'Ackley', 'Rosenbrock'};
    num_functions = length(test_functions);
    
    % Storage for results
    all_convergence = cell(num_functions, 1);
    all_tracking_data = cell(num_functions, 1);
    statistical_results = struct();
    
    % Run analysis for each test function
    for func_idx = 1:num_functions
        func_num = test_functions(func_idx);
        func_name = function_names{func_idx};
        
        fprintf('Analyzing function %d: %s\n', func_num, func_name);
        
        % Get function bounds
        [~, lb, ub] = benchmark_functions(zeros(1, dim), func_num);
        
        % Storage for multiple runs
        convergence_runs = zeros(num_runs, max_iter);
        final_fitness_runs = zeros(num_runs, 1);
        tracking_data_sample = [];
        
        % Perform multiple independent runs
        for run = 1:num_runs
            % Create fitness function handle
            fitness_func = @(x) benchmark_functions(x, func_num);
            
            % Run enhanced SDO
            [best_pos, best_fit, conv_curve, tracking_data] = SDO_enhanced(pop_size, max_iter, lb, ub, dim, fitness_func);
            
            convergence_runs(run, :) = conv_curve;
            final_fitness_runs(run) = best_fit;
            
            % Store tracking data from first run for detailed analysis
            if run == 1
                tracking_data_sample = tracking_data;
            end
            
            fprintf('  Run %d completed, Best fitness: %.6e\n', run, best_fit);
        end
        
        % Calculate statistics
        mean_convergence = mean(convergence_runs, 1);
        std_convergence = std(convergence_runs, 0, 1);
        
        % Store results
        all_convergence{func_idx} = mean_convergence;
        all_tracking_data{func_idx} = tracking_data_sample;
        
        statistical_results.(func_name) = struct();
        statistical_results.(func_name).mean_final = mean(final_fitness_runs);
        statistical_results.(func_name).std_final = std(final_fitness_runs);
        statistical_results.(func_name).best_final = min(final_fitness_runs);
        statistical_results.(func_name).worst_final = max(final_fitness_runs);
        statistical_results.(func_name).convergence_curve = mean_convergence;
        statistical_results.(func_name).convergence_std = std_convergence;
    end
    
    % Generate Figure 11: Comprehensive Qualitative Analysis
    fprintf('\nGenerating Figure 11: Qualitative Analysis Plots...\n');
    
    % Main Figure 11 - Multi-panel analysis
    figure('Position', [50, 50, 1600, 1200]);
    set(gcf, 'Name', 'Figure 11: Qualitative Analysis of SDO', 'NumberTitle', 'off');
    
    % Subplot 1: Convergence curves comparison
    subplot(2, 2, 1);
    colors = lines(num_functions);
    iterations = 1:max_iter;
    
    for i = 1:num_functions
        conv_data = all_convergence{i};
        std_data = statistical_results.(function_names{i}).convergence_std;
        
        % Plot mean convergence with error bars
        semilogy(iterations, conv_data, 'Color', colors(i, :), 'LineWidth', 2.5);
        hold on;
        
        % Add standard deviation as shaded area
        upper_bound = conv_data + std_data;
        lower_bound = max(conv_data - std_data, 1e-15);
        fill([iterations, fliplr(iterations)], [upper_bound, fliplr(lower_bound)], ...
             colors(i, :), 'Alpha', 0.2, 'EdgeColor', 'none');
    end
    
    xlabel('Iteration', 'FontSize', 12);
    ylabel('Best Fitness (log scale)', 'FontSize', 12);
    title('(a) Convergence Curves Comparison', 'FontSize', 14, 'FontWeight', 'bold');
    legend(function_names, 'Location', 'northeast', 'FontSize', 10);
    grid on;
    set(gca, 'FontSize', 10);
    
    % Subplot 2: Parameter evolution over iterations
    subplot(2, 2, 2);
    tracking_sample = all_tracking_data{1}; % Use first function as example
    
    plot(iterations, tracking_sample.y_values, 'b-', 'LineWidth', 2); hold on;
    plot(iterations, tracking_sample.p1_values, 'r-', 'LineWidth', 2);
    plot(iterations, tracking_sample.w1_values, 'g-', 'LineWidth', 2);
    plot(iterations, tracking_sample.CF_values, 'k--', 'LineWidth', 2);
    
    xlabel('Iteration', 'FontSize', 12);
    ylabel('Parameter Values & Control Factor', 'FontSize', 12);
    title('(b) Parameter Evolution Over Iterations', 'FontSize', 14, 'FontWeight', 'bold');
    legend({'y', 'p1', 'w1', 'CF'}, 'Location', 'northeast', 'FontSize', 10);
    grid on;
    set(gca, 'FontSize', 10);
    
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
    set(gca, 'FontSize', 10);
    
    % Subplot 4: Statistical comparison
    subplot(2, 2, 4);
    mean_values = zeros(num_functions, 1);
    std_values = zeros(num_functions, 1);
    
    for i = 1:num_functions
        mean_values(i) = statistical_results.(function_names{i}).mean_final;
        std_values(i) = statistical_results.(function_names{i}).std_final;
    end
    
    bar_handle = bar(mean_values, 'FaceColor', [0.3, 0.6, 0.9]);
    hold on;
    errorbar(1:num_functions, mean_values, std_values, 'k.', 'LineWidth', 2, 'MarkerSize', 1);
    
    set(gca, 'XTickLabel', function_names);
    xtickangle(45);
    ylabel('Final Best Fitness ± Std', 'FontSize', 12);
    title('(d) Statistical Performance Comparison', 'FontSize', 14, 'FontWeight', 'bold');
    grid on;
    set(gca, 'FontSize', 10);
    
    % Adjust overall figure appearance
    % sgtitle('Figure 11: Qualitative Analysis of SDO Algorithm', 'FontSize', 18, 'FontWeight', 'bold'); % Not available in older versions
    
    % Save the figure
    saveas(gcf, 'Figure_11_SDO_Qualitative_Analysis.png', 'png');
    saveas(gcf, 'Figure_11_SDO_Qualitative_Analysis.fig', 'fig');
    
    % Generate additional detailed plots
    fprintf('Generating additional analysis plots...\n');
    
    % Detailed parameter evolution plot
    plot_parameter_evolution(all_tracking_data{1}, max_iter);
    saveas(gcf, 'SDO_Parameter_Evolution_Detailed.png', 'png');
    
    % Detailed convergence analysis
    analyze_convergence(all_convergence, function_names, max_iter);
    saveas(gcf, 'SDO_Convergence_Analysis_Detailed.png', 'png');
    
    % Print comprehensive statistical report
    fprintf('\n===============================\n');
    fprintf('STATISTICAL ANALYSIS SUMMARY\n');
    fprintf('===============================\n');
    fprintf('Algorithm: SDO (Sled Dog-inspired Optimizer)\n');
    fprintf('Population Size: %d\n', pop_size);
    fprintf('Maximum Iterations: %d\n', max_iter);
    fprintf('Problem Dimension: %d\n', dim);
    fprintf('Number of Runs: %d\n\n', num_runs);
    
    for i = 1:num_functions
        func_name = function_names{i};
        stats = statistical_results.(func_name);
        
        fprintf('%s Function Results:\n', func_name);
        fprintf('  Mean ± Std:     %.6e ± %.6e\n', stats.mean_final, stats.std_final);
        fprintf('  Best:           %.6e\n', stats.best_final);
        fprintf('  Worst:          %.6e\n', stats.worst_final);
        fprintf('  Final Conv:     %.6e\n', stats.convergence_curve(end));
        fprintf('\n');
    end
    
    fprintf('Analysis completed successfully!\n');
    fprintf('Generated files:\n');
    fprintf('  - Figure_11_SDO_Qualitative_Analysis.png\n');
    fprintf('  - Figure_11_SDO_Qualitative_Analysis.fig\n');
    fprintf('  - SDO_Parameter_Evolution_Detailed.png\n');
    fprintf('  - SDO_Convergence_Analysis_Detailed.png\n');
    
end