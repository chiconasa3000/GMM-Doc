function L = calcMatrizL(matrizK,matrizP)
    dim = size(matrizP,2);
    L = [matrizK,matrizP];
    matzeros = zeros(dim,dim);
    L = [L;matrizP',matzeros]
end