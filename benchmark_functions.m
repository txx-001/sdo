function [fitness, lb, ub] = benchmark_functions(x, func_num)
% Benchmark test functions for SDO algorithm evaluation
% Input:
%   x - solution vector
%   func_num - function number (1-10)
% Output:
%   fitness - function value
%   lb, ub - lower and upper bounds for the function

    switch func_num
        case 1  % Sphere function
            fitness = sum(x.^2);
            lb = -100; ub = 100;
            
        case 2  % Rastrigin function
            fitness = sum(x.^2 - 10*cos(2*pi*x) + 10);
            lb = -5.12; ub = 5.12;
            
        case 3  % Ackley function
            n = length(x);
            fitness = -20*exp(-0.2*sqrt(sum(x.^2)/n)) - exp(sum(cos(2*pi*x))/n) + 20 + exp(1);
            lb = -32; ub = 32;
            
        case 4  % Griewank function
            fitness = sum(x.^2)/4000 - prod(cos(x./sqrt(1:length(x)))) + 1;
            lb = -600; ub = 600;
            
        case 5  % Rosenbrock function
            fitness = sum(100*(x(2:end) - x(1:end-1).^2).^2 + (1 - x(1:end-1)).^2);
            lb = -2.048; ub = 2.048;
            
        case 6  % Schwefel function
            fitness = 418.9829*length(x) - sum(x.*sin(sqrt(abs(x))));
            lb = -500; ub = 500;
            
        case 7  % Levy function
            n = length(x);
            w = 1 + (x - 1)/4;
            fitness = sin(pi*w(1))^2 + sum((w(1:n-1) - 1).^2 .* (1 + 10*sin(pi*w(1:n-1) + 1).^2)) + ...
                     (w(n) - 1)^2 * (1 + sin(2*pi*w(n))^2);
            lb = -10; ub = 10;
            
        case 8  % Zakharov function
            fitness = sum(x.^2) + (sum(0.5*(1:length(x)).*x))^2 + (sum(0.5*(1:length(x)).*x))^4;
            lb = -5; ub = 10;
            
        case 9  % Sum of squares function
            fitness = sum((1:length(x)).*x.^2);
            lb = -10; ub = 10;
            
        case 10  % Dixon-Price function
            n = length(x);
            fitness = (x(1) - 1)^2 + sum((1:n-1).*(2*x(2:n).^2 - x(1:n-1)).^2);
            lb = -10; ub = 10;
            
        otherwise
            error('Function number must be between 1 and 10');
    end
end