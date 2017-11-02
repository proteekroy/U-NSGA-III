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


%This file implements polynomial mutation

function [pop_mut, nrealmut] = pol_mut(pop_crossover, pmut, nrealmut, eta_m, Xmin, Xmax )



[N, nreal] = size( pop_crossover); % Population size & Number of variables
pop_mut =  pop_crossover;% Child before mutation


for ind = 1:N
    for i = 1:nreal
        if rand <= pmut
            y = pop_mut(ind,i);
            yl = Xmin(i);
            yu = Xmax(i);
            delta1 = (y-yl) / (yu-yl);
            delta2 = (yu-y) / (yu-yl);
            rand_var = rand;
            mut_pow = 1.0/(eta_m+1.0);
            if rand_var <= 0.5
                xy = 1.0 - delta1;
                val = 2.0*rand_var + (1.0 - 2.0*rand_var) * xy^(eta_m+1.0);
                deltaq =  val^mut_pow - 1.0;
            else
                xy = 1.0 - delta2;
                val = 2.0*(1.0 - rand_var) + 2.0*(rand_var-0.5) * xy^(eta_m+1.0);
                deltaq = 1.0 - val^mut_pow;
            end
            y = y + deltaq*(yu - yl);
            if (y<yl), y = yl; end
            if (y>yu), y = yu; end
            pop_mut(ind,i) = y;
            nrealmut = nrealmut+1;
        end
    end
end
