function interpuntos(cantPtosTarget,matPtosOrigen)
x = matPtosOrigen(:,1)';
y = matPtosOrigen(:,2)';

[x,y] = points2contour(x,y,1,'cw');
%x=x(100:120);
%y=y(100:120);
nptosRayosX = [x',y'];
assignin ( 'base', 'nptosRayosX', nptosRayosX )
%plot(x,y,'-bo','markersize',3,'markerfacecolor','b')

[x,y] = limpiarVectores(y,x);

maxY = max(y);
minY = min(y);
cantPtosOrigen = size(matPtosOrigen,1);
cantPtosInter = cantPtosTarget - cantPtosOrigen;

salto = maxY/(cantPtosInter-1);
yy = minY:salto:maxY;
%xx = (maxX-minX).*rand(30,1) + minX;
xx=interp1(y,x,yy,'spline');
%[xx,yy] = points2contour(xx,yy,1,'cw');
%p=polyfit(x,y,3);
%yy=polyval(p,xx);
%plot(x,y,'o',xx,f);
plot(x,y,'bo','markersize',3,'markerfacecolor','b')
hold on
plot(xx,yy,'-ro','markersize',3,'markerfacecolor','r')
%disp([xx' yy']);
%hold on
%plot(x,y,'-bo','markersize',3,'markerfacecolor','b')
%plot(xx,yy,'ro','markersize',4,'markerfacecolor','r')
%xlabel('x')
%ylabel('y')
%grid on
%title('Interpolación lineal');
%hold off
%ordenando
%X = [x,xx];
%Y = [y,yy];
%M = [X',Y']
%[B,k] = sort(M(:,1));
%B = [B M(k+15)]
%plot(B(:,1),B(:,2),'-bo');
