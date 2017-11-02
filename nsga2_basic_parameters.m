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

function [opt] = nsga2_basic_parameters(opt)
    
    
    %-----OPTIMIZATION ALGORITHM PARAMETERS-------------------------------
    opt.eta_c = 15;%crossover index
    opt.eta_m = 20;%mutation index
    opt.G  = 200;% Generations
    opt.N = 200;%population size in optimization algorithm
    opt.pcross = 0.9; % Crossover probability
    opt.nrealcross = 0;%number of crossover performed
    opt.nrealmut = 0;%number of mutation performed
    opt.gen = 1;%starting generation
    opt.pop = [];%initial population
    opt.popObj = [];
    opt.Epsilon = 1e-14;%numerical difference
    opt.Inf = 1e14;%maximum value
    opt.initpopsize = opt.N;%initial sample size for high fidelity computation
           
    opt.crossoverOption = 1;% 1 = simulated binary crossover
    opt.mutationOption = 1;% 1 = polynomial mutation
    opt.matingselectionOption = 1;%1 = binary constraint tournament selection
    opt.survivalselectionOption = 2;%1 = NSGA-II, 2 = NSGA-III
    opt.associationsReady = false;
    
    if opt.survivalselectionOption==1
        opt.algorithm_name = 'nsga2';
    else
        opt.algorithm_name = 'nsga3';
    end
    
    opt.testfilename = strcat(opt.algorithm_name, '_',  lower(opt.objfunction));
        
    %filename where data will be saved
    opt.varfilename = strcat(opt.objfunction,'_var_',num2str(opt.r),'.txt');%save variables
    opt.objfilename = strcat(opt.objfunction,'_obj_',num2str(opt.r),'.txt');%save objective
    opt.cvfilename  = strcat(opt.objfunction,'_cv_',num2str(opt.r),'.txt');%constraint violation
    
    
    %-----OBJECTIVE FUNCTION PARAMETERS------------------------------------
    problem = lower(opt.objfunction);
    switch(problem)
        case {'zdt1','zdt2','zdt3','zdt4','zdt6'}
            opt.M = 2;%number of objectives
            opt.V = 30;%;10;%number of variables
            opt.C = 0;%number of constraints
            opt.utopian = [-0.05, -0.05];%ideal point, may not be used
            opt.min_val = [0 0];%minimum value for normalization, may not be used
            opt.max_val = [1 1];%maximum objective, may not be used
            
            if strcmp(opt.objfunction,'zdt6')
                opt.min_val = [0.25 0];
            elseif strcmp(opt.objfunction,'zdt3')
                opt.utopian = [-0.05, -1.1];
                opt.min_val = [0 -1];
                opt.max_val = [1 1];
            end
            
        case {'dtlz1', 'dtlz2', 'dtlz3','dtlz4', 'dtlz5', 'dtlz7'}
            opt.M = 2;
            opt.V = 11;
            opt.C = 0;
            opt.utopian = (-0.05).*ones(1, opt.M);
            opt.min_val = zeros(1, opt.M);
            opt.max_val = ones(1, opt.M);
 
        case {'wfg1', 'wfg2', 'wfg3','wfg4', 'wfg5', 'wfg6','wfg7','wfg8','wfg9'}
            opt.M = 3;
            opt.V = 8; 
            opt.C = 0;
            opt.utopian = (-0.05).*ones(1, opt.M);
            opt.min_val = zeros(1, opt.M);
            opt.max_val = ones(1, opt.M);
            
        case {'uf1', 'uf2', 'uf3','uf4', 'uf5', 'uf6','uf7','uf8','uf9'}
            opt.M = 2;
            opt.V = 30; 
            opt.C = 0;
            opt.utopian = (-0.05).*ones(1, opt.M);
            opt.min_val = zeros(1, opt.M);
            opt.max_val = ones(1, opt.M);   
            
        case {'do2dk','do2dk1','deb2dk','deb2dk1'}
            opt.M = 2;
            opt.V = 30;
            opt.C = 0;
            opt.utopian = (-0.05).*ones(1, opt.M);
            opt.min_val = zeros(1, opt.M);
            opt.max_val = ones(1, opt.M);
            
        case {'deb3dk','deb3dk1'}
            opt.M = 3;
            opt.V = 30;
            opt.C = 0;
            opt.utopian = [-0.05, -0.05 -0.05];
            opt.min_val = [0 0 0];

        case {'c2dtlz2','c3dtlz2'}
            opt.M = 3;
            opt.V = 7; 
            
            opt.utopian = [-0.05, -0.05 -0.05];
            opt.min_val = [0 0 0];
            
            if strcmp(opt.objfunction,'c2dtlz2')
                opt.C = 1;
                opt.max_val = [1 1 1];
            else
                opt.C = 3;
                opt.max_val = [2.01 2.01 2.01];
            end
        
        case 'bnh'  
            opt.M = 2;
            opt.V = 2; 
            opt.C = 2;
            opt.utopian = [-0.05, -0.05];
            opt.min_val = [0 0];
            opt.max_val = [140 55];
            
        case 'osy'
            opt.M = 2;
            opt.V = 6;
            opt.C = 6;
            opt.utopian = [-300 0];
            opt.min_val = [-274 4];
            opt.max_val = [-42 76];
            
        case 'srn'
            opt.M = 2;
            opt.V = 2; 
            opt.C = 2;
            opt.utopian = [0 -300];
            opt.min_val = [0 -250];
            opt.max_val = [240 0];
        case 'tnk'
            opt.M = 2;
            opt.V = 2; 
            opt.C = 2;
            opt.utopian = [-0.001, -0.001];
            opt.min_val = [0 0];
            opt.max_val = [1.2 1.2];
        case 'water'
            opt.M = 5;
            opt.V = 3; 
            opt.C = 7;
            opt.utopian = (-0.05).*ones(1, opt.M);
            opt.min_val = [0.75 0 0 0 0];
            opt.max_val = [0.95 0.9 1.0 1.6 3.2];
        case 'carside'
            opt.M = 3;
            opt.V = 7; 
            opt.C = 10;
            opt.utopian = [24.3180    3.5352   10.5610];
            opt.min_val = [24.3680    3.5852   10.6110];
            opt.max_val = [42.7620    4.0000   12.5210];
            
        case 'welded'
            opt.M = 2;
            opt.V = 4; 
            opt.C = 4;
            opt.utopian = [2.3316   -0.0496];
            opt.min_val = [2.3816    0.0004];
            opt.max_val = [36.4403    0.0157];           
        otherwise
            input('Function definition is not found');
    end
    
    %--------LOWER AND UPPER BOUND OF DECISION VARIABLE--------------------
    opt.bound = zeros(2,opt.V);
    opt.bound(2,:) = ones(1,opt.V);
    if(strcmpi(opt.objfunction,'zdt4'))
        opt.bound(1,2:end) = opt.bound(1,2:end)+(-5);
        opt.bound(2,2:end) = opt.bound(2,2:end)*5;
    elseif(strcmpi(opt.objfunction,'UF1') ||strcmpi(opt.objfunction,'UF2') || strcmpi(opt.objfunction,'UF5') || strcmpi(opt.objfunction,'UF6') || strcmpi(opt.objfunction,'UF7'))
        opt.bound(1,2:end) = opt.bound(1,2:end)+(-1);
        opt.bound(2,2:end) = opt.bound(2,2:end)*1;
    elseif(strcmpi(opt.objfunction,'UF4') )
        opt.bound(1,2:end) = opt.bound(1,2:end)+(-2);
        opt.bound(2,2:end) = opt.bound(2,2:end)*2;
    elseif(strcmpi(opt.objfunction,'UF8') || strcmpi(opt.objfunction,'UF9')|| strcmpi(opt.objfunction,'UF10'))
        opt.bound(1,3:end) = opt.bound(1,3:end)+(-2);
        opt.bound(2,3:end) = opt.bound(2,3:end)*2;
    elseif(strcmpi(opt.objfunction,'BNH'))
        opt.bound(2,1)=5;
        opt.bound(2,2)=3;
    elseif(strcmpi(opt.objfunction,'OSY'))
        opt.bound(2,1)=10;%x1
        opt.bound(2,2)=10;
        opt.bound(2,6)=10;
        opt.bound(1,3)=1;
        opt.bound(1,5)=1;
        opt.bound(2,3)=5;
        opt.bound(2,5)=5;
        opt.bound(2,4)=6;
    elseif(strcmpi(opt.objfunction,'SRN'))
        opt.bound(1,1:end) = opt.bound(1,1:end)+(-20);
        opt.bound(2,1:end) = opt.bound(2,1:end)*20;
    elseif(strcmpi(opt.objfunction,'TNK'))
        opt.bound(2,1:end) = opt.bound(2,1:end)*pi;
    elseif(strcmpi(opt.objfunction,'WATER'))
        opt.bound(1,1:end) = opt.bound(1,1:end)+0.01;
        opt.bound(2,1) = 0.45;   
        opt.bound(2,2:end) = 0.10; 
    elseif(strcmpi(opt.objfunction,'carside'))
        opt.bound(1,1:end) = [0.5 0.45 0.5 0.5 0.875 0.4 0.4];
        opt.bound(2,1:end) = [1.5 1.35 1.5 1.5 2.625 1.2 1.2];
    elseif(strcmpi(opt.objfunction,'welded'))
        opt.bound(1,1:end) = [0.125 0.1 0.1 0.125];
        opt.bound(2,1:end) = [5 10 10 5];
    elseif    (strcmpi(opt.objfunction,'wfg1') || strcmpi(opt.objfunction,'wfg2') || strcmpi(opt.objfunction,'wfg3') ...
            || strcmpi(opt.objfunction,'wfg4') || strcmpi(opt.objfunction,'wfg5') || strcmpi(opt.objfunction,'wfg6')...
            || strcmpi(opt.objfunction,'wfg7') || strcmpi(opt.objfunction,'wfg8') || strcmpi(opt.objfunction,'wfg9'))
        opt.bound(1,:) = zeros(1,opt.V);
        opt.bound(2,:) = ones(1,opt.V);
    end
    
    %---------REFERENCE DIRECTION------------------------------------------

    %% Haitham - Start
    dirCount = inf;
    tempN = opt.N;
    while dirCount > opt.N
        opt.dirs = initweight(opt.M, tempN)';
        dirCount = size(opt.dirs, 1);
        tempN = tempN - 1;
    end
    % Haitham - End

%     %Three obj
%     if opt.M==5
%         opt.dirs = initweight(5, 210)';
%     elseif opt.M==3 %Three obj
%         opt.dirs = initweight(3, 91)';
%     else
%         opt.dirs = initweight(2, 21)';
%     end

    %initialization
    opt.numdir = size(opt.dirs,1);%number of reference directions
    opt.curdir = opt.dirs(1,:);%current direction
    opt.pmut = 1.0/opt.V; %Mutation probability    
    opt.CD = zeros(opt.N,1);%initial crowding distance
    opt.PR = zeros(opt.N,1);%initial pagerank for PR
    opt.Color = {'k','b','r','g','y',[.5 .6 .7],[.8 .2 .6]}; %Colors.
    opt.totalFuncEval = opt.N * opt.G;%total number of function evaluation
    
end

%------------------------------END OF -FILE--------------------------------

