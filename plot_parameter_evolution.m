function plot_parameter_evolution(tracking_data, max_iter)
% Plot the evolution of SDO parameters over iterations
% Input:
%   tracking_data - structure containing parameter evolution data
%   max_iter - maximum number of iterations

    iterations = 1:max_iter;
    
    % Create subplot for parameter evolution
    figure('Position', [100, 100, 1200, 800]);
    
    % Plot y parameter evolution
    subplot(2, 3, 1);
    plot(iterations, tracking_data.y_values, 'b-', 'LineWidth', 2);
    xlabel('Iteration');
    ylabel('y value');
    title('Evolution of Control Parameter y');
    grid on;
    
    % Plot c1 and c2 parameters
    subplot(2, 3, 2);
    plot(iterations, tracking_data.c1_values, 'r-', 'LineWidth', 2); hold on;
    plot(iterations, tracking_data.c2_values, 'g-', 'LineWidth', 2);
    xlabel('Iteration');
    ylabel('Parameter value');
    title('Cognitive (c1) and Social (c2) Parameters');
    legend('c1', 'c2', 'Location', 'northeast');
    grid on;
    
    % Plot w1 parameter evolution
    subplot(2, 3, 3);
    plot(iterations, tracking_data.w1_values, 'm-', 'LineWidth', 2);
    xlabel('Iteration');
    ylabel('w1 value');
    title('Evolution of Inertia Weight w1');
    grid on;
    
    % Plot p1 parameter evolution
    subplot(2, 3, 4);
    plot(iterations, tracking_data.p1_values, 'c-', 'LineWidth', 2);
    xlabel('Iteration');
    ylabel('p1 value');
    title('Evolution of Probability Parameter p1');
    grid on;
    
    % Plot CF parameter evolution
    subplot(2, 3, 5);
    plot(iterations, tracking_data.CF_values, 'k-', 'LineWidth', 2);
    xlabel('Iteration');
    ylabel('CF value');
    title('Evolution of Control Factor CF');
    grid on;
    
    % Plot population diversity
    subplot(2, 3, 6);
    plot(iterations, tracking_data.population_diversity, 'Color', [0.8, 0.4, 0], 'LineWidth', 2);
    xlabel('Iteration');
    ylabel('Diversity');
    title('Population Diversity Evolution');
    grid on;
    
    % sgtitle('SDO Parameter Evolution Analysis', 'FontSize', 16, 'FontWeight', 'bold'); % Not available in older versions
end