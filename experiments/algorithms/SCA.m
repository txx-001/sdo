function [best_pos, best_score, convergence] = SCA(search_agents, max_iter, lb, ub, dim, fobj)
    % SCA: Sine Cosine Algorithm
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
        % Update the parameter a
        a = 2 - 2 * iter / max_iter;
        
        for i = 1:search_agents
            for j = 1:dim
                % Update r1, r2, r3, and r4 for Eq. (3.3)
                r1 = a * (2 * rand() - 1); % r1 is a random number in [-a, a]
                r2 = 2 * pi * rand();      % r2 is a random number in [0, 2π]
                r3 = rand();               % r3 is a random number in [0, 1] 
                r4 = rand();               % r4 is a random number in [0, 1]
                
                % Update the position of search agents
                if r4 < 0.5
                    % Sine component
                    positions(i, j) = positions(i, j) + r1 * sin(r2) * abs(r3 * best_pos(j) - positions(i, j));
                else
                    % Cosine component
                    positions(i, j) = positions(i, j) + r1 * cos(r2) * abs(r3 * best_pos(j) - positions(i, j));
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