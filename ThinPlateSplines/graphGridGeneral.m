function graphGridGeneral()
%     x = 1:20;
%     y = 20:40;
%     nuevox = (x).^2; %X2
%     nuevoy = (y).^2; %Y2
%     [X,Y] = meshgrid(nuevox, nuevoy);
%     Z = (X+Y).*log(X+Y); %r2*log(r2)
%     surf(Z);

% [X,Y] = meshgrid(-8:.5:8);
% R = sqrt(X.^2 + Y.^2);
% Z = -R.^2*log(R.^2);
% figure
% mesh(Z)

% x=-10:0.1:10;
% y=x;
% z=x.^2+y.^2;
% [x,y]=meshgrid(x,y);
% plot3(x,y,z)

% r=4; % radius
% h=3; % height
% n=20; m=20; % grid spacing
% [x,y]=cylinder(linspace(0,r,n),m);
% z=sqrt(r^2+x.^2+y.^2);
% figure(6)
% mesh(x,y,z*h/sqrt(2)/r); hold on
% mesh(x,y,-z*h/sqrt(2)/r); hold off
% title('Hyperboloid')
% axis equal 

r=2; % radius
h=1; % height
n=20; m=20; % grid spacing
[x,y]=cylinder(linspace(0,r,n),m);
z=-(x.^2+y.^2);
figure(5)
mesh(x,y,z*h/r^2)
title('Paraboloid')
axis equal

% r1=1; r2=2; % radii
% h=3; % height
% n=20; m=20; % grid spacing
% [x,y,z]=cylinder(linspace(r1,r2,n),m);
% figure(4)
% mesh(x,y,z*h)
% title('Frustum of Cone')
% axis equal

% r=2; % radius
% h=4; % height
% n=20; m=20; % grid spacing
% [x,y,z]=cylinder(r*ones(1,n),m);
% figure(3)
% mesh(x,y,z*h)
% title('Cylinder')
% axis equal

% r=2; n=20;
% [x,y,z]=sphere(n);
% figure(2)
% mesh(r*x,r*y,r*z)
% title('Sphere')
% axis equal

% r=2; % radius
% n=20; m=20; % grid spacing
% [x,y]=cylinder(linspace(0,r,n),m);
% z=real(sqrt(r^2-x.^2-y.^2));
% figure(1)
% mesh(x,y,z); hold on
% mesh(x,y,-z); hold off
% title('Sphere')
%  axis equal

end