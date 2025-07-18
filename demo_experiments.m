function demo_experiments()
    % Comprehensive demo of the SDO experimental framework
    % This demonstrates the complete experimental setup from the paper
    
    clear; clc;
    fprintf('============================================\n');
    fprintf('SDO EXPERIMENTAL FRAMEWORK DEMONSTRATION\n');
    fprintf('Reproducing Paper Results - Section 4\n');
    fprintf('============================================\n\n');
    
    % Add paths
    addpath('/home/runner/work/sdo/sdo/experiments/algorithms');
    addpath('/home/runner/work/sdo/sdo/experiments/utils');
    
    % Demo parameters (scaled down for demonstration)
    pop_size = 30;          % Population size (paper uses 50)
    max_iter = 100;         % Maximum iterations (paper uses 300)
    num_runs = 5;           % Number of independent runs (paper uses 30)
    lb = -100;              % Lower bound
    ub = 100;               % Upper bound
    
    % Test dimensions (paper uses 30D, 50D, 100D)
    dimensions = [30];      % Demo with 30D only
    
    % Test functions (paper uses F1-F30, demo with F1-F5)
    test_functions = 1:5;
    
    % All algorithms from the paper
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
    
    fprintf('EXPERIMENTAL SETUP:\n');
    fprintf('- Population size: %d\n', pop_size);
    fprintf('- Maximum iterations: %d\n', max_iter);
    fprintf('- Independent runs: %d\n', num_runs);
    fprintf('- Dimensions tested: %s\n', mat2str(dimensions));
    fprintf('- Functions tested: F%d-F%d\n', min(test_functions), max(test_functions));
    fprintf('- Algorithms: %s\n', strjoin(algorithm_names, ', '));
    fprintf('\n');
    
    % Run experiments for each dimension
    for d_idx = 1:length(dimensions)
        dim = dimensions(d_idx);
        fprintf('==========================================\n');
        fprintf('RUNNING EXPERIMENTS FOR %dD\n', dim);
        fprintf('==========================================\n\n');
        
        % Initialize storage for current dimension
        results_matrix = cell(num_algorithms, 1);
        convergence_matrix = cell(num_algorithms, 1);
        
        for alg = 1:num_algorithms
            results_matrix{alg} = zeros(num_runs, length(test_functions));
            convergence_matrix{alg} = cell(length(test_functions), 1);
        end
        
        % Run experiments for each function
        total_experiments = length(test_functions) * num_algorithms * num_runs;
        current_experiment = 0;
        
        for f_idx = 1:length(test_functions)
            func_num = test_functions(f_idx);
            fprintf('Testing Function F%d (%dD):\n', func_num, dim);
            
            % Define objective function
            fobj = @(x) cec17_func(x, func_num);
            
            % Test each algorithm
            for alg = 1:num_algorithms
                alg_name = algorithm_names{alg};
                alg_func = algorithm_funcs{alg};
                
                fprintf('  %s: Running', alg_name);
                tic;
                
                % Storage for current algorithm and function
                run_results = zeros(num_runs, 1);
                run_convergence = zeros(num_runs, max_iter);
                
                % Run multiple independent runs
                for run = 1:num_runs
                    [~, best_score, convergence] = alg_func(pop_size, max_iter, lb, ub, dim, fobj);
                    run_results(run) = best_score;
                    run_convergence(run, :) = convergence;
                    
                    current_experiment = current_experiment + 1;
                    if mod(run, 2) == 0
                        fprintf('.');
                    end
                end
                
                % Store results
                results_matrix{alg}(:, f_idx) = run_results;
                convergence_matrix{alg}{f_idx} = run_convergence;
                
                elapsed_time = toc;
                progress = current_experiment / total_experiments * 100;
                fprintf(' Done (%.2fs) [%.1f%%]\n', elapsed_time, progress);
            end
            fprintf('\n');
        end
        
        % Statistical Analysis
        fprintf('==========================================\n');
        fprintf('STATISTICAL ANALYSIS (%dD)\n', dim);
        fprintf('==========================================\n');
        stats = statistical_analysis(results_matrix, algorithm_names);
        
        % Wilcoxon Test
        fprintf('\n==========================================\n');
        fprintf('STATISTICAL SIGNIFICANCE TESTING (%dD)\n', dim);
        fprintf('==========================================\n');
        wilcoxon_results = wilcoxon_test(results_matrix, algorithm_names, 1);
        
        % Generate Convergence Plots
        fprintf('\n==========================================\n');
        fprintf('GENERATING CONVERGENCE PLOTS (%dD)\n', dim);
        fprintf('==========================================\n');
        plot_convergence(convergence_matrix, algorithm_names, test_functions, true);
        
        % Plot individual convergence for selected functions
        selected_funcs = [1, 3, 5]; % Representative functions
        for func = selected_funcs
            if func <= length(test_functions)
                fprintf('Generating individual plot for F%d...\n', func);
                plot_single_convergence(convergence_matrix, algorithm_names, func);
            end
        end
        
        % Save comprehensive results
        save_comprehensive_results(results_matrix, convergence_matrix, stats, ...
                                  wilcoxon_results, algorithm_names, test_functions, dim);
    end
    
    % Generate final summary
    fprintf('\n==========================================\n');
    fprintf('EXPERIMENTAL SUMMARY\n');
    fprintf('==========================================\n');
    
    fprintf('✓ Algorithms implemented: %d\n', num_algorithms);
    fprintf('✓ CEC2017 functions tested: %d\n', length(test_functions));
    fprintf('✓ Dimensions evaluated: %s\n', mat2str(dimensions));
    fprintf('✓ Independent runs per test: %d\n', num_runs);
    fprintf('✓ Total function evaluations: %d\n', num_algorithms * length(test_functions) * num_runs * max_iter * pop_size);
    fprintf('✓ Statistical analysis completed\n');
    fprintf('✓ Significance testing completed\n');
    fprintf('✓ Convergence plots generated\n');
    
    fprintf('\nRESULTS LOCATION:\n');
    fprintf('- All results saved in: /home/runner/work/sdo/sdo/experiments/results/\n');
    fprintf('- Convergence plots: *.png, *.fig files\n');
    fprintf('- Statistical data: *.mat, *.csv files\n');
    fprintf('- Detailed reports: *_report.txt files\n');
    
    fprintf('\n==========================================\n');
    fprintf('DEMO COMPLETED SUCCESSFULLY!\n');
    fprintf('==========================================\n');
    
    fprintf('\nThe experimental framework is ready for:\n');
    fprintf('1. Full CEC2017 benchmark testing (F1-F30)\n');
    fprintf('2. Multiple dimension evaluation (30D, 50D, 100D)\n');
    fprintf('3. Extended independent runs (30 runs)\n');
    fprintf('4. Publication-quality result generation\n');
    fprintf('\nTo run full experiments, modify run_experiments.m parameters.\n');
