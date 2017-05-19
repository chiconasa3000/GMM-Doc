%% Funcion Fundamental de Ecuacion Biharmonica
% Funcion z(x,y) =  (-r^2)*ln(r^2) = U(r)
%%
function U = funcU(r)
    if r == 0
        U = 0;
    else
        U = r^2*log(r^2);
    end
end

