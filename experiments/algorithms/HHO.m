function [best_pos, best_score, convergence] = HHO(search_agents, max_iter, lb, ub, dim, fobj)
    % HHO: Harris Hawks Optimization
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
    
    % Initialize the positions of Harris' hawks
    X = lb + (ub - lb) * rand(search_agents, dim);
    
    % Initialize fitness
    fitness = zeros(search_agents, 1);
    for i = 1:search_agents
        fitness(i) = fobj(X(i, :));
    end
    
    % Find the best solution (rabbit)
    [best_score, best_idx] = min(fitness);
    X_rabbit = X(best_idx, :);
    best_pos = X_rabbit;
    
    % Initialize convergence curve
    convergence = zeros(max_iter, 1);
    convergence(1) = best_score;
    
    % Main optimization loop
    for iter = 2:max_iter
        E0 = 2 * rand() - 1; % Initial energy of the rabbit
        E = 2 * E0 * (1 - iter / max_iter); % Energy of the rabbit
        
        for i = 1:search_agents
            r1 = rand(); r2 = rand(); r3 = rand(); r4 = rand();
            
            if abs(E) >= 1
                % Exploration phase
                if rand >= 0.5
                    % Perch randomly based on 2 positions
                    q = rand();
                    rand_Hawk_index = floor(search_agents * rand()) + 1;
                    X_rand = X(rand_Hawk_index, :);
                    if q < 0.5
                        X(i, :) = X_rand - r1 * abs(X_rand - 2 * r2 * X(i, :));
                    else
                        X(i, :) = (X_rabbit - mean(X)) - r3 * (lb + r4 * (ub - lb));
                    end
                else
                    % Perch on a random tall tree
                    X(i, :) = X_rabbit - r1 * abs(X_rabbit - 2 * r2 * X(i, :));
                end
            elseif abs(E) < 1
                % Exploitation phase
                r = rand();
                if r >= 0.5 && abs(E) >= 0.5
                    % Soft besiege
                    Delta_X = X_rabbit - X(i, :);
                    X(i, :) = Delta_X - E * abs(Delta_X);
                elseif r >= 0.5 && abs(E) < 0.5
                    % Hard besiege
                    X(i, :) = X_rabbit - E * abs(Delta_X);
                elseif r < 0.5 && abs(E) >= 0.5
                    % Soft besiege with progressive rapid dives
                    Delta_X = X_rabbit - X(i, :);
                    S = rand(1, dim) .* (lb + rand(1, dim) .* (ub - lb));
                    X(i, :) = S - E * abs(Delta_X);
                elseif r < 0.5 && abs(E) < 0.5
                    % Hard besiege with progressive rapid dives
                    Delta_X = X_rabbit - X(i, :);
                    S = rand(1, dim) .* (lb + rand(1, dim) .* (ub - lb));
                    X(i, :) = S - E * abs(Delta_X);
                end
            end
            
            % Boundary checking
            X(i, :) = max(X(i, :), lb);
            X(i, :) = min(X(i, :), ub);
            
            % Evaluate fitness
            fitness(i) = fobj(X(i, :));
            
            % Update the best solution
            if fitness(i) < best_score
                best_score = fitness(i);
                X_rabbit = X(i, :);
                best_pos = X_rabbit;
            end
        end
        
        % Store convergence
        convergence(iter) = best_score;
    end
end