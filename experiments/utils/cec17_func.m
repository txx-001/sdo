function y = cec17_func(x, func_num)
    % CEC2017 benchmark functions
    % 
    % Inputs:
    %   x: Input vector
    %   func_num: Function number (1-30)
    %
    % Output:
    %   y: Function value
    
    switch func_num
        case 1
            y = cec17_f1(x);  % Shifted and Rotated Bent Cigar Function
        case 2
            y = cec17_f2(x);  % Shifted and Rotated Sum of Different Power Function
        case 3
            y = cec17_f3(x);  % Shifted and Rotated Zakharov Function
        case 4
            y = cec17_f4(x);  % Shifted and Rotated Rosenbrock's Function
        case 5
            y = cec17_f5(x);  % Shifted and Rotated Rastrigin's Function
        case 6
            y = cec17_f6(x);  % Shifted and Rotated Expanded Scaffer's F6 Function
        case 7
            y = cec17_f7(x);  % Shifted and Rotated Lunacek Bi_Rastrigin Function
        case 8
            y = cec17_f8(x);  % Shifted and Rotated Non-Continuous Rastrigin's Function
        case 9
            y = cec17_f9(x);  % Shifted and Rotated Levy Function
        case 10
            y = cec17_f10(x); % Shifted and Rotated Schwefel's Function
        case 11
            y = cec17_f11(x); % Hybrid Function 1 (N=3)
        case 12
            y = cec17_f12(x); % Hybrid Function 2 (N=3)
        case 13
            y = cec17_f13(x); % Hybrid Function 3 (N=3)
        case 14
            y = cec17_f14(x); % Hybrid Function 4 (N=4)
        case 15
            y = cec17_f15(x); % Hybrid Function 5 (N=4)
        case 16
            y = cec17_f16(x); % Hybrid Function 6 (N=4)
        case 17
            y = cec17_f17(x); % Hybrid Function 6 (N=5)
        case 18
            y = cec17_f18(x); % Hybrid Function 6 (N=5)
        case 19
            y = cec17_f19(x); % Hybrid Function 6 (N=5)
        case 20
            y = cec17_f20(x); % Hybrid Function 6 (N=6)
        case 21
            y = cec17_f21(x); % Composition Function 1 (N=3)
        case 22
            y = cec17_f22(x); % Composition Function 2 (N=3)
        case 23
            y = cec17_f23(x); % Composition Function 3 (N=4)
        case 24
            y = cec17_f24(x); % Composition Function 4 (N=4)
        case 25
            y = cec17_f25(x); % Composition Function 5 (N=5)
        case 26
            y = cec17_f26(x); % Composition Function 6 (N=5)
        case 27
            y = cec17_f27(x); % Composition Function 7 (N=6)
        case 28
            y = cec17_f28(x); % Composition Function 8 (N=6)
        case 29
            y = cec17_f29(x); % Composition Function 9 (N=3)
        case 30
            y = cec17_f30(x); % Composition Function 10 (N=3)
        otherwise
            error('Invalid function number. Please use 1-30.');
    end
end

function y = cec17_f1(x)
    % F1: Shifted and Rotated Bent Cigar Function
    dim = length(x);
    if dim == 2
        shift = [0, 0];
    elseif dim == 10
        shift = zeros(1, dim);
    elseif dim == 30
        shift = zeros(1, dim);
    elseif dim == 50
        shift = zeros(1, dim);
    elseif dim == 100
        shift = zeros(1, dim);
    else
        shift = zeros(1, dim);
    end
    
    z = x - shift;
    y = z(1)^2 + 10^6 * sum(z(2:end).^2) + 100;
end

function y = cec17_f2(x)
    % F2: Shifted and Rotated Sum of Different Power Function
    dim = length(x);
    shift = zeros(1, dim);
    z = x - shift;
    
    y = 0;
    for i = 1:dim
        y = y + (abs(z(i)))^(2 + 4*(i-1)/(dim-1));
    end
    y = y + 200;
end

function y = cec17_f3(x)
    % F3: Shifted and Rotated Zakharov Function
    dim = length(x);
    shift = zeros(1, dim);
    z = x - shift;
    
    sum1 = sum(z.^2);
    sum2 = sum(0.5 * (1:dim) .* z);
    y = sum1 + sum2^2 + sum2^4 + 300;
end

function y = cec17_f4(x)
    % F4: Shifted and Rotated Rosenbrock's Function
    dim = length(x);
    shift = ones(1, dim);
    z = x - shift + 1;
    
    y = 0;
    for i = 1:dim-1
        y = y + 100 * (z(i)^2 - z(i+1))^2 + (z(i) - 1)^2;
    end
    y = y + 400;
end

function y = cec17_f5(x)
    % F5: Shifted and Rotated Rastrigin's Function
    dim = length(x);
    shift = zeros(1, dim);
    z = x - shift;
    
    y = sum(z.^2 - 10*cos(2*pi*z) + 10) + 500;
end

function y = cec17_f6(x)
    % F6: Shifted and Rotated Expanded Scaffer's F6 Function
    dim = length(x);
    shift = zeros(1, dim);
    z = x - shift;
    
    y = 0;
    for i = 1:dim-1
        y = y + schaffer_f6(z(i), z(i+1));
    end
    y = y + schaffer_f6(z(dim), z(1)) + 600;
end

function f = schaffer_f6(x, y)
    temp1 = sin(sqrt(x^2 + y^2))^2;
    temp2 = 1 + 0.001*(x^2 + y^2);
    f = 0.5 + (temp1 - 0.5) / temp2^2;
end

function y = cec17_f7(x)
    % F7: Shifted and Rotated Lunacek Bi_Rastrigin Function
    dim = length(x);
    shift = zeros(1, dim);
    z = x - shift;
    
    mu0 = 2.5;
    d = 1;
    s = 1 - 1/(2*sqrt(dim+20) - 8.2);
    mu1 = -sqrt((mu0^2 - d)/s);
    
    sum1 = sum((z - mu0).^2);
    sum2 = sum((z - mu1).^2);
    sum3 = sum(cos(2*pi*z));
    
    y = min(sum1, d*dim + s*sum2) + 10*(dim - sum3) + 700;
end

function y = cec17_f8(x)
    % F8: Shifted and Rotated Non-Continuous Rastrigin's Function
    dim = length(x);
    shift = zeros(1, dim);
    z = x - shift;
    
    % Non-continuous transformation
    for i = 1:dim
        if abs(z(i)) > 0.5
            z(i) = round(2*z(i))/2;
        end
    end
    
    y = sum(z.^2 - 10*cos(2*pi*z) + 10) + 800;
end

function y = cec17_f9(x)
    % F9: Shifted and Rotated Levy Function
    dim = length(x);
    shift = zeros(1, dim);
    z = x - shift;
    
    w = 1 + (z - 1)/4;
    
    sum1 = (sin(pi*w(1)))^2;
    sum2 = 0;
    for i = 1:dim-1
        sum2 = sum2 + (w(i) - 1)^2 * (1 + 10*(sin(pi*w(i) + 1))^2);
    end
    sum3 = (w(dim) - 1)^2 * (1 + (sin(2*pi*w(dim)))^2);
    
    y = sum1 + sum2 + sum3 + 900;
end

function y = cec17_f10(x)
    % F10: Shifted and Rotated Schwefel's Function
    dim = length(x);
    shift = zeros(1, dim);
    z = x - shift + 420.9687462275036;
    
    y = 418.9829*dim - sum(z .* sin(sqrt(abs(z)))) + 1000;
end