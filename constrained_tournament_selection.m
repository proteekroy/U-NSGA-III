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


% This file picks solution from tournament with this logic-
% If both are feasible pick a) Pick the one which has lower (better) rank
% b) Or If both are in same rank then pick the one with less crowding
% distance
% If one of them is feasible, pick the feasible one
% If both are infeasible, then pick the one with less constraint violation
% If CV values are same, then pick randomly

function selected_pop = constrained_tournament_selection(opt, pop, popObj, popCV)

    
    N = opt.N;% pop size

    %----TOURNAMENT CANDIDATES-------------------------------------------------

    tour1 = randperm(N);
    tour2 = randperm(N);


    %----START TOURNAMENT SELECTION--------------------------------------------


    selected_pop = zeros(N, opt.V); % Only the design variables of the selected members

    for i = 1:N
        p1 = tour1(i);
        p2 = tour2(i);

        if (popCV(p1)<=0 && popCV(p2)<=0)%both are feasible 

            obj1 = popObj(p1,:);
            obj2 = popObj(p2,:);
            d = lex_dominate(obj1, obj2);

            if d == 1 %p1 dominates p2
                selected_pop(i, :) = pop(p1,1:opt.V);
            elseif d == 3 % p2 dominates p1
                selected_pop(i, :) = pop(p2,1:opt.V); 
            else % d == 2
                % check crowding distance
                if(opt.CD(p1)>opt.CD(p2))
                    selected_pop(i, :) = pop(p1,1:opt.V);
                elseif (opt.CD(p1)<opt.CD(p2))
                    selected_pop(i, :) = pop(p2,1:opt.V);
                else %randomly pick any solution
                    if(rand <= 0.5) 
                        pick = p1; 
                    else
                        pick = p2; 
                    end
                    selected_pop(i, :) = pop(pick,1:opt.V);
                end
            end
        else
            if(popCV(p1) < popCV(p2)) %p1 less constraint violation          
                selected_pop(i, :) = pop(p1,1:opt.V);
            else 
                if (popCV(p2) < popCV(p1))
                    selected_pop(i, :) = pop(p2,1:opt.V); %p2 has less constraint violation
                else %randomly pick any solution
                    if(rand <= 0.5) 
                        pick = p1; 
                    else
                        pick = p2; 
                    end
                    selected_pop(i, :) = pop(pick,1:opt.V);%initially p1 was randomly choosen
                end
            end
        end

    end


end