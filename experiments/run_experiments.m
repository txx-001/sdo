function run_experiments()
    % Main experimental script to reproduce SDO paper results
    % Runs comprehensive experiments comparing SDO with other algorithms
    % on CEC2017 benchmark functions
    
    clear; clc;
    fprintf('=== SDO EXPERIMENTAL FRAMEWORK ===\n');
    fprintf('Reproducing results from Section 4 of SDO paper\n\n');
    
    % Add paths
    addpath('/home/runner/work/sdo/sdo/experiments/algorithms');
    addpath('/home/runner/work/sdo/sdo/experiments/utils');
    
    % Experimental parameters
    pop_size = 50;           % Population size
    max_iter = 300;          % Maximum iterations
    num_runs = 30;           % Number of independent runs
    lb = -100;               % Lower bound
    ub = 100;                % Upper bound
    
    % Test dimensions
    dimensions = [30, 50, 100];
    
    % Test functions (CEC2017 F1-F10 for demonstration)
    test_functions = 1:10;
    
    % Algorithm names and function handles
    algorithms = {
        'SDO', @SDO;
        'PSO', @PSO;
        'GWO', @GWO;
        'WOA', @WOA;
        'SCA', @SCA;
        'SSA', @SSA;
        'HHO', @HHO;
        'TSA', @TSA
    };
    
    algorithm_names = algorithms(:, 1);
    algorithm_funcs = algorithms(:, 2);
    num_algorithms = length(algorithm_names);
    
    % Initialize results storage
    results_data = cell(length(dimensions), 1);
    convergence_data = cell(length(dimensions), 1);
    
    % Run experiments for each dimension
    for d_idx = 1:length(dimensions)
        dim = dimensions(d_idx);
        fprintf('\n=== RUNNING EXPERIMENTS FOR %dD ===\n', dim);
        
        % Initialize storage for current dimension
        results_matrix = cell(num_algorithms, 1);
        convergence_matrix = cell(num_algorithms, 1);
        
        for alg = 1:num_algorithms
            results_matrix{alg} = zeros(num_runs, length(test_functions));
            convergence_matrix{alg} = cell(length(test_functions), 1);
        end
        
        % Run experiments for each function
        for f_idx = 1:length(test_functions)
            func_num = test_functions(f_idx);
            fprintf('\nTesting Function F%d (%dD):\n', func_num, dim);
            
            % Define objective function
            fobj = @(x) cec17_func(x, func_num);
            
            % Test each algorithm
            for alg = 1:num_algorithms
                alg_name = algorithm_names{alg};
                alg_func = algorithm_funcs{alg};
                
                fprintf('  Running %s... ', alg_name);
                tic;
                
                % Storage for current algorithm and function
                run_results = zeros(num_runs, 1);
                run_convergence = zeros(num_runs, max_iter);
                
                % Run multiple independent runs
                for run = 1:num_runs
                    [~, best_score, convergence] = alg_func(pop_size, max_iter, lb, ub, dim, fobj);
                    run_results(run) = best_score;
                    run_convergence(run, :) = convergence;
                    
                    if mod(run, 10) == 0
                        fprintf('%d ', run);
                    end
                end
                
                % Store results
                results_matrix{alg}(:, f_idx) = run_results;
                convergence_matrix{alg}{f_idx} = run_convergence;
                
                elapsed_time = toc;
                fprintf('Done (%.2fs)\n', elapsed_time);
            end
        end
        
        % Store results for current dimension
        results_data{d_idx} = results_matrix;
        convergence_data{d_idx} = convergence_matrix;
        
        % Perform statistical analysis for current dimension
        fprintf('\n=== STATISTICAL ANALYSIS FOR %dD ===\n', dim);
        stats = statistical_analysis(results_matrix, algorithm_names);
        
        % Perform Wilcoxon rank-sum test (SDO as reference)
        fprintf('\n=== WILCOXON TEST FOR %dD ===\n', dim);
        wilcoxon_results = wilcoxon_test(results_matrix, algorithm_names, 1);
        
        % Plot convergence curves
        fprintf('\n=== GENERATING CONVERGENCE PLOTS FOR %dD ===\n', dim);
        plot_convergence(convergence_matrix, algorithm_names, test_functions, true);
        
        % Save results to file
        save_results(results_matrix, convergence_matrix, stats, wilcoxon_results, ...
                    algorithm_names, test_functions, dim);
    end
    
    % Generate summary comparison across dimensions
    fprintf('\n=== GENERATING SUMMARY COMPARISON ===\n');
    generate_summary_comparison(results_data, convergence_data, algorithm_names, ...
                               test_functions, dimensions);
    
    fprintf('\n=== EXPERIMENT COMPLETED ===\n');
    fprintf('Results saved in: /home/runner/work/sdo/sdo/experiments/results/\n');
