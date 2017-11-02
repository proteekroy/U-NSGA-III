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


%This function plots population of each generation with different color
function plot_population(opt, popObj)

    figure(opt.fig);
    %hold all;
    if opt.M==2
        plot(popObj(:,1),popObj(:,2),'o','MarkerEdgeColor',opt.Color{randi(size(opt.Color,2))},'MarkerFaceColor',opt.Color{randi(size(opt.Color,2))});         
    elseif opt.M==3
        plot3(popObj(:,1),popObj(:,2),popObj(:,3),'o','MarkerEdgeColor',opt.Color{randi(size(opt.Color,2))},'MarkerFaceColor',opt.Color{randi(size(opt.Color,2))}); 
    end
    
    %xlim([0 1])
    %ylim([0 2])
    drawnow;


end