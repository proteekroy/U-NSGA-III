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

%
% Proteek Chandan Roy, 2016
% Contact: royprote@msu.edu, proteek_buet@yahoo.com



%-------------HIGH FIDELITY EVALUATION OF POPULATION-----------------------

function [popObj, popCons] = evaluate_pop(opt, pop)

    popObj = zeros(size(pop,1),opt.M);
    if opt.C>0
        popCons = zeros(size(pop,1),opt.C);
    else
        popCons = zeros(size(pop,1), 1);
    end
    sz = size(pop,1);
    for i = 1:sz
        [f, g] = high_fidelity_evaluation(opt, pop(i,:));
        popObj(i, 1:opt.M) = f;
        if opt.C>0
            popCons(i,:) = g;
        else
            popCons(i,1) = 0;
        end
    end

end