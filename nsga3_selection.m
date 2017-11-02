function opt = nsga3_selection(opt)

    [n, ~] = size(opt.totalpopObj);
    opt.R = zeros(size(opt.totalpopObj,1),1);   
     
    selectedPopIndex = [];
    index = opt.totalpopCV<=0;
    FeasiblePopIndex = find(index == 1);    
    InfeasiblePopIndex = find(index == 0);

    %----------------------------------------------------------------------
    %---------Find Non-dominated Sorting of Feasible Solutions If exists---
    %----------------------------------------------------------------------
    
    
    F = cell(n,1);
    opt.R = zeros(n,1);
    if ~isempty(FeasiblePopIndex)
                
        [R,~] = bos(opt.totalpopObj(FeasiblePopIndex,:));
        
        for i=1:size(FeasiblePopIndex,1)
            F{R(i)} = horzcat(F{R(i)}, FeasiblePopIndex(i));
        end
    end 
    
    
    %----------------------------------------------------------------------
    %--If Less #Feasible <N, then we need sort infeasibles to select-------
    %----------------------Don't do niching here---------------------------
    %----------------------------------------------------------------------
    
    %% Haitham - Start
    opt.pop2Dir = zeros(opt.N, 1);
    opt.pop2DirDistances = zeros(opt.N, 1);
    opt.associationsReady = false;
    idx = 1;
    % Haitham
    
    if size(FeasiblePopIndex,1)<opt.N
        
        %-------------Pick all feasible solutions--------------------------
        selectedPopIndex = FeasiblePopIndex';
        
        %--------------Rank the Infeasible Solutions-----------------------
    
        if ~isempty(InfeasiblePopIndex)

            CV = opt.totalpopCV(InfeasiblePopIndex);
            [~,index] = sort(CV,'ascend');
            
            for i = 1: size(index,1)
                selectedPopIndex = horzcat(selectedPopIndex, InfeasiblePopIndex(index(i)));
                if size(selectedPopIndex, 2) >= opt.N
                    break; 
                end
            end

        end
    
    %----------------------------------------------------------------------
    %--If there are more #Feasibles than we need to select, Do Niching-----
    %----------------------------------------------------------------------
    
    else
        
        %% Haitham - Start
        opt.associationsReady = true;
        % Haitham - End
        
        %------------------Find Last Front---------------------------------
        
        count = zeros(n,1);
        for i=1:n
            count(i) = size(F{i},2);
        end

        cd = cumsum(count);
        p1 = find(opt.N<cd);
        lastfront = p1(1);
        
        %-----------Select upto the front before last front----------------
        
        for i=1:lastfront-1
            selectedPopIndex = horzcat(selectedPopIndex, F{i});
        end
        
        %do a check in to see if N reached
        
        lastPopIndex = F{lastfront};
        
        combinedObj = vertcat(opt.totalpopObj(selectedPopIndex,:), opt.totalpopObj(lastPopIndex,:));
        combinePopIndex = horzcat(selectedPopIndex, lastPopIndex);
               
        %------------------------------------------------------------------       
        %---------------------------FIND INTERCEPT-------------------------
        %------------------------------------------------------------------
            
        z = min(combinedObj);%find the population minimum
        TranslatedObj = combinedObj - repmat(z, size(combinedObj, 1), 1);%recalculate objective according to z
            
        ASFLines = eye(opt.M);%ASF direction inclined along each objective
        S = zeros(opt.M, opt.M);%To collect the intercept
            
        for i=1:opt.M
            w = ASFLines(i,:);
            w(1:opt.M~=i) = 1e-16;
            w = w./norm(w);
            [~, index] = min(max(TranslatedObj./repmat(w,size(TranslatedObj,1),1),[],2));%finding ASF values with a direction inclined in an objective
            S(i,:) = TranslatedObj(index,:); %choise the element with smallest asf w.r.t. ASFLines(i,:)
        end

        %----Check if M points doesn't make M-simplex----------------------
        %----It can also happen when size(lastPopIndex,2)<opt.M------------
        
        if det(S)<1e-16   
            A = max(TranslatedObj,[], 1);
        else
            b = ones(opt.M,1);
            A = linsolve(S,b);
            A = 1./A;
            A = A';
            
