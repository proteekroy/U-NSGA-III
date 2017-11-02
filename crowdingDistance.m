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


%This function calculates crowding distance for front-f
function [CDF] = crowdingDistance(opt, f, objective)

    if size(f,2)==1
        CDF = opt.Inf;
    elseif size(f,2)==2
        CDF(1) = opt.Inf;
        CDF(2) = opt.Inf;
    else
        
        [M1, I1] = min(objective);
        [M2, I2] = max(objective);
        
        I = horzcat(I1, I2);
        I = unique(I);
        
        
        CDF = zeros(size(f,2),1);
        for i = 1:size(objective,2)
            
            [~,index] = sort(objective(:,i));
            for j = 2:size(index,1)-1
                if (abs(M2(i)-M1(i)) > opt.Epsilon)
                    CDF(index(j)) = CDF(index(j))+ ((objective(index(j+1),i)-objective(index(j-1),i))/(M2(i)-M1(i)))  ;
                end
            end
        end
        CDF(2:end-1) = CDF(2:end-1)/ size(objective,2);      
        CDF(I) = opt.Inf;

    end

end


