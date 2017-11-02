function [ f ] = deb2dk2( x, K )
%DEB2DK Calculates objective values for the DEB2DK problem. The Pareto
%front is given by (x1,0,...,0) with x1 \in [0,1].
%   x is a matrix of decision variables. Each row corresponds to a single
%   solution's decision variable values.
%   K is the number of knees

[rows, nObj] = size(x);

r = 2.5 + 10*( x(:,1) - 0.5).^2 + 1/K * cos(2*K*pi*x(:,1));

g = 1;
% Prevent division by 0 if nObj = 1;
if nObj > 1
    g = g + 9/(nObj -1) * sum(x(:,2:nObj),2);
end

f=zeros(rows,2);

f(:,1) = g .* r .* ((sin(pi * x(:,1)/2)).^3);
f(:,2) = g .* r .* cos(pi * x(:,1)/2);
end

