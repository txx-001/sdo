function [best_pos, best_score, convergence] = SDO(search_agents, max_iter, lb, ub, dim, fobj)
    % SDO: Sled Dog Optimizer
    % Implementation based on "A novel sled dog-inspired optimizer for solving engineering problems"
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
    
    % Initialize the positions of search agents
    positions = lb + (ub - lb) * rand(search_agents, dim);
    
    % Initialize fitness
    fitness = zeros(search_agents, 1);
    for i = 1:search_agents
        fitness(i) = fobj(positions(i, :));
    end
    
    % Find the best solution
    [best_score, best_idx] = min(fitness);
    best_pos = positions(best_idx, :);
    
    % Initialize convergence curve
    convergence = zeros(max_iter, 1);
    convergence(1) = best_score;
    
    % Main optimization loop
    for iter = 2:max_iter
        % Update the position of search agents
        for i = 1:search_agents
            % Calculate leadership coefficient
            LC = 2 * rand() - 1;
            
            % Calculate direction coefficient  
            DC = 2 * rand() - 1;
            
            % Calculate velocity coefficient
            VC = 2 * (1 - iter/max_iter);
            
            % Random agent selection for social behavior
            r1 = randi(search_agents);
            while r1 == i
                r1 = randi(search_agents);
            end
            
            % Update position based on SDO equations
            for j = 1:dim
                if rand < 0.5
                    % Leadership behavior
                    positions(i, j) = best_pos(j) + LC * rand() * (best_pos(j) - positions(i, j));
                else
                    % Social behavior
                    positions(i, j) = positions(r1, j) + DC * rand() * (positions(r1, j) - positions(i, j));
                end
                
                % Apply velocity update
                positions(i, j) = positions(i, j) + VC * (2 * rand() - 1) * (ub - lb) * 0.1;
                
                % Boundary checking
                if positions(i, j) > ub
                    positions(i, j) = ub;
                elseif positions(i, j) < lb
                    positions(i, j) = lb;
                end
            end
            
            % Evaluate new position
            new_fitness = fobj(positions(i, :));
            
            % Update if better
            if new_fitness < fitness(i)
                fitness(i) = new_fitness;
                
                % Update global best
                if new_fitness < best_score
                    best_score = new_fitness;
                    best_pos = positions(i, :);
                end
            end
        end
        
        % Store convergence
        convergence(iter) = best_score;
    end
end