function generate_sample_fig11()
    % Generate a sample convergence plot similar to Fig. 11 from the SDO paper
    % This creates publication-quality convergence curves for demonstration
    
    fprintf('Generating sample convergence plots (Fig. 11 style)...\n');
    
    % Add paths
    addpath('/home/runner/work/sdo/sdo/experiments/algorithms');
    addpath('/home/runner/work/sdo/sdo/experiments/utils');
    
    % Parameters for quick demo
    pop_size = 30;
    max_iter = 200;
    num_runs = 3;
    lb = -100;
    ub = 100;
    dim = 30;
    
    % Select representative functions (similar to paper's Fig. 11)
    test_functions = [1, 3, 5, 7];  % F1, F3, F5, F7
    
    % Algorithms to compare
    algorithms = {
        'SDO', @SDO;
        'PSO', @PSO;
        'GWO', @GWO;
        'WOA', @WOA;
        'SCA', @SCA
    };
    
    algorithm_names = algorithms(:, 1);
    algorithm_funcs = algorithms(:, 2);
    num_algorithms = length(algorithm_names);
    
    % Colors for publication-quality plots
    colors = {
        [1, 0, 0],      % Red - SDO
        [0, 0, 1],      % Blue - PSO  
        [0, 0.6, 0],    % Green - GWO
        [1, 0.5, 0],    % Orange - WOA
        [0.6, 0, 0.6]   % Purple - SCA
    };
    
    % Line styles
    line_styles = {'-', '--', '-.', ':', '-'};
    
    % Create figure similar to paper's Fig. 11
    figure('Position', [100, 100, 1000, 800]);
    
    % Run experiments and collect data
    convergence_data = cell(num_algorithms, length(test_functions));
    
    for f_idx = 1:length(test_functions)
        func_num = test_functions(f_idx);
        fprintf('Processing F%d...', func_num);
        
        % Define objective function
        fobj = @(x) cec17_func(x, func_num);
        
        for alg = 1:num_algorithms
            alg_func = algorithm_funcs{alg};
            
            % Run multiple times and average
            all_convergence = zeros(num_runs, max_iter);
            for run = 1:num_runs
                [~, ~, convergence] = alg_func(pop_size, max_iter, lb, ub, dim, fobj);
                all_convergence(run, :) = convergence;
            end
            
            % Store mean convergence
            convergence_data{alg, f_idx} = mean(all_convergence, 1);
        end
        fprintf(' Done\n');
    end
    
    % Create subplots for each function
    for f_idx = 1:length(test_functions)
        subplot(2, 2, f_idx);
        hold on;
        
        func_num = test_functions(f_idx);
        
        % Plot convergence curves for each algorithm
        legend_entries = {};
        for alg = 1:num_algorithms
            conv_curve = convergence_data{alg, f_idx};
            
            plot(1:max_iter, conv_curve, ...
                 'Color', colors{alg}, ...
                 'LineStyle', line_styles{alg}, ...
                 'LineWidth', 2, ...
                 'MarkerSize', 4);
            
            legend_entries{end+1} = algorithm_names{alg};
        end
        
        % Formatting to match paper style
        title(sprintf('F%d', func_num), 'FontSize', 14, 'FontWeight', 'bold');
        xlabel('Iteration', 'FontSize', 12);
        ylabel('Best Fitness Value', 'FontSize', 12);
        set(gca, 'YScale', 'log');
        grid on;
        
        % Add legend to first subplot only
        if f_idx == 1
            legend(legend_entries, 'Location', 'northeast', 'FontSize', 10);
        end
        
        % Set consistent axis limits
        xlim([1, max_iter]);
        ylim([1e-10, 1e12]);  % Adjust based on function values
    end
    
    % Add overall title
    annotation('textbox', [0.3, 0.95, 0.4, 0.04], ...
               'String', 'Convergence Curves - SDO vs Competitors', ...
               'FontSize', 16, 'FontWeight', 'bold', ...
               'HorizontalAlignment', 'center', 'EdgeColor', 'none');
    
    % Save the plot
    results_dir = '/home/runner/work/sdo/sdo/experiments/results';
    if ~exist(results_dir, 'dir')
        mkdir(results_dir);
    end
    
    % Save as high-resolution image
    filename = [results_dir, '/fig11_style_convergence.png'];
    print(filename, '-dpng', '-r300');
    
    % Also save as MATLAB figure
    savefig([results_dir, '/fig11_style_convergence.fig']);
    
    fprintf('\nPublication-style convergence plot generated!\n');
    fprintf('Saved as: %s\n', filename);
    
    % Generate individual high-quality plots for each function
    for f_idx = 1:length(test_functions)
        func_num = test_functions(f_idx);
        
        figure('Position', [100, 100, 600, 450]);
        hold on;
        
        % Plot convergence curves
        legend_entries = {};
        for alg = 1:num_algorithms
            conv_curve = convergence_data{alg, f_idx};
            
            plot(1:max_iter, conv_curve, ...
                 'Color', colors{alg}, ...
                 'LineStyle', line_styles{alg}, ...
                 'LineWidth', 2.5);
            
            legend_entries{end+1} = algorithm_names{alg};
        end
        
        % Professional formatting
        title(sprintf('Convergence Curves for CEC2017 F%d', func_num), ...
              'FontSize', 14, 'FontWeight', 'bold');
        xlabel('Iteration', 'FontSize', 12);
        ylabel('Best Fitness Value', 'FontSize', 12);
        set(gca, 'YScale', 'log');
        grid on;
        legend(legend_entries, 'Location', 'best', 'FontSize', 11);
        
        % Set limits and improve appearance
        xlim([1, max_iter]);
        set(gca, 'FontSize', 11);
        
        % Save individual plot
        individual_filename = sprintf('%s/convergence_F%d_detailed.png', results_dir, func_num);
        print(individual_filename, '-dpng', '-r300');
        
        close;  % Close individual figure
    end
    
    fprintf('Individual convergence plots also generated in results directory.\n');
    fprintf('\nAll plots ready for publication use!\n');
end