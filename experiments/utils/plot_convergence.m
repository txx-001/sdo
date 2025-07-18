function plot_convergence(convergence_data, algorithm_names, function_numbers, save_plots)
    % Plot convergence curves for different algorithms and functions
    % 
    % Inputs:
    %   convergence_data: Cell array containing convergence data
    %                     convergence_data{alg}{func} = matrix (runs x iterations)
    %   algorithm_names: Cell array of algorithm names
    %   function_numbers: Array of function numbers to plot
    %   save_plots: Boolean, whether to save plots to files
    
    if nargin < 4
        save_plots = true;
    end
    
    num_algorithms = length(algorithm_names);
    num_functions = length(function_numbers);
    
    % Define colors for algorithms
    colors = {
        [1, 0, 0],      % Red - SDO
        [0, 0, 1],      % Blue - PSO
        [0, 0.5, 0],    % Green - GWO
        [1, 0.5, 0],    % Orange - WOA
        [0.5, 0, 0.5],  % Purple - SCA
        [0, 0.5, 0.5],  % Teal - SSA
        [0.5, 0.5, 0],  % Olive - HHO
        [1, 0, 1]       % Magenta - TSA
    };
    
    % Line styles
    line_styles = {'-', '--', '-.', ':', '-', '--', '-.', ':'};
    
    % Create figure for convergence plots
    figure('Position', [100, 100, 1200, 800]);
    
    % Determine subplot layout
    if num_functions <= 4
        rows = 2; cols = 2;
    elseif num_functions <= 6
        rows = 2; cols = 3;
    elseif num_functions <= 9
        rows = 3; cols = 3;
    else
        rows = 4; cols = 3;
    end
    
    for f = 1:min(num_functions, 12)  % Limit to 12 subplots
        subplot(rows, cols, f);
        hold on;
        
        func_num = function_numbers(f);
        legends = {};
        
        for alg = 1:num_algorithms
            if ~isempty(convergence_data{alg}{func_num})
                % Calculate mean convergence curve
                conv_matrix = convergence_data{alg}{func_num};
                mean_conv = mean(conv_matrix, 1);
                
                % Plot convergence curve
                color_idx = mod(alg - 1, length(colors)) + 1;
                style_idx = mod(alg - 1, length(line_styles)) + 1;
                
                plot(1:length(mean_conv), mean_conv, ...
                     'Color', colors{color_idx}, ...
                     'LineStyle', line_styles{style_idx}, ...
                     'LineWidth', 1.5);
                
                legends{end+1} = algorithm_names{alg};
            end
        end
        
        % Formatting
        title(sprintf('F%d Convergence', func_num), 'FontSize', 12, 'FontWeight', 'bold');
        xlabel('Iteration', 'FontSize', 10);
        ylabel('Best Fitness', 'FontSize', 10);
        set(gca, 'YScale', 'log');
        grid on;
        legend(legends, 'Location', 'best', 'FontSize', 8);
        
        % Set axis limits
        xlim([1, size(convergence_data{1}{func_num}, 2)]);
    end
    
    % Overall title
    % sgtitle('Convergence Curves Comparison', 'FontSize', 16, 'FontWeight', 'bold');
    % Note: sgtitle not available in standard Octave, using text instead
    annotation('textbox', [0.35, 0.95, 0.3, 0.05], 'String', 'Convergence Curves Comparison', ...
               'FontSize', 16, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', ...
               'EdgeColor', 'none');
    
    % Save plot if requested
    if save_plots
        % Create results directory if it doesn't exist
        if ~exist('/home/runner/work/sdo/sdo/experiments/results', 'dir')
            mkdir('/home/runner/work/sdo/sdo/experiments/results');
        end
        
        % Save as high-resolution image
        print('/home/runner/work/sdo/sdo/experiments/results/convergence_curves.png', '-dpng', '-r300');
        savefig('/home/runner/work/sdo/sdo/experiments/results/convergence_curves.fig');
        
        fprintf('Convergence plots saved to: /home/runner/work/sdo/sdo/experiments/results/\n');
    end
end

function plot_single_convergence(convergence_data, algorithm_names, func_num)
    % Plot convergence curves for a single function with all algorithms
    % 
    % Inputs:
    %   convergence_data: Cell array containing convergence data
    %   algorithm_names: Cell array of algorithm names  
    %   func_num: Function number to plot
    
    figure('Position', [100, 100, 800, 600]);
    hold on;
    
    % Define colors and styles
    colors = {
        [1, 0, 0],      % Red - SDO
        [0, 0, 1],      % Blue - PSO
        [0, 0.5, 0],    % Green - GWO
        [1, 0.5, 0],    % Orange - WOA
        [0.5, 0, 0.5],  % Purple - SCA
        [0, 0.5, 0.5],  % Teal - SSA
        [0.5, 0.5, 0],  % Olive - HHO
        [1, 0, 1]       % Magenta - TSA
    };
    
    line_styles = {'-', '--', '-.', ':', '-', '--', '-.', ':'};
    
    legends = {};
    num_algorithms = length(algorithm_names);
    
    for alg = 1:num_algorithms
        if ~isempty(convergence_data{alg}{func_num})
            % Calculate mean convergence curve
            conv_matrix = convergence_data{alg}{func_num};
            mean_conv = mean(conv_matrix, 1);
            
            % Plot convergence curve
            color_idx = mod(alg - 1, length(colors)) + 1;
            style_idx = mod(alg - 1, length(line_styles)) + 1;
            
            plot(1:length(mean_conv), mean_conv, ...
                 'Color', colors{color_idx}, ...
                 'LineStyle', line_styles{style_idx}, ...
                 'LineWidth', 2);
            
            legends{end+1} = algorithm_names{alg};
        end
    end
    
    % Formatting
    title(sprintf('Convergence Curves for Function F%d', func_num), ...
          'FontSize', 14, 'FontWeight', 'bold');
    xlabel('Iteration', 'FontSize', 12);
    ylabel('Best Fitness Value', 'FontSize', 12);
    set(gca, 'YScale', 'log');
    grid on;
    legend(legends, 'Location', 'best', 'FontSize', 11);
    
    % Set axis limits
    xlim([1, size(convergence_data{1}{func_num}, 2)]);
    
    % Save plot
    if ~exist('/home/runner/work/sdo/sdo/experiments/results', 'dir')
        mkdir('/home/runner/work/sdo/sdo/experiments/results');
    end
    
    filename = sprintf('/home/runner/work/sdo/sdo/experiments/results/convergence_F%d.png', func_num);
    print(filename, '-dpng', '-r300');
    
    fprintf('Single convergence plot saved: %s\n', filename);
end