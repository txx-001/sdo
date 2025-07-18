function [best_pos, best_score, convergence] = GWO(search_agents, max_iter, lb, ub, dim, fobj)
    % GWO: Grey Wolf Optimizer
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
    
    % Find the best three solutions (Alpha, Beta, Delta)
    [sorted_fitness, sorted_idx] = sort(fitness);
    alpha_pos = positions(sorted_idx(1), :);
    alpha_score = sorted_fitness(1);
    beta_pos = positions(sorted_idx(2), :);
    delta_pos = positions(sorted_idx(3), :);
    
    best_pos = alpha_pos;
    best_score = alpha_score;
    
    % Initialize convergence curve
    convergence = zeros(max_iter, 1);
    convergence(1) = best_score;
    
    % Main optimization loop
    for iter = 2:max_iter
        % Calculate a (linearly decreases from 2 to 0)
        a = 2 - 2 * iter / max_iter;
        
        for i = 1:search_agents
            for j = 1:dim
                % Update the position of search agents with respect to alpha
                r1 = rand(); r2 = rand();
                A1 = 2 * a * r1 - a;
                C1 = 2 * r2;
                D_alpha = abs(C1 * alpha_pos(j) - positions(i, j));
                X1 = alpha_pos(j) - A1 * D_alpha;
                
                % Update the position of search agents with respect to beta
                r1 = rand(); r2 = rand();
                A2 = 2 * a * r1 - a;
                C2 = 2 * r2;
                D_beta = abs(C2 * beta_pos(j) - positions(i, j));
                X2 = beta_pos(j) - A2 * D_beta;
                
                % Update the position of search agents with respect to delta
                r1 = rand(); r2 = rand();
                A3 = 2 * a * r1 - a;
                C3 = 2 * r2;
                D_delta = abs(C3 * delta_pos(j) - positions(i, j));
                X3 = delta_pos(j) - A3 * D_delta;
                
                % Update position
                positions(i, j) = (X1 + X2 + X3) / 3;
                
                % Boundary checking
                if positions(i, j) > ub
                    positions(i, j) = ub;
                elseif positions(i, j) < lb
                    positions(i, j) = lb;
                end
            end
            
            % Evaluate fitness
            fitness(i) = fobj(positions(i, :));
        end
        
        % Update Alpha, Beta, and Delta
        [sorted_fitness, sorted_idx] = sort(fitness);
        if sorted_fitness(1) < alpha_score
            alpha_score = sorted_fitness(1);
            alpha_pos = positions(sorted_idx(1), :);
            best_pos = alpha_pos;
            best_score = alpha_score;
        end
        beta_pos = positions(sorted_idx(2), :);
        delta_pos = positions(sorted_idx(3), :);
        
        % Store convergence
        convergence(iter) = best_score;
    end
end