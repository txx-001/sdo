function analyze_convergence(convergence_data, function_names, max_iter)
% Analyze and plot convergence characteristics of SDO algorithm
% Input:
%   convergence_data - cell array of convergence curves for different functions
%   function_names - cell array of function names
%   max_iter - maximum number of iterations

    iterations = 1:max_iter;
    num_functions = length(convergence_data);
    
    % Create convergence analysis figure
    figure('Position', [200, 200, 1400, 1000]);
    
    % Plot 1: Convergence curves comparison
    subplot(2, 2, 1);
    colors = lines(num_functions);
    for i = 1:num_functions
        semilogy(iterations, convergence_data{i}, 'Color', colors(i, :), 'LineWidth', 2);
        hold on;
    end
    xlabel('Iteration');
    ylabel('Best Fitness (log scale)');
    title('Convergence Curves Comparison');
    legend(function_names, 'Location', 'northeast');
    grid on;
    
    % Plot 2: Convergence rate analysis
    subplot(2, 2, 2);
    for i = 1:num_functions
        conv_data = convergence_data{i};
        % Calculate convergence rate as improvement per iteration
        conv_rate = abs(diff(log10(conv_data + 1e-10)));
        plot(2:max_iter, conv_rate, 'Color', colors(i, :), 'LineWidth', 2);
        hold on;
    end
    xlabel('Iteration');
    ylabel('Convergence Rate');
    title('Convergence Rate Analysis');
    legend(function_names, 'Location', 'northeast');
    grid on;
    
    % Plot 3: Final convergence comparison (bar chart)
    subplot(2, 2, 3);
    final_values = zeros(num_functions, 1);
    for i = 1:num_functions
        final_values(i) = convergence_data{i}(end);
    end
    bar(final_values, 'FaceColor', [0.2, 0.6, 0.8]);
    set(gca, 'XTickLabel', function_names);
    xtickangle(45);
    ylabel('Final Best Fitness');
    title('Final Convergence Values');
    grid on;
    
    % Plot 4: Convergence efficiency (normalized)
    subplot(2, 2, 4);
    for i = 1:num_functions
        conv_data = convergence_data{i};
        % Normalize convergence curve
        normalized_conv = (conv_data - min(conv_data)) / (max(conv_data) - min(conv_data) + 1e-10);
        plot(iterations, normalized_conv, 'Color', colors(i, :), 'LineWidth', 2);
        hold on;
    end
    xlabel('Iteration');
    ylabel('Normalized Fitness');
    title('Normalized Convergence Comparison');
    legend(function_names, 'Location', 'northeast');
    grid on;
    
    % sgtitle('SDO Convergence Analysis', 'FontSize', 16, 'FontWeight', 'bold'); % Not available in older versions
    
    % Print convergence statistics
    fprintf('\n=== Convergence Statistics ===\n');
    for i = 1:num_functions
        conv_data = convergence_data{i};
        initial_fitness = conv_data(1);
        final_fitness = conv_data(end);
        improvement = ((initial_fitness - final_fitness) / initial_fitness) * 100;
        
        % Find iteration where 90% of improvement was achieved
        target_fitness = initial_fitness - 0.9 * (initial_fitness - final_fitness);
        conv_90_iter = find(conv_data <= target_fitness, 1);
        if isempty(conv_90_iter)
            conv_90_iter = max_iter;
        end
        
        fprintf('%s:\n', function_names{i});
        fprintf('  Initial fitness: %.6e\n', initial_fitness);
        fprintf('  Final fitness: %.6e\n', final_fitness);
        fprintf('  Improvement: %.2f%%\n', improvement);
        fprintf('  90%% convergence at iteration: %d\n', conv_90_iter);
        fprintf('\n');
    end
end