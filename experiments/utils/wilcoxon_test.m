function wilcoxon_results = wilcoxon_test(data, algorithm_names, reference_algorithm)
    % Perform Wilcoxon rank-sum test for statistical significance
    % 
    % Inputs:
    %   data: Cell array containing results for each algorithm
    %         data{i} contains results for algorithm i (rows: runs, cols: functions)
    %   algorithm_names: Cell array of algorithm names
    %   reference_algorithm: Index of reference algorithm (usually the proposed method)
    %
    % Outputs:
    %   wilcoxon_results: Structure containing test results
    
    if nargin < 3
        reference_algorithm = 1; % Default to first algorithm (SDO)
    end
    
    num_algorithms = length(data);
    num_functions = size(data{1}, 2);
    
    % Initialize result arrays
    p_values = zeros(num_algorithms, num_functions);
    h_values = zeros(num_algorithms, num_functions); % Hypothesis test results
    win_tie_loss = zeros(num_algorithms, 3); % [wins, ties, losses] for each algorithm
    
    fprintf('\n=== WILCOXON RANK-SUM TEST RESULTS ===\n');
    fprintf('Reference Algorithm: %s\n', algorithm_names{reference_algorithm});
    fprintf('Significance level: α = 0.05\n\n');
    
    % Perform pairwise tests
    for alg = 1:num_algorithms
        if alg == reference_algorithm
            continue; % Skip comparison with itself
        end
        
        fprintf('Comparing %s vs %s:\n', algorithm_names{reference_algorithm}, algorithm_names{alg});
        fprintf('%-8s | %-10s | %-6s | %-10s\n', 'Function', 'p-value', 'Result', 'Outcome');
        fprintf('%-8s-+-%-10s-+-%-6s-+-%-10s\n', repmat('-', 1, 8), repmat('-', 1, 10), ...
                repmat('-', 1, 6), repmat('-', 1, 10));
        
        for func = 1:num_functions
            % Get data for both algorithms
            data_ref = data{reference_algorithm}(:, func);
            data_comp = data{alg}(:, func);
            
            % Perform Wilcoxon rank-sum test
            [p, h] = ranksum(data_ref, data_comp, 'alpha', 0.05);
            
            p_values(alg, func) = p;
            h_values(alg, func) = h;
            
            % Determine outcome
            if h == 0
                outcome = 'Tie';
                win_tie_loss(alg, 2) = win_tie_loss(alg, 2) + 1;
                result_symbol = '=';
            else
                if mean(data_ref) < mean(data_comp)
                    outcome = 'Win';
                    win_tie_loss(alg, 1) = win_tie_loss(alg, 1) + 1;
                    result_symbol = '+';
                else
                    outcome = 'Loss';
                    win_tie_loss(alg, 3) = win_tie_loss(alg, 3) + 1;
                    result_symbol = '-';
                end
            end
            
            fprintf('F%-7d | %-10.4e | %-6s | %-10s\n', func, p, result_symbol, outcome);
        end
        
        fprintf('\nSummary for %s:\n', algorithm_names{alg});
        fprintf('Wins: %d, Ties: %d, Losses: %d\n', ...
                win_tie_loss(alg, 1), win_tie_loss(alg, 2), win_tie_loss(alg, 3));
        fprintf('Win Rate: %.2f%%\n\n', win_tie_loss(alg, 1) / num_functions * 100);
    end
    
    % Overall summary
    fprintf('=== OVERALL COMPARISON SUMMARY ===\n');
    fprintf('%-15s | %-5s | %-5s | %-6s | %-8s\n', 'Algorithm', 'Wins', 'Ties', 'Losses', 'Win Rate');
    fprintf('%-15s-+-%-5s-+-%-5s-+-%-6s-+-%-8s\n', repmat('-', 1, 15), repmat('-', 1, 5), ...
            repmat('-', 1, 5), repmat('-', 1, 6), repmat('-', 1, 8));
    
    for alg = 1:num_algorithms
        if alg == reference_algorithm
            continue;
        end
        win_rate = win_tie_loss(alg, 1) / num_functions * 100;
        fprintf('%-15s | %-5d | %-5d | %-6d | %-7.2f%%\n', ...
                algorithm_names{alg}, win_tie_loss(alg, 1), win_tie_loss(alg, 2), ...
                win_tie_loss(alg, 3), win_rate);
    end
    
    % Store results
    wilcoxon_results.p_values = p_values;
    wilcoxon_results.h_values = h_values;
    wilcoxon_results.win_tie_loss = win_tie_loss;
    wilcoxon_results.algorithm_names = algorithm_names;
    wilcoxon_results.reference_algorithm = reference_algorithm;
    wilcoxon_results.num_functions = num_functions;
    
    % Create significance matrix table
    fprintf('\n=== SIGNIFICANCE MATRIX (p-values) ===\n');
    fprintf('Note: Values < 0.05 indicate significant difference\n\n');
    
    fprintf('%-8s', 'Function');
    for alg = 1:num_algorithms
        if alg ~= reference_algorithm
            fprintf(' | %-12s', algorithm_names{alg});
        end
    end
    fprintf('\n');
    
    % Print separator
    fprintf('%-8s', repmat('-', 1, 8));
    for alg = 1:num_algorithms
        if alg ~= reference_algorithm
            fprintf('-+-%-12s', repmat('-', 1, 12));
        end
    end
    fprintf('\n');
    
    for func = 1:min(10, num_functions)  % Show first 10 functions
        fprintf('F%-7d', func);
        for alg = 1:num_algorithms
            if alg ~= reference_algorithm
                if p_values(alg, func) < 0.001
                    fprintf(' | %8.2e', p_values(alg, func));
                else
                    fprintf(' | %12.4f', p_values(alg, func));
                end
            end
        end
        fprintf('\n');
    end
    
    if num_functions > 10
        fprintf('... (showing first 10 functions only)\n');
    end
end