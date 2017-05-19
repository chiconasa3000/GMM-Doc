function P = calcMatrizP(landmI)
    [numPtos,dim] = size(landmI);
    vunos = ones(numPtos,1);
    P = [vunos,landmI];
end
