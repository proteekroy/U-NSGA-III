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


function [d] = lex_dominate(obj1, obj2)
    
    a_dom_b = 0;
    b_dom_a = 0;
    
    
    sz = size(obj1,2);
    for i = 1:sz	
        if obj1(i) > obj2(i)
            b_dom_a = 1;
        elseif(obj1(i) < obj2(i))
			a_dom_b = 1;
        end
        
    end
    
    if(a_dom_b==0 && b_dom_a==0)
        d = 2;
    elseif(a_dom_b==1 && b_dom_a==1)
       d = 2; 
    else
        if a_dom_b==1
            d = 1;
        else
            d = 3;
        end
    end
        
end