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
% Proteek Chandan Roy, 2017
% Contact: royprote@msu.edu, proteek_buet@yahoo.com

function [f,g] = high_fidelity_evaluation(opt,x)

    
    problem = lower(opt.objfunction);
    g = [];
    switch(problem)
        case 'zdt1'
            n=size(x,2);
            a(1)=x(1);
            b=9/(n-1);
            y=0;
            for i=2:n
                y=y+x(i);
            end
            b=b*y;
            a(2)=1+b;    
            a(3)=1- sqrt(a(1)/a(2));
            f(1)=a(1);
            f(2)=a(2)*a(3);
        case 'zdt2' 
            n=size(x,2);
            a(1)=x(1);
            b=9/(n-1);
            y=0;
            for i=2:n
                y=y+x(i);
            end
            b=b*y;
            a(2)=1+b;    
            a(3)=1- power(a(1)/a(2),2);
            f(1)=a(1);
            f(2)=a(2)*a(3);
        case 'zdt3'
            n=size(x,2);
            a(1)=x(1);
            b=9/(n-1);
            y=0;
            for i=2:n
                y=y+x(i);
            end
            b=b*y;
            a(2)=1+b;    
            a(3)=1- sqrt(a(1)/a(2)) - (a(1)/a(2))*sin(10*pi*a(1));
            f(1)=a(1);
            f(2)=a(2)*a(3);

        case 'zdt4'
            n=size(x,2);
            a(1)=x(1);
            y=0;
            for i=2:n
                y=y+power(x(i),2)-10*cos(4*pi*x(i));
            end
            a(2)=1+10*(n-1)+y;    
            a(3)=1- sqrt(a(1)/a(2));
            f(1)=a(1);
            f(2)=a(2)*a(3);
        case 'zdt6'
            n=size(x,2);
            a(1)=1- exp(-4*x(1))*power(sin(6*pi*x(1)),6);
            y=0;
            for i=2:n
                y=y+x(i)/9;
            end
            b=9*power(y,0.25);
            a(2)=1+b;    
            a(3)=1- power(a(1)/a(2),2);
            f(1)=a(1);
            f(2)=a(2)*a(3);
            
        case 'dtlz1'
            n=size(x,2);
            g = 0;
            nfunc = opt.M;
            k = n - nfunc + 1;
            
            for i = nfunc:n
                g = g + power(( x(i)-0.5),2) - cos(20 * 3.141592654 * ( x(i)-0.5));
            end

            g = 100 * (k + g);
            for i = 1:nfunc
                fit = 0.5 * (1 + g);
                for j = nfunc - i:-1:1
                    fit = fit * x(j);
                end
                if i > 1
                    fit = fit * (1 -  x(nfunc - i + 1));
                end
                f(i) = fit;
            end
            
        case 'c1dtlz1'
            n=size(x,2);
            g = 0;
            nfunc = opt.M;
            k = n - nfunc + 1;
            
            for i = nfunc:n
                g = g + power(( x(i)-0.5),2) - cos(20 * 3.141592654 * ( x(i)-0.5));
            end

            g = 100 * (k + g);
            
            for i = 1:nfunc
                fit = 0.5 * (1 + g);
                for j = nfunc - i:-1:1
                    fit = fit * x(j);
                end
                if i > 1
                    fit = fit * (1 -  x(nfunc - i + 1));
                end
                f(i) = fit;
            end
            
            %now calculate constraints
            c = 1.0 - f(nfunc) / 0.6;
		
            for i = 1: nfunc-1
                c = c - f(i) / 0.5;
            end
		
            g = [];
            if(c>=0)
                g(1) = 0;
            else
                g(1) = c;
            end
            g(1) = -g(1);
        
        
        case 'dtlz2'
            n=size(x,2);
            nfunc = opt.M;
            k = n - nfunc + 1;
            g = 0;

            for i = nfunc:n
                g = g + power( x(i)-0.5,2);
            end

            f = zeros(1,nfunc);
            for i = 1:nfunc
                h = 1 + g;
                for j=1:nfunc - i
                    h =h * cos( x(j) * 3.141592654 / 2);
                end
                if (i > 1)
                    h = h*sin( x((nfunc - i + 1)) * 3.141592654 / 2);
                end
                f(i) = h;
            end

            
        case 'c2dtlz2'
            
            n=size(x,2);
            nfunc = opt.M;
            k = n - nfunc + 1;
            g = 0;

            for i = nfunc:n
                g = g + power( x(i)-0.5,2);
            end

            fit = zeros(1,nfunc);
            for i = 1:nfunc
                h = 1 + g;
                for j=1:nfunc - i
                    h =h * cos( x(j) * 3.141592654 / 2);
                end
                if (i > 1)
                    h = h*sin( x((nfunc - i + 1)) * 3.141592654 / 2);
                end
                fit(i) = h;
            end

            f(1) = fit(1);
            f(2) = fit(2);
            f(3) = fit(3);
            
            %now calculate constraints
            if(nfunc>3)
                r = 0.5;
            else
                r = 0.4;
            end
            v1 = realmax;
            v2 = 0.0;

            for i = 1: nfunc 
                sum1 = power(f(i)-1.0, 2.0);

                for j = 1: nfunc 
                    if i ~= j 
                        sum1 = sum1 + power(f(j), 2.0);
                    end
                end

                v1 = min(v1, sum1 - power(r, 2.0));
                v2 = v2 + power(f(i) -  (1.0 / sqrt(nfunc)), 2.0);
            end

            c = min(v1, v2 - power(r, 2.0));
            
            g = [];
            if(c<=0)
                g(1) = c;
            else
                g(1) = c;
            end
            
        case 'c3dtlz2'
            
            n = length(x);
            xg=x(3:n);
            gx=sum((xg-0.5).^2);
            f(1)=(1+gx)*cos(x(1)*0.5*pi)*cos(x(2)*0.5*pi);
            f(2)=(1+gx)*cos(x(1)*0.5*pi)*sin(x(2)*0.5*pi);
            f(3)=(1+gx)*sin(x(1)*0.5*pi);

            g(1) = f(1)^2/4 + f(2)^2 + f(3)^2 - 1;
            g(2) = f(2)^2/4 + f(1)^2 + f(3)^2 - 1;
            g(3) = f(3)^2/4 + f(1)^2 + f(2)^2 - 1;
            
        case 'dtlz3'
            
            x = x';
            k = 10;
            M = opt.M;
            % Error check: the number of dimensions must be M-1+k
            n = opt.V;%(M-1) + k; %this is the default
            if size(x,1) ~= n
               error(['Using k = 10, it is required that the number of dimensions be'...
               ' n = (M - 1) + k = %d in this case.'], n)
            end

            xm = x(n-k+1:end,:); %xm contains the last k variables
            g = 100*(k + sum((xm - 0.5).^2 - cos(20*pi*(xm - 0.5)),1));

            % Computes the functions
            f(1,:) = (1 + g).*prod(cos(pi/2*x(1:M-1,:)),1);
            for ii = 2:M-1
               f(ii,:) = (1 + g) .* prod(cos(pi/2*x(1:M-ii,:)),1) .* ...
                  sin(pi/2*x(M-ii+1,:));
            end
            f(M,:) = (1 + g).*sin(pi/2*x(1,:));           
           
        case 'dtlz4'
            n=size(x,2);
            nfunc = opt.M;
            k = n - nfunc + 1;
            g = 0;
            
            alpha = 100;
            for i = nfunc:n
                g = g + power( x(i)-0.5,2);
            end
            f = zeros(1,nfunc);
            for i = 1:nfunc
                h = 1 + g;
                for j=1:nfunc - i
                    h = h * cos(power( x(j),alpha) * 3.141592654 / 2);
                end
                if (i > 1)
                    h = h*sin(power( x((nfunc - i + 1)),alpha) * 3.141592654 / 2);
                end
                f(i) = h;
            end

            
        case 'dtlz5'
            
            n=size(x,2);
            nfunc = opt.M;
            g = 0;
            k = n - nfunc + 1;
            for i = nfunc:n
                g = g + power( x(i)-0.5,2);
            end

            t = 3.141592654 / (4 * (1 + g));
            theta=[];
            theta(1) =  x(1) * 3.141592654 / 2;
            for i = 2: nfunc - 1
                theta(i) = t * (1 + 2 * g *  x(i));
            end
            f = [];
            for i = 1:nfunc
                h = 1 + g;
                for j=1:nfunc - i
                    h =h * cos(theta(j));
                end
                if (i > 1)
                    h = h*sin(theta((nfunc - i + 1)));
                end
                f(i) = h;
            end
            
        case 'dtlz7'
            n=size(x,2);
            nfunc = opt.M;
            k = n - nfunc + 1;
            
            g = sum(x(nfunc:n));
            g = 1 + 9 * g / k;


            for i = 1:nfunc-1
                f(i)=x(i);
            end
            h2=0;
            for j = 1:nfunc-1
               h2 =h2 +  x(j) / (1 + g) * (1 + sin(3 * 3.141592654 *  x(j))); 
            end

            h2 = nfunc - h2;
            f(nfunc) = (1 + g) * h2;

        
        case 'bnh'  
            f(1) = 4*x(1)^2+4*x(2)^2;
            f(2) = (x(1)-5)^2+(x(2)-5)^2;
            g(1) = (1/25)*((x(1)-5)^2 + x(2)^2-25);   
            g(2) = -1/7.7*((x(1)-8)^2 + (x(2)+3)^2-7.7);
        case 'osy'
            f(1) = -(25*(x(1)-2)^2+(x(2)-2)^2+(x(3)-1)^2+(x(4)-4)^2+(x(5)-1)^2);
            f(2) = x(1)^2+x(2)^2+x(3)^2+x(4)^2+x(5)^2+x(6)^2;
            g(1) = (-1/2)*(x(1)+x(2)-2);
            g(2) = (-1/6)*(6-x(1)-x(2));
            g(3) = (-1/2)*(2-x(2)+x(1));
            g(4) = (-1/2)*(2-x(1)+3*x(2));
            g(5) = (-1/4)*(4-(x(3)-3)^2 -x(4));
            g(6) = (-1/4)*((x(5)-3)^2+x(6)-4);
        case 'srn'
            f(1) = 2.0+(x(1)-2.0)^2+(x(2)-1.0)^2;
            f(2) = 9.0*x(1)-(x(2)-1)^2;
            g(1) = (1/225)*(x(1)^2+x(2)^2-225.0);
            g(2) = 0.1*(x(1)-3.0*x(2)+10.0);
        case 'tnk'
            f(1) = x(1);
            f(2) = x(2);
            g(1) = (-1)*(x(1)^2+x(2)^2-1.0-0.1*cos(16*atan(x(1)/x(2))));
            g(2) = (1/0.5)*((x(1)-0.5)^2+(x(2)-0.5)^2-0.5);
        case 'water'
            f(1) = (106780.37 * (x(2) + x(3)) + 61704.67)/(8 * power(10, 4));
			f(2) = (3000.0 * x(1))/1500;
			f(3) = ((305700 * 2289*x(2))/power(0.06 * 2289.0,0.65))/(3 * power(10, 6));
			f(4) = (250.0 * 2289.0 * exp(-39.75*x(2) + 9.9*x(3) + 2.74))/(6*power(10, 6));
			f(5) = (25.0*((1.39/(x(1)*x(2))) + 4940.0*x(3) - 80.0))/8000;
			g(1) = (0.00139/(x(1)*x(2)) + 4.94*x(3) - 0.08 - 1)/13.314;
			g(2) = (0.000306/(x(1)*x(2)) + 1.082*x(3) - 0.0986 - 1)/2.0696;
			g(3) = (12.307/(x(1)*x(2)) + 49408.24*x(3) + 4051.02 - 50000)/82061.844;
			g(4) = (2.098/(x(1)*x(2)) + 8046.33*x(3) - 696.71 - 16000)/5087.923;
			g(5) = (2.138/(x(1)*x(2)) + 7883.39*x(3) - 705.04 - 10000)/11463.299;
			g(6) = (0.417*(x(1)*x(2)) + 1721.26*x(3) - 136.54 - 2000)/1.0; %this is always feasible
			g(7) = (0.164/(x(1)*x(2)) + 631.13*x(3) - 54.48 - 550)/1098.633;
		case 'carside'
            
            g(1) = 1.16 - 0.3717 *x(2)*x(4)- 0.0092928 *x(3);
            g(2) = 0.261 - 0.0159 * x(1) *x(2)- 0.188 *x(1)* 0.345 - 0.019 *x(2)*x(7) + 0.0144*x(3)*x(5)+ 0.08045 *x(6)* 0.192;
            g(3) = 0.214 + 0.00817 *x(5)- 0.131 * x(1) * 0.345 - 0.0704 * x(1) * 0.192 + 0.03099*x(2)*x(6)- 0.018 *x(2)*x(7)+ 0.0208 *x(3)* 0.345 + 0.121 *x(3)* 0.192 - 0.00364*x(5)*x(6)- 0.018 *x(2)^2;
            g(4) = 0.74 - 0.61 *x(2) - 0.031296 *x(3)- 0.166 *x(7)* 0.192 + 0.227 *x(2)^2;
            g(5) = 28.98 + 3.818 *x(3)- 4.2 * x(1)*x(2)+ 6.63 *x(6)* 0.192 - 7.77 *x(7)* 0.345;
            g(6) = 33.86 + 2.95 *x(3)- 5.057 * x(1) *x(2)- 11 *x(2)* 0.345 - 9.98 *x(7)* 0.345 +22 * 0.345 * 0.192;
            g(7) = 46.36 - 9.9 *x(2)- 12.9 * x(1) * 0.345;
            g(8) = 4.72 - 0.5 *x(4)- 0.19 *x(2)*x(3);
            g(9) = 10.58 - 0.674 * x(1)*x(2)- 1.95 *x(2)* 0.345;
            g(10) = 16.45 - 0.489 *x(3)*x(7)- 0.843 *x(5)*x(6);

 

            f(1) = 1.98 + 4.9 *x(1)+ 6.67 *x(2)+ 6.98 *x(3)+ 4.01 *x(4) + 1.78 *x(5)+ 0.00001*x(6)+ 2.73 *x(7);
            f(2) = g(8);
            f(3) = (g(9) + g(10)) / 2.0;
            g(1)=- 1 + g(1) / 1.0;
            g(2)= -1 + g(2) / 0.32;
            g(3)= -1 + g(3) / 0.32;
            g(4)= -1 + g(4) / 0.32;
            g(5)= -1 + g(5) / 32.0;
            g(6)= -1 +g(6)/ 32.0;
            g(7)= -1 + g(7)/ 32.0;
            g(8)= -1 + g(8)/ 4.0;
            g(9)= -1 + g(9)/ 9.9;
            g(10)= -1 + g(10)/ 15.7;
               
        case 'welded'
            
            f(1) = 1.10471*x(1)^2*x(2)+0.04811*x(3)*x(4)*(14.0+x(2));
            f(2) = 2.1952/(x(4)*x(3)^3);

            P = 6000; L = 14; t_max = 13600; s_max = 30000;

            R = sqrt(0.25*(x(2)^2+(x(1)+x(3))^2));

            M = P*(L+x(2)/2);

            J = 2*sqrt(0.5)*x(1)*x(2)*(x(2)^2/12 +0.25*(x(1)+x(3))^2);

            t1 = P/(sqrt(2)*x(1)*x(2));

            t2 = M*R/J;

            t = sqrt(t1^2+t2^2+t1*t2*x(2)/R);

            s = 6*P*L/(x(4)*x(3)^2);

            P_c = 64746.022*(1-0.0282346*x(3))* x(3)*x(4)^3;

        	% Constraints

            g(1) = (1/t_max)*(t - t_max);

            g(2) = (1/s_max)*(s - s_max);

            g(3) = (1/(5-0.125))*(x(1)-x(4));

            g(4) = (1/P)*(P-P_c);

        case 'do2dk'
            f = do2dk(x, opt.num_Knee, opt.knee_s);
        case 'do2dk1'
            f = do2dk1(x, opt.num_Knee, opt.knee_s);
        case 'deb2dk'
            f = deb2dk(x, opt.num_Knee);
        case 'deb2dk1'
            f = deb2dk1(x, opt.num_Knee); 
        case 'deb3dk'
            f = deb3dk(x, opt.num_Knee);
        case 'deb3dk1'
            f = deb3dk1(x, opt.num_Knee);
        case 'uf1'
            f = UF1(x')';
        case 'uf2'
            f = UF2(x')';
        case 'uf3'
            f = UF3(x')';
        case 'uf4'
            f = UF4(x')';
        case 'uf5'
            f = UF5(x')';
        case 'uf6'
            f = UF6(x')';
        case 'uf7'
            f = UF7(x')';
        case 'uf8'
            f = UF8(x')';
        case 'uf9'
            f = UF9(x')';
        otherwise
            input('Function defition is not found inside high fidelity evaluation');
    end
    
    %for unconstraint problem
    if opt.C==0
       g = []; 
    end
end