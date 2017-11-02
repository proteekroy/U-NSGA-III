
% Copyright [2017] [Proteek Chandan Roy]
% 
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
% 
%     http://www.apache.org/licenses/LICENSE-2.0
% 
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.

function [FeasibleIndex, ParetoIndex] = calculate_feasible_paretofront(opt, pop, popObj, popCV)

    %-------------FIND FEASIBLE PARETO FRONT-------------------------------
    if opt.C>0 %Feasible Pareto front of Constraint Problems
        index = find(popCV<=0);
    else
        index = (1:size(pop,1))';
    end
    
    FeasibleIndex = index;
    
    if size(index,1)>0 % there are some feasible solutions
        index2 = paretoFront(popObj(index,:));
        ParetoIndex = index(index2)';
    else % no feasible solution yet
        ParetoIndex = [];
    end
    
                    
end