function [ f ] = do2dk1( x, K, s )
%DO2DK Calculates DO2DK objective values. Pareto optimal solutions are
%given by x=(x1,0,...,0) for s \in [0,1]. For s > 1 you have to filter
%dominated solutions from the solution set.
%   x is a matrix of decision variables. Each row corresponds to a single
%   solution's decision variable values.
%   K is the number of knees
%   s parameter for skewing

[rows, nObj] = size(x);

r = 5 + 10*( x(:,1) - 0.5).^2 + 1/K * cos(2*K*pi*x(:,1)) * 2^(s/2);

g = 1;

% Prevent division by 0 if nObj = 1;


if nObj > 1
    g = sum((x(2:nObj).^0.1),2);
end

f = zeros(rows,2);

f(:,1) = g .* r .* (sin(pi * x(:,1)/(2^(s+1)) + (1 + (2^s - 1)/(2^(s+2)))*pi )+1);
f(:,2) = g .* r .* (cos(pi * x(:,1)/2 + pi) + 1);

end