end

function save_results(results_matrix, convergence_matrix, stats, wilcoxon_results, ...
                     algorithm_names, test_functions, dim)
    % Save experimental results to files
    
    % Create results directory
    results_dir = '/home/runner/work/sdo/sdo/experiments/results';
    if ~exist(results_dir, 'dir')
        mkdir(results_dir);
    end
    
    % Save .mat file with all data
    filename = sprintf('%s/results_%dD.mat', results_dir, dim);
    save(filename, 'results_matrix', 'convergence_matrix', 'stats', 'wilcoxon_results', ...
         'algorithm_names', 'test_functions', 'dim');
    
    % Save CSV file with mean results
    csv_filename = sprintf('%s/mean_results_%dD.csv', results_dir, dim);
    
    % Create CSV header
    header = 'Function';
    for alg = 1:length(algorithm_names)
        header = [header, ',', algorithm_names{alg}];
    end
    
    % Write CSV file
    fid = fopen(csv_filename, 'w');
    fprintf(fid, '%s\n', header);
    
    for f = 1:length(test_functions)
        fprintf(fid, 'F%d', test_functions(f));
        for alg = 1:length(algorithm_names)
            fprintf(fid, ',%.6e', stats.mean(alg, f));
        end
        fprintf(fid, '\n');
    end
    fclose(fid);
    
    fprintf('Results saved: %s\n', filename);
    fprintf('CSV saved: %s\n', csv_filename);
end

function generate_summary_comparison(results_data, convergence_data, algorithm_names, ...
                                   test_functions, dimensions)
    % Generate summary comparison across all dimensions
    
    fprintf('Generating cross-dimensional analysis...\n');
    
    % Create comprehensive convergence plot for selected functions
    selected_funcs = [1, 3, 5, 7]; % Select representative functions
    
    figure('Position', [100, 100, 1200, 900]);
    
    for f_idx = 1:length(selected_funcs)
        func_num = selected_funcs(f_idx);
        
        for d_idx = 1:length(dimensions)
            subplot_idx = (f_idx - 1) * length(dimensions) + d_idx;
            subplot(length(selected_funcs), length(dimensions), subplot_idx);
            hold on;
            
            dim = dimensions(d_idx);
            conv_data = convergence_data{d_idx};
            
            % Plot convergence for each algorithm
            colors = lines(length(algorithm_names));
            for alg = 1:length(algorithm_names)
                if ~isempty(conv_data{alg}{func_num})
                    mean_conv = mean(conv_data{alg}{func_num}, 1);
                    plot(1:length(mean_conv), mean_conv, 'Color', colors(alg, :), ...
                         'LineWidth', 1.5);
                end
            end
            
            title(sprintf('F%d (%dD)', func_num, dim), 'FontSize', 10);
            xlabel('Iteration', 'FontSize', 9);
            ylabel('Best Fitness', 'FontSize', 9);
            set(gca, 'YScale', 'log');
            grid on;
            
            if subplot_idx == 1
                legend(algorithm_names, 'Location', 'best', 'FontSize', 8);
            end
        end
    end
    
    sgtitle('Cross-Dimensional Convergence Comparison', 'FontSize', 14, 'FontWeight', 'bold');
    
    % Save summary plot
    results_dir = '/home/runner/work/sdo/sdo/experiments/results';
    print([results_dir, '/summary_convergence.png'], '-dpng', '-r300');
    
    fprintf('Summary convergence plot saved.\n');
end