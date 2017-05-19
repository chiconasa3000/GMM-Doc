function V = calcLandO(landmO)
    dim = size(landmO,2);
    matZeros = zeros(dim,3);
    V = [landmO',matZeros];
end