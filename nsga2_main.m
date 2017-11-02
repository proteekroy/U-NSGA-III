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


%This is main function that runs NSGA-II procedure
function opt = nsga2_main(opt)

    %------------INITIALIZE------------------------------------------------
    opt.pop = lhsamp_model(opt.N, opt);%LHS Sampling
    
    %------------EVALUATE--------------------------------------------------
    [opt.popObj, opt.popCons] = evaluate_pop(opt, opt.pop);
    opt.popCV = evaluateCV(opt.popCons);
    opt.archiveObj = opt.popObj;%to save all objectives
    opt.archive = opt.pop;
    opt.archiveCV = opt.popCV;
    
    %-------------------PLOT INITIAL SOLUTIONS-----------------------------
    plot_population(opt, opt.popObj);
    
    if exist(opt.histfilename, 'file')==2
        delete(opt.histfilename);
    end
    %--------------- OPTIMIZATION -----------------------------------------
    funcEval = opt.N;
    
    while funcEval < opt.totalFuncEval % Generation # 1 to 

        M1 = repmat(funcEval, opt.N, 1);
        M2 = opt.pop;
        M3 = opt.popObj;
        M4 = (-1)*opt.popCV;
        M = horzcat(M1, M2, M3, M4);
        
        dlmwrite(opt.histfilename, M, '-append', 'delimiter',' ','precision','%.10f');%history of run
        opt = mating_selection(opt);%--------Mating Parent Selection-------
        opt = crossover(opt);%-------------------Crossover-----------------
        opt = mutation(opt);%--------------------Mutation------------------
        
        
        %---------------EVALUATION-----------------------------------------
        [opt.popChildObj, opt.popChildCons] = evaluate_pop(opt, opt.popChild);
        opt.popCV = evaluateCV(opt.popCons);
        opt.popChildCV = evaluateCV(opt.popChildCons);
        
        
        
        %---------------MERGE PARENT AND CHILDREN--------------------------
        opt.totalpopObj = vertcat(opt.popChildObj, opt.popObj);
        opt.totalpop = vertcat(opt.popChild, opt.pop);
        opt.totalpopCV = vertcat(opt.popChildCV, opt.popCV);
        opt.totalpopCons = vertcat(opt.popChildCons, opt.popCons);
        
        %-----------------SURVIVAL SELECTION-------------------------------
        opt = survival_selection(opt);
        funcEval = funcEval + opt.N;
        
        opt.popCV = evaluateCV(opt.popCons);
        opt.archive = vertcat(opt.archive,opt.pop);
        opt.archiveObj = vertcat(opt.archiveObj,opt.popObj);
        opt.archiveCV = vertcat(opt.archiveCV,opt.popCV);
        
        
        %-------------------PLOT NEW SOLUTIONS----------------------------- 
        
        if mod(funcEval,1000)==0
            disp(funcEval);
            plot_population(opt, opt.popObj);
        end
        %[opt.FeasibleIndex, opt.ParetoIndex] = calculate_feasible_paretofront(opt, opt.archive, opt.archiveObj, opt.archiveCV);
    end
    
    M1 = repmat(funcEval, opt.N, 1);
    M2 = opt.pop;
    M3 = opt.popObj;
    M4 = (-1)*opt.popCV;
    M = horzcat(M1, M2, M3, M4);
        
    dlmwrite(opt.histfilename, M, '-append', 'delimiter',' ','precision','%.10f');%history of run
    

end%end of function
%------------------------------END OF -FILE--------------------------------

