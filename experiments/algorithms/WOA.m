function [best_pos, best_score, convergence] = WOA(search_agents, max_iter, lb, ub, dim, fobj)
    % WOA: Whale Optimization Algorithm
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
        % Calculate a (linearly decreases from 2 to 0)
        a = 2 - 2 * iter / max_iter;
        a2 = -1 + iter * (-1) / max_iter;
        
        for i = 1:search_agents
            r1 = rand(); % Random number [0,1]
            r2 = rand(); % Random number [0,1]
            
            A = 2 * a * r1 - a;  % Equation (2.3)
            C = 2 * r2;          % Equation (2.4)
            
            b = 1;               % Parameter for spiral updating
            l = (a2 - 1) * rand() + 1;  % Random number [-1,1]
            
            p = rand();          % Random number [0,1]
            
            for j = 1:dim
                if p < 0.5
                    if abs(A) >= 1
                        % Search for prey (exploration)
                        rand_leader_index = floor(search_agents * rand()) + 1;
                        X_rand = positions(rand_leader_index, :);
                        D_X_rand = abs(C * X_rand(j) - positions(i, j));
                        positions(i, j) = X_rand(j) - A * D_X_rand;
                    elseif abs(A) < 1
                        % Encircling prey (exploitation)
                        D = abs(C * best_pos(j) - positions(i, j));
                        positions(i, j) = best_pos(j) - A * D;
                    end
                elseif p >= 0.5
                    % Spiral updating position
                    distance2Leader = abs(best_pos(j) - positions(i, j));
                    positions(i, j) = distance2Leader * exp(b .* l) .* cos(l .* 2 * pi) + best_pos(j);
                end
                
                % Boundary checking
                if positions(i, j) > ub
                    positions(i, j) = ub;
                elseif positions(i, j) < lb
                    positions(i, j) = lb;
                end
            end
            
            % Evaluate fitness
            fitness(i) = fobj(positions(i, :));
            
            % Update the best solution
            if fitness(i) < best_score
                best_score = fitness(i);
                best_pos = positions(i, :);
            end
        end
        
        % Store convergence
        convergence(iter) = best_score;
    end
end