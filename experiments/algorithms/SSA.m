function [best_pos, best_score, convergence] = SSA(search_agents, max_iter, lb, ub, dim, fobj)
    % SSA: Salp Swarm Algorithm
    % 
    % Inputs:
    %   search_agents: Number of search agents
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
    
    % Initialize the positions of salps
    salp_pos = lb + (ub - lb) * rand(search_agents, dim);
    
    % Initialize food position (best solution)
    food_pos = zeros(1, dim);
    food_fitness = inf;
    
    % Initialize fitness
    fitness = zeros(search_agents, 1);
    for i = 1:search_agents
        fitness(i) = fobj(salp_pos(i, :));
        if fitness(i) < food_fitness
            food_fitness = fitness(i);
            food_pos = salp_pos(i, :);
        end
    end
    
    best_pos = food_pos;
    best_score = food_fitness;
    
    % Initialize convergence curve
    convergence = zeros(max_iter, 1);
    convergence(1) = best_score;
    
    % Main optimization loop
    for iter = 2:max_iter
        % Calculate coefficient c1
        c1 = 2 * exp(-(4 * iter / max_iter)^2);
        
        for i = 1:search_agents
            if i <= search_agents / 2  % First half are leaders
                for j = 1:dim
                    c2 = rand();
                    c3 = rand();
                    
                    if c3 < 0.5
                        salp_pos(i, j) = food_pos(j) + c1 * ((ub - lb) * c2 + lb);
                    else
                        salp_pos(i, j) = food_pos(j) - c1 * ((ub - lb) * c2 + lb);
                    end
                    
                    % Boundary checking
                    if salp_pos(i, j) > ub
                        salp_pos(i, j) = ub;
                    elseif salp_pos(i, j) < lb
                        salp_pos(i, j) = lb;
                    end
                end
            else  % Second half are followers
                for j = 1:dim
                    salp_pos(i, j) = (salp_pos(i, j) + salp_pos(i-1, j)) / 2;
                    
                    % Boundary checking
                    if salp_pos(i, j) > ub
                        salp_pos(i, j) = ub;
                    elseif salp_pos(i, j) < lb
                        salp_pos(i, j) = lb;
                    end
                end
            end
            
            % Evaluate fitness
            fitness(i) = fobj(salp_pos(i, :));
            
            % Update food position
            if fitness(i) < food_fitness
                food_fitness = fitness(i);
                food_pos = salp_pos(i, :);
                best_pos = food_pos;
                best_score = food_fitness;
            end
        end
        
        % Store convergence
        convergence(iter) = best_score;
    end
end