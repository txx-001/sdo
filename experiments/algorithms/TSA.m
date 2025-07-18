function [best_pos, best_score, convergence] = TSA(search_agents, max_iter, lb, ub, dim, fobj)
    % TSA: Tunicate Swarm Algorithm
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
    
    % Initialize the positions of tunicates
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
        c1 = rand();
        c2 = rand();
        c3 = rand();
        
        if c1 > 0.8
            pNum = 2;
        elseif c1 > 0.6
            pNum = 6;
        elseif c1 > 0.4
            pNum = 12;
        elseif c1 > 0.2
            pNum = 20;
        else
            pNum = search_agents;
        end
        
        if pNum < search_agents
            [~, sorted_idx] = sort(fitness);
            for i = 1:pNum
                if c2 > 0.1
                    positions(sorted_idx(i), :) = positions(sorted_idx(i), :) + c3 * (best_pos - positions(sorted_idx(i), :));
                else
                    positions(sorted_idx(i), :) = positions(sorted_idx(i), :) + (ub - lb) .* rand(1, dim) + lb;
                end
            end
        else
            for i = 1:search_agents
                distance = sqrt(sum((positions(i, :) - best_pos).^2));
                
                if i <= search_agents / 4
                    Svf = rand() * distance;
                    if c2 > 0.1
                        positions(i, :) = positions(i, :) + Svf .* (positions(1, :) - positions(i, :)) + Svf .* (positions(2, :) - positions(i, :));
                    else
                        positions(i, :) = positions(i, :) + (ub - lb) .* rand(1, dim) + lb;
                    end
                elseif i <= search_agents / 2
                    Svf = rand() * distance;
                    if c3 > 0.1
                        positions(i, :) = positions(i, :) + Svf .* (positions(i-1, :) - positions(i, :)) + Svf .* (positions(i+1, :) - positions(i, :));
                    else
                        positions(i, :) = positions(i, :) + (ub - lb) .* rand(1, dim) + lb;
                    end
                else
                    Svf = rand() * distance;
                    if c3 > 0.1
                        positions(i, :) = positions(i, :) + Svf .* (best_pos - positions(i, :));
                    else
                        positions(i, :) = positions(i, :) + (ub - lb) .* rand(1, dim) + lb;
                    end
                end
            end
        end
        
        % Boundary checking
        for i = 1:search_agents
            positions(i, :) = max(positions(i, :), lb);
            positions(i, :) = min(positions(i, :), ub);
            
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