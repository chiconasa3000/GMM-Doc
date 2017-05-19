function [b,a] = limpiarVectores(a,b)
k=1;
n=length(a);
while k <= n
    [x,posicion] = find(a==a(k));
    %la primera posicion es importante y nos la quedamos
    %quitando la posicion de ese primer elemento
    posicion(1) = [];
    %las demas posiciones del vector o las restantes las eliminamos
    a(posicion) = [];
    %las posiciones q no sirven tambien son eliminadas en su vector pareja
    b(posicion) = [];
    n=length(a); k = k+1;
end
% M = [a',b'];
% [B,k] = sort(M(:,1));
% B = [B M(k+n)];
% plot(B(:,1),B(:,2),'-bo');
% a = B(:,1)';
% b = B(:,2)';