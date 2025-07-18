function [p, h] = simple_ranksum(x, y, alpha)
    % Simple implementation of Wilcoxon rank-sum test
    % Compatible with base Octave installation
    %
    % Inputs:
    %   x, y: Data samples
    %   alpha: Significance level (default 0.05)
    %
    % Outputs:
    %   p: p-value
    %   h: hypothesis test result (1 = reject null, 0 = fail to reject)
    
    if nargin < 3
        alpha = 0.05;
    end
    
    % Combine samples and compute ranks
    combined = [x(:); y(:)];
    n1 = length(x);
    n2 = length(y);
    n = n1 + n2;
    
    % Sort and rank
    [sorted_vals, sort_idx] = sort(combined);
    ranks = 1:n;
    
    % Handle ties by averaging ranks
    i = 1;
    while i <= n
        j = i;
        while j < n && sorted_vals(j+1) == sorted_vals(i)
            j = j + 1;
        end
        if j > i
            % Average rank for tied values
            avg_rank = mean(ranks(i:j));
            ranks(i:j) = avg_rank;
        end
        i = j + 1;
    end
    
    % Assign ranks back to original order
    all_ranks = zeros(n, 1);
    all_ranks(sort_idx) = ranks;
    
    % Calculate Wilcoxon rank-sum statistic
    R1 = sum(all_ranks(1:n1));  % Sum of ranks for first sample
    
    % Expected value and variance under null hypothesis
    mu_R1 = n1 * (n + 1) / 2;
    sigma2_R1 = n1 * n2 * (n + 1) / 12;
    
    % Standardized test statistic
    if sigma2_R1 > 0
        z = (R1 - mu_R1) / sqrt(sigma2_R1);
        
        % Two-tailed p-value (normal approximation)
        p = 2 * (1 - simple_normcdf(abs(z)));
    else
        p = 1;  % No variance, can't reject null
    end
    
    % Hypothesis test result
    h = p < alpha;
end

function y = simple_normcdf(x)
    % Simple approximation of normal cumulative distribution function
    % Using error function approximation
    y = 0.5 * (1 + erf(x / sqrt(2)));
end