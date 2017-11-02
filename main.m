
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

% This Software runs NSGA-II procedure for different testfunctions
% You are free to change, modify, share and distribute this software
% Please Acknowledge the author (if possible) for any use of this software
% @author Proteek Chandan Roy, Department of CSE, Michigan State University, USA
% email: royprote@egr.msu.edu

function main()
        
    test_function = ['zdt1   ';'zdt2   ';'zdt3   ';'zdt4   ';'zdt6   ';...
                     'dtlz1  ';'dtlz2  ';'dtlz3  ';'dtlz4  '; 'dtlz5  ';...
                     'dtlz7  ';'srn    ';'bnh    ';'osy    ';'tnk    ';...
                     'c2dtlz2'; 'DO2DK  ';'DO2DK1 ';  'DEB2DK ';'DEB2DK1';...
                     'DEB3DK ';'DEB3DK1' ;'UF1    '];

%-------------------MAIN LOOP----------------------------------------------    
    run = 1;%number of runs
    
    for func_no = 16:1:16%:4%for all test functions 
        for r = 1:1:run%number of runs
            opt.r = r;%run number
            disp(r);
            opt.objfunction = strtrim(test_function(func_no,:));%remove whitespaces
            %opt.func_no = func_no;%function number
            opt = nsga2_basic_parameters(opt);%basic parameters of evolutionary algorithm            
            
            opt.pareto = load('Pareto Front/C2DTLZ2.3D.pf');%Pareto front
                       
            %-----------PLOT PARETO FRONT----------------------------------
            
            opt.fig = figure;
            plot_population(opt, opt.pareto);
            
            
            
            
            if r<10
                opt.objfilename = strcat(opt.testfilename,'_00',num2str(r),'.obj');
                opt.histfilename = strcat(opt.testfilename,'_00',num2str(r),'.hist');
            elseif r<100
                opt.objfilename = strcat(opt.testfilename,'_0',num2str(r),'.obj');
                opt.histfilename = strcat(opt.testfilename,'_0',num2str(r),'.hist');
            else
                opt.objfilename = strcat(opt.testfilename,'_',num2str(r),'.obj');
                opt.histfilename = strcat(opt.testfilename,'_',num2str(r),'.hist');
            end
               
            %---------------- OPTIMIZE ------------------------------------

            opt = nsga2_main(opt);
            
            %----------------WRITE TO FILE---------------------------------
            [~, ParetoIndex] = calculate_feasible_paretofront(opt, opt.pop, opt.popObj, opt.popCV);
            dlmwrite(opt.objfilename, opt.popObj(ParetoIndex,:), 'delimiter',' ','precision','%.10f');%feasible non-dominated front
            
%             dlmwrite(opt.varfilename, opt.pop, 'delimiter',' ','precision','%.10f');%'-apend' for apending
%             dlmwrite(opt.objfilename, opt.popObj, 'delimiter',' ','precision','%.10f');
%             dlmwrite(opt.cvfilename, opt.popCV,  'delimiter', ' ','precision','%.10f');           
%             all_filename = strcat('all_fitness',num2str(r),'_nsga2.txt'); 
%             dlmwrite(all_filename, opt.archiveObj, 'delimiter',' ','precision','%.10f');
            
            
            %----------PLOT PARETO FRONT AND FINAL SOLUTION----------------
            opt.fig = figure;
            hold all;
            plot_population(opt, opt.pareto);
            plot_population(opt, opt.popObj);
            
        end
        
        disp('END');
       
    end
    
end


%------------------------------END OF -FILE--------------------------------


