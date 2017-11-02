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



%This function evaluates constrain violation (positive if violated), zero
%otherwise
function cv = evaluateCV(pop_cons)
    

    g = pop_cons;
            
    for i=1:size(pop_cons,1)
        for j=1:size(pop_cons,2)
            if g(i,j)<0
                g(i, j) = 0; 
            end
        end
    end
    
    cv = sum(g, 2);

end