function [best_position, best_fitness, convergence_curve, tracking_data] = SDO_enhanced(pop_size, max_iter, lb, ub, dim, fitness_func)
% Enhanced Sled Dog-inspired Optimizer (SDO) with detailed parameter tracking
% Input:
%   pop_size - population size
%   max_iter - maximum number of iterations
%   lb, ub - lower and upper bounds
%   dim - problem dimension
%   fitness_func - fitness function handle
% Output:
%   best_position - best solution found
%   best_fitness - best fitness value
%   convergence_curve - fitness values over iterations
%   tracking_data - structure containing parameter evolution and statistics

    % Initialize population
    population = lb + (ub - lb) * rand(pop_size, dim);
    fitness = zeros(pop_size, 1);
    
    % Evaluate initial population
    for i = 1:pop_size
        fitness(i) = fitness_func(population(i, :));
    end
    
    % Find the best solution
    [best_fitness, best_idx] = min(fitness);
    best_position = population(best_idx, :);
    
    % Initialize tracking data structure
    tracking_data = struct();
    tracking_data.y_values = zeros(max_iter, 1);
    tracking_data.c1_values = zeros(max_iter, 1);
    tracking_data.c2_values = zeros(max_iter, 1);
    tracking_data.w1_values = zeros(max_iter, 1);
    tracking_data.p1_values = zeros(max_iter, 1);
    tracking_data.CF_values = zeros(max_iter, 1);
    tracking_data.population_diversity = zeros(max_iter, 1);
    tracking_data.mean_fitness = zeros(max_iter, 1);
    tracking_data.std_fitness = zeros(max_iter, 1);
    tracking_data.best_fitness_history = zeros(max_iter, 1);
    tracking_data.population_spread = zeros(max_iter, 1);
    
    % Initialize convergence curve
    convergence_curve = zeros(max_iter, 1);
    convergence_curve(1) = best_fitness;
    
    % SDO parameters
    y = 2; % control parameter
    c1 = 2; % cognitive parameter
    c2 = 2; % social parameter
    w1 = 0.9; % inertia weight
    p1 = 0.5; % probability parameter
    
    % Track initial parameters
    tracking_data.y_values(1) = y;
    tracking_data.c1_values(1) = c1;
    tracking_data.c2_values(1) = c2;
    tracking_data.w1_values(1) = w1;
    tracking_data.p1_values(1) = p1;
    tracking_data.CF_values(1) = 2;
    tracking_data.population_diversity(1) = calculate_diversity(population);
    tracking_data.mean_fitness(1) = mean(fitness);
    tracking_data.std_fitness(1) = std(fitness);
    tracking_data.best_fitness_history(1) = best_fitness;
    tracking_data.population_spread(1) = calculate_spread(population);
    
    % Main optimization loop
    for iter = 2:max_iter
        % Update control factor
        CF = 2 * (1 - iter / max_iter); % Linearly decreasing from 2 to 0
        
        % Update population
        for i = 1:pop_size
            % Random selection of other solutions
            r1 = randi(pop_size);
            while r1 == i
                r1 = randi(pop_size);
            end
            
            r2 = randi(pop_size);
            while r2 == i || r2 == r1
                r2 = randi(pop_size);
            end
            
            % Update position based on SDO equations
            if rand < p1
                % Exploration phase (following the leader)
                new_position = population(i, :) + c1 * rand(1, dim) .* (best_position - population(i, :)) + ...
                              c2 * rand(1, dim) .* (population(r1, :) - population(i, :));
            else
                % Exploitation phase (local search)
                new_position = w1 * population(i, :) + CF * rand(1, dim) .* (population(r1, :) - population(r2, :));
            end
            
            % Apply y parameter for position adjustment
            new_position = new_position + y * sin(2 * pi * rand(1, dim)) .* (best_position - population(i, :));
            
            % Boundary control
            new_position = max(new_position, lb);
            new_position = min(new_position, ub);
            
            % Evaluate new position
            new_fitness = fitness_func(new_position);
            
            % Update if better
            if new_fitness < fitness(i)
                population(i, :) = new_position;
                fitness(i) = new_fitness;
                
                % Update global best
                if new_fitness < best_fitness
                    best_fitness = new_fitness;
                    best_position = new_position;
                end
            end
        end
        
        % Update parameters
        y = y * (1 - iter / max_iter); % Decrease y over time
        w1 = w1 * 0.99; % Decrease inertia weight
        p1 = 0.5 + 0.3 * sin(pi * iter / max_iter); % Dynamic probability
        
        % Store convergence and tracking data
        convergence_curve(iter) = best_fitness;
        tracking_data.y_values(iter) = y;
        tracking_data.c1_values(iter) = c1;
        tracking_data.c2_values(iter) = c2;
        tracking_data.w1_values(iter) = w1;
        tracking_data.p1_values(iter) = p1;
        tracking_data.CF_values(iter) = CF;
        tracking_data.population_diversity(iter) = calculate_diversity(population);
        tracking_data.mean_fitness(iter) = mean(fitness);
        tracking_data.std_fitness(iter) = std(fitness);
        tracking_data.best_fitness_history(iter) = best_fitness;
        tracking_data.population_spread(iter) = calculate_spread(population);
    end
end

function diversity = calculate_diversity(population)
    % Calculate population diversity as average pairwise distance
    [pop_size, dim] = size(population);
    total_distance = 0;
    count = 0;
    
    for i = 1:pop_size
        for j = i+1:pop_size
            total_distance = total_distance + norm(population(i, :) - population(j, :));
            count = count + 1;
        end
    end
    
    if count > 0
        diversity = total_distance / count;
    else
        diversity = 0;
    end
end

function spread = calculate_spread(population)
    % Calculate population spread as standard deviation of positions
    spread = mean(std(population, 0, 1));
end