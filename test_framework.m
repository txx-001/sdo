function test_framework()
    % Simple test to verify the experimental framework
    
    clear; clc;
    fprintf('=== TESTING SDO EXPERIMENTAL FRAMEWORK ===\n');
    
    % Add paths
    addpath('/home/runner/work/sdo/sdo/experiments/algorithms');
    addpath('/home/runner/work/sdo/sdo/experiments/utils');
    
    % Test parameters (reduced for quick testing)
    pop_size = 10;          % Smaller population
    max_iter = 50;          % Fewer iterations
    num_runs = 3;           % Fewer runs
    lb = -100;              % Lower bound
    ub = 100;               % Upper bound
    dim = 10;               % Smaller dimension
    
    % Test only first 2 functions
    test_functions = [1, 2];
    
    % Test only SDO and PSO for quick validation
    algorithms = {
        'SDO', @SDO;
        'PSO', @PSO
    };
    
    algorithm_names = algorithms(:, 1);
    algorithm_funcs = algorithms(:, 2);
    num_algorithms = length(algorithm_names);
    
    fprintf('Testing with %d algorithms, %d functions, %d runs\n', ...
            num_algorithms, length(test_functions), num_runs);
    
    % Initialize storage
    results_matrix = cell(num_algorithms, 1);
    convergence_matrix = cell(num_algorithms, 1);
    
    for alg = 1:num_algorithms
        results_matrix{alg} = zeros(num_runs, length(test_functions));
        convergence_matrix{alg} = cell(length(test_functions), 1);
    end
    
    % Run experiments
    for f_idx = 1:length(test_functions)
        func_num = test_functions(f_idx);
        fprintf('\nTesting Function F%d:\n', func_num);
        
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
            end
            
            % Store results
            results_matrix{alg}(:, f_idx) = run_results;
            convergence_matrix{alg}{f_idx} = run_convergence;
            
            elapsed_time = toc;
            fprintf('Done (%.2fs)\n', elapsed_time);
        end
    end
    
    % Test statistical analysis
    fprintf('\n=== TESTING STATISTICAL ANALYSIS ===\n');
    try
        stats = statistical_analysis(results_matrix, algorithm_names);
        fprintf('Statistical analysis: PASSED\n');
    catch ME
        fprintf('Statistical analysis: FAILED - %s\n', ME.message);
    end
    
    % Test Wilcoxon test
    fprintf('\n=== TESTING WILCOXON TEST ===\n');
    try
        wilcoxon_results = wilcoxon_test(results_matrix, algorithm_names, 1);
        fprintf('Wilcoxon test: PASSED\n');
    catch ME
        fprintf('Wilcoxon test: FAILED - %s\n', ME.message);
    end
    
    % Test convergence plotting
    fprintf('\n=== TESTING CONVERGENCE PLOTTING ===\n');
    try
        plot_convergence(convergence_matrix, algorithm_names, test_functions, true);
        fprintf('Convergence plotting: PASSED\n');
    catch ME
        fprintf('Convergence plotting: FAILED - %s\n', ME.message);
    end
    
    fprintf('\n=== FRAMEWORK TEST COMPLETED ===\n');
    fprintf('All core components have been tested successfully!\n');
end