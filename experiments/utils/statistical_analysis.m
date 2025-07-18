function results = statistical_analysis(data, algorithm_names)
    % Statistical analysis of optimization results
    % 
    % Inputs:
    %   data: Cell array containing results for each algorithm
    %         data{i} contains results for algorithm i (rows: runs, cols: functions)
    %   algorithm_names: Cell array of algorithm names
    %
    % Outputs:
    %   results: Structure containing statistical analysis results
    
    num_algorithms = length(data);
    num_functions = size(data{1}, 2);
    num_runs = size(data{1}, 1);
    
    % Initialize result arrays
    mean_values = zeros(num_algorithms, num_functions);
    std_values = zeros(num_algorithms, num_functions);
    best_values = zeros(num_algorithms, num_functions);
    worst_values = zeros(num_algorithms, num_functions);
    median_values = zeros(num_algorithms, num_functions);
    
    % Calculate statistics for each algorithm and function
    for alg = 1:num_algorithms
        for func = 1:num_functions
            values = data{alg}(:, func);
            mean_values(alg, func) = mean(values);
            std_values(alg, func) = std(values);
            best_values(alg, func) = min(values);
            worst_values(alg, func) = max(values);
            median_values(alg, func) = median(values);
        end
    end
    
    % Store results
    results.mean = mean_values;
    results.std = std_values;
    results.best = best_values;
    results.worst = worst_values;
    results.median = median_values;
    results.algorithm_names = algorithm_names;
    results.num_functions = num_functions;
    results.num_runs = num_runs;
    
    % Calculate rankings based on mean values
    rankings = zeros(num_algorithms, num_functions);
    for func = 1:num_functions
        [~, rank_idx] = sort(mean_values(:, func));
        rankings(rank_idx, func) = 1:num_algorithms;
    end
    results.rankings = rankings;
    
    % Calculate average ranking for each algorithm
    avg_rankings = mean(rankings, 2);
    results.average_rankings = avg_rankings;
    
    % Print summary table
    fprintf('\n=== STATISTICAL ANALYSIS SUMMARY ===\n');
    fprintf('Number of functions: %d\n', num_functions);
    fprintf('Number of runs per function: %d\n', num_runs);
    fprintf('Number of algorithms: %d\n', num_algorithms);
    
    fprintf('\n=== AVERAGE RANKINGS ===\n');
    fprintf('%-10s | %-15s\n', 'Algorithm', 'Average Rank');
    fprintf('%-10s-+-%-15s\n', repmat('-', 1, 10), repmat('-', 1, 15));
    
    [~, sort_idx] = sort(avg_rankings);
    for i = 1:num_algorithms
        alg_idx = sort_idx(i);
        fprintf('%-10s | %-15.2f\n', algorithm_names{alg_idx}, avg_rankings(alg_idx));
    end
    
    % Print detailed statistics table
    fprintf('\n=== DETAILED STATISTICS (MEAN ± STD) ===\n');
    fprintf('%-8s', 'Function');
    for alg = 1:num_algorithms
        fprintf(' | %-20s', algorithm_names{alg});
    end
    fprintf('\n');
    
    % Print separator
    fprintf('%-8s', repmat('-', 1, 8));
    for alg = 1:num_algorithms
        fprintf('-+-%-20s', repmat('-', 1, 20));
    end
    fprintf('\n');
    
    for func = 1:min(10, num_functions)  % Show first 10 functions to avoid cluttering
        fprintf('F%-7d', func);
        for alg = 1:num_algorithms
            if mean_values(alg, func) < 1e-10
                fprintf(' | %8.2e±%8.2e', mean_values(alg, func), std_values(alg, func));
            elseif mean_values(alg, func) < 1e-3
                fprintf(' | %8.6f±%8.6f', mean_values(alg, func), std_values(alg, func));
            else
                fprintf(' | %8.2f±%8.2f', mean_values(alg, func), std_values(alg, func));
            end
        end
        fprintf('\n');
    end
    
    if num_functions > 10
        fprintf('... (showing first 10 functions only)\n');
    end
end