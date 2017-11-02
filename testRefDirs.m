objCount = 3;
pointCount = 9;
D = initweight(objCount, pointCount)'
if objCount == 2
    scatter(D(:,1), D(:,2));
elseif objCount == 3
    scatter3(D(:,1), D(:,2), D(:,3));
end