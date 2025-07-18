function [best_pos, best_score, convergence] = PSO(search_agents, max_iter, lb, ub, dim, fobj)
    % PSO: Particle Swarm Optimization
    % 
    % Inputs:
    %   search_agents: Number of particles
    %   max_iter: Maximum number of iterations
    %   lb: Lower bound
    %   ub: Upper bound  
    %   dim: Dimension of the problem
    %   fobj: Function handle for objective function
    %
    % Outputs:
    %   best_pos: Best position found
    %   best_score: Best fitness value found
    %   convergence: Convergence curve
    
    % PSO parameters
    w_max = 0.9;  % Maximum inertia weight
    w_min = 0.4;  % Minimum inertia weight
    c1 = 2;       % Cognitive parameter
    c2 = 2;       % Social parameter
    
    % Initialize particles
    positions = lb + (ub - lb) * rand(search_agents, dim);
    velocities = zeros(search_agents, dim);
    
    % Initialize personal best positions and fitness
    personal_best_pos = positions;
    personal_best_fitness = zeros(search_agents, 1);
    
    for i = 1:search_agents
        personal_best_fitness(i) = fobj(positions(i, :));
    end
    
    % Find global best
    [best_score, best_idx] = min(personal_best_fitness);
    best_pos = personal_best_pos(best_idx, :);
    
    % Initialize convergence curve
    convergence = zeros(max_iter, 1);
    convergence(1) = best_score;
    
    % Main optimization loop
    for iter = 2:max_iter
        % Update inertia weight
        w = w_max - (w_max - w_min) * iter / max_iter;
        
        for i = 1:search_agents
            % Update velocity
            r1 = rand(1, dim);
            r2 = rand(1, dim);
            
            velocities(i, :) = w * velocities(i, :) + ...
                               c1 * r1 .* (personal_best_pos(i, :) - positions(i, :)) + ...
                               c2 * r2 .* (best_pos - positions(i, :));
            
            % Update position
            positions(i, :) = positions(i, :) + velocities(i, :);
            
            % Boundary checking
            positions(i, :) = max(positions(i, :), lb);
            positions(i, :) = min(positions(i, :), ub);
            
            % Evaluate fitness
            current_fitness = fobj(positions(i, :));
            
            % Update personal best
            if current_fitness < personal_best_fitness(i)
                personal_best_fitness(i) = current_fitness;
                personal_best_pos(i, :) = positions(i, :);
                
                % Update global best
                if current_fitness < best_score
                    best_score = current_fitness;
                    best_pos = positions(i, :);
                end
            end
        end
        
        % Store convergence
        convergence(iter) = best_score;
    end
end