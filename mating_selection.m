
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



function [opt] = mating_selection(opt)

    switch(opt.survivalselectionOption)
        case 1
            opt.popChild = constrained_tournament_selection(opt, opt.pop, opt.popObj, opt.popCV);
        case 2
            opt.popChild = niching_based_tournament_selection(opt, opt.pop, opt.popObj, opt.popCV);
        otherwise
            opt.popChild = constrained_tournament_selection(opt, opt.pop, opt.popObj, opt.popCV);
    end
    
end