end

function save_comprehensive_results(results_matrix, convergence_matrix, stats, ...
                                   wilcoxon_results, algorithm_names, test_functions, dim)
    % Save comprehensive experimental results with detailed reporting
    
    % Create results directory
    results_dir = '/home/runner/work/sdo/sdo/experiments/results';
    if ~exist(results_dir, 'dir')
        mkdir(results_dir);
    end
    
    % Save .mat file with all data
    filename = sprintf('%s/comprehensive_results_%dD.mat', results_dir, dim);
    save(filename, 'results_matrix', 'convergence_matrix', 'stats', 'wilcoxon_results', ...
         'algorithm_names', 'test_functions', 'dim');
    
    % Generate detailed report
    report_filename = sprintf('%s/detailed_report_%dD.txt', results_dir, dim);
    fid = fopen(report_filename, 'w');
    
    fprintf(fid, 'SDO EXPERIMENTAL FRAMEWORK - DETAILED REPORT\n');
    fprintf(fid, '=============================================\n\n');
    fprintf(fid, 'Dimension: %dD\n', dim);
    fprintf(fid, 'Functions tested: F%d-F%d\n', min(test_functions), max(test_functions));
    fprintf(fid, 'Algorithms: %s\n', strjoin(algorithm_names, ', '));
    fprintf(fid, 'Runs per test: %d\n\n', size(results_matrix{1}, 1));
    
    fprintf(fid, 'RANKING SUMMARY:\n');
    fprintf(fid, '================\n');
    [~, rank_order] = sort(stats.average_rankings);
    for i = 1:length(algorithm_names)
        alg_idx = rank_order(i);
        fprintf(fid, '%d. %s (Avg Rank: %.2f)\n', i, algorithm_names{alg_idx}, stats.average_rankings(alg_idx));
    end
    
    fprintf(fid, '\nDETAILED STATISTICS:\n');
    fprintf(fid, '===================\n');
    fprintf(fid, 'Function | Algorithm | Mean | Std | Best | Worst\n');
    fprintf(fid, '---------|-----------|------|-----|------|------\n');
    
    for f = 1:length(test_functions)
        func_num = test_functions(f);
        for alg = 1:length(algorithm_names)
            fprintf(fid, 'F%-7d | %-9s | %8.2e | %8.2e | %8.2e | %8.2e\n', ...
                    func_num, algorithm_names{alg}, stats.mean(alg, f), ...
                    stats.std(alg, f), stats.best(alg, f), stats.worst(alg, f));
        end
        fprintf(fid, '\n');
    end
    
    fclose(fid);
    
    % Save CSV files for easy analysis
    csv_filename = sprintf('%s/summary_stats_%dD.csv', results_dir, dim);
    fid = fopen(csv_filename, 'w');
    
    % Header
    fprintf(fid, 'Algorithm,Average_Rank');
    for f = 1:length(test_functions)
        fprintf(fid, ',F%d_Mean,F%d_Std', test_functions(f), test_functions(f));
    end
    fprintf(fid, '\n');
    
    % Data
    for alg = 1:length(algorithm_names)
        fprintf(fid, '%s,%.4f', algorithm_names{alg}, stats.average_rankings(alg));
        for f = 1:length(test_functions)
            fprintf(fid, ',%.6e,%.6e', stats.mean(alg, f), stats.std(alg, f));
        end
        fprintf(fid, '\n');
    end
    fclose(fid);
    
    fprintf('Comprehensive results saved:\n');
    fprintf('- MATLAB data: %s\n', filename);
    fprintf('- Detailed report: %s\n', report_filename);
    fprintf('- CSV summary: %s\n', csv_filename);
end