%% Matriz que calcula las funciones K
%   la matriz es de n*n y contiene todas las funciones biharmonicas
%   de los landmarks iniciales
%%
function K = calcMatrizK(landmI)
    
    %formamos una matriz con la combinacion de puntos
    [numPtos,dim] = size(landmI);
    
    K = zeros(numPtos,dim);
    
    for i=1:1:numPtos
        for j=1:1:numPtos
            K(i,j) = funcU(calcRad(landmI(i,:),landmI(j,:)));
        end
    end
    
end
