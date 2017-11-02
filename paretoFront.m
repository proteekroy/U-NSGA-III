function index = paretoFront(FeasibleObj)

    [R,~] = bos(FeasibleObj);
    index = find(R==1);

end