%             if opt.M==3 % check intercept
%                 hold all;
%                 xlabel('x')
%                 ylabel('y')
%                 zlabel('z')
%                 box on
%                 grid on
%                 hold on
%                 Intercept = [A(1) 0 0;
%                             0 A(2) 0;
%                             0 0 A(3)];
%                 fill3(Intercept(:,1),Intercept(:,2),Intercept(:,3),'c');
%                 scatter3(S(:,1), S(:,2), S(:,3),'*');
%             end
        end
        
        %---------------Plot to see if intercept is correct----------------
       
        
        
        %------------------NORMALIZE WITH INTERCEPT------------------------
            
        NormalizedObj = TranslatedObj./repmat(A,size(TranslatedObj,1),1);
                
        %------------------------------------------------------------------    
        %-------------------ASSOCIATION------------------------------------
        %------------------------------------------------------------------
        
        %------------------------------------------------------------------
        %-----For Each Direction select nearest solution for last front----
        %-----For Two cases: Selected fronts, and Last front---------------
        %------------------------------------------------------------------
        %should have been same for all cases
        
        Count = zeros(opt.numdir, 1);
               
        %----------------for selected indices------------------------------
        
        tempPopDir = zeros(size(opt.totalpopObj, 1), 1);%for each solution save direction
        distance = zeros(size(opt.totalpopObj, 1), 1);%for each solution save distance of that direction
        distance(1:end) = intmax;
        
        for i = 1:size(selectedPopIndex, 2)
            s = selectedPopIndex(i);        
            obj = NormalizedObj(find(combinePopIndex==s),:);
            
            for j = 1:opt.numdir
                w = opt.dirs(j,:);                                              
                d = norm(obj-((w*obj')*w)/(norm(w)*norm(w)));
                
                if d < distance(s)
                    tempPopDir(s) = j;
                    distance(s) = d;
                end
            end
            Count(tempPopDir(s)) = Count(tempPopDir(s))+1;

            %% Haitham - Start
            opt.pop2Dir(idx) = tempPopDir(s);
            opt.pop2DirDistances(idx) = distance(s);
            idx = idx + 1;
            % Haitham - End

        end
        
        %----------------for last front indices----------------------------
        DirLast = cell(opt.numdir,1);%collect the solutions those prefer this direction
        DirLastDist = cell(opt.numdir,1);%collect the distances
        tempPopDir = zeros(size(opt.totalpopObj, 1), 1);%for each solution save direction
        distance = zeros(size(opt.totalpopObj, 1), 1);%for each solution save distance of that direction
        distance(1:end) = intmax;
        
        for i = 1:size(lastPopIndex, 2)
            s = lastPopIndex(i);
            obj = NormalizedObj(find(combinePopIndex==s),:);%take normalized obj
            
            for j = 1:opt.numdir
                w = opt.dirs(j,:);
                d = norm(obj-((w*obj')*w)/(norm(w)*norm(w)));
                if d < distance(s)
                    tempPopDir(s) = j;
                    distance(s) = d;
                end
            end
            DirLast{tempPopDir(s)} = horzcat(DirLast{tempPopDir(s)}, s);
            DirLastDist{tempPopDir(s)} = horzcat(DirLastDist{tempPopDir(s)}, distance(s));
        end
        
        %-------------------NICHING PRESERVATION---------------------------
        
        for i = 1:opt.numdir
            [~, I] = sort(DirLastDist{i},'ascend');
            DirLast{i} = DirLast{i}(I);
        end
                                               
        while size(selectedPopIndex, 2)<opt.N

            [p_j, j]=min(Count);
            
            if isempty(DirLast{j})
                Count(j)=intmax; %excluded for further consideration              
            elseif p_j==0                
                selectedPopIndex = horzcat(selectedPopIndex, DirLast{j}(1));%choose the first
                
                %% Haitham - Start
                opt.pop2Dir(idx) = DirLast{j}(1);
                opt.pop2DirDistances(idx) = DirLastDist{j}(1);
                idx = idx + 1;
                % Haitham - End

                Count(j) = Count(j)+1;
                DirLast{j}(1) = [];

            else % when p_j>=1                
                index = randi(size(DirLast{j},2)); %chose randomly
                selectedPopIndex = horzcat(selectedPopIndex, DirLast{j}(index));

                %% Haitham - Start
                opt.pop2Dir(idx) = DirLast{j}(index);
                opt.pop2DirDistances(idx) = DirLastDist{j}(index);
                idx = idx + 1;
                % Haitham - End

                DirLast{j}(index) = [];
                Count(j) = Count(j)+1;                 

            end                                   
        end
        
        
    end%if size(FeasiblePopIndex,1)<opt.N           
    
    %---------------Select for Next Generation-----------------------------
    opt.pop =  opt.totalpop(selectedPopIndex,:);
    opt.popObj = opt.totalpopObj(selectedPopIndex,:);
    opt.popCV = opt.totalpopCV(selectedPopIndex,:);
    opt.popCons = opt.totalpopCons(selectedPopIndex,:);
            
end




































    
