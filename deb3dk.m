function [ f ] = deb3dk( x, K )
%DEB3DK Calculates objective values for the DEB3DK problem. Pareto optimal
%solutions are given by x=(x1,x2,0,...,0) with (x1,x2) \in [0,1]^2, however
%dominated solutions must be filtered manually.
%   x is a matrix of decision variables. Each row corresponds to a single
%   solution's decision variable values.
%   K is the number of knees
% variable lenght default = 12

[rows, nObj] = size(x);

r1 = 5 + 10*( x(:,1) - 0.5).^2 + 2/K * cos(2*K*pi*x(:,1));
r2 = 5 + 10*( x(:,2) - 0.5).^2 + 2/K * cos(2*K*pi*x(:,2));

r12 = (r1 + r2)/2;

g = 1;
% Prevent empty matrix if x has only 2 objectives
if nObj > 2
   g = g + 9/(nObj -1) * sum(x(:,3:nObj),2); 
end

f=zeros(rows,3);

f(:,1) = g .* r12 .* sin(pi*x(:,1)/2) .* sin(pi * x(:,2)/2);
f(:,2) = g .* r12 .* sin(pi*x(:,1)/2) .* cos(pi * x(:,2)/2);
f(:,3) = g .* r12 .* cos(pi*x(:,1)/2);
end

