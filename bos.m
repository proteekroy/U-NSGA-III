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

% This file implemented non-dominated sorting algorithm of the following paper
% "Best Order Sort: A New Algorithm to Non-dominated Sorting for Evolutionary Multi-objective Optimization"
%  - Proteek Chandan Roy, Md. Monirul Islam and Kalyanmoy Deb, Michigan State University, East Lansing, MI, USA
%  https://github.com/Proteek/Best-Order-Sort
%  This software is protected under Apache License 2.0 which can be found in http://www.apache.org/licenses/LICENSE-2.0.txt
% @author Proteek Chandan Roy, Department of CSE, Michigan State University, USA



function [R,F] = bos(objective)
    
    if isempty(objective)
       R = [];
       F = [];
       return;
    elseif size(objective,1)==1
        R = 1;
        F(1).f = 1;
        return;
    end

    %--------INITIALIZATION---------------
    [n,m]= size(objective);
    R = ones(n,1);
    
    if(m<4)
        m1 = m;
    else
        m1 = floor(min(ceil(log2(n)),m));
    end
    %---------SORTING PART-----------------
    Q = zeros(n, m1);
    lex_order = zeros(n,1);
    
    %--------FIND LEX ORDER----------------
    [~,Q(:,1)] = sortrows(objective);
    
    for i = 1:n 
        lex_order(Q(i,1)) = i;
    end
    
    for i = 2:m1
       %H = horzcat(objective(:,i), lex_order);%in case of tie use lex order
       H = horzcat(objective(:,i), objective(:,1));
       [~,Q(:,i)] = sortrows(H);
    end
    
   

    
    %-------RANKING PART-------------------
    done = zeros(n, 1);
    total = 0;
    totalfront = 1;
    L = cell(m1, n);
    for i = 1:n
        for j = 1:m1 
            s  = Q(i,j);
            if done(s) == 1
                L{j, R(s)} = horzcat(s, L{j, R(s)});
                continue;
            end
            total = total + 1;
            done(s) = 1;
            
            
            for k = 1: totalfront %for all front
                d = 0;
                sz = size(L{j,k},2);
                for l = 1:sz % for all elements
                    d = lex_dominate(objective(L{j,k}(l),:), objective(s,:));
                    if d == 1
                       break; 
                    end
                end
                if d == 0 %not dominates
                    R(s) = k;
                    L{j, k} = horzcat(s, L{j, k});    
                    break;
                elseif d==1 && k==totalfront
                    totalfront = totalfront + 1;
                    R(s) = totalfront;
                    L{j,totalfront} = horzcat(s, L{j,totalfront});
                    break;
                
                end
            end
            
            
            if total==n
               break; 
            end
        end
    end
    
    F(n).f = [];
        
    for i=1:n
        F(R(i)).f = [F(R(i)).f i];
    end
    
end


%checks lexicographical domination of two solutions
function [d] = lex_dominate(obj1, obj2)
    
    
    equal = 1;
    d = 1;
    sz = size(obj1,2);
    for i = 1:sz	
        if obj1(i) > obj2(i)
            d = 0;
            break;
        elseif(equal==1 && obj1(i) < obj2(i))
			equal = 0;
        end
        
    end
    if d ==1 && equal==1 %check if both solutions are equal
        d = 0;
    end
end