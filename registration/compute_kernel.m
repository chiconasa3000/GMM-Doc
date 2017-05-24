%% compute the kernel and basis matrix for thin-plate splines
%% reference:  Landmark-based Image Analysis, Karl Rohr, p195
% INPUT: control points, landmarks, and a parameter lambda
function [K,U] = compute_kernel(ctrl_pts,landmarks, lambda)
%%=====================================================================
%% $RCSfile: compute_kernel.m,v $
%% $Author: bing.jian $
%% $Date: 2008-11-30 18:09:59 -0500 (Sun, 30 Nov 2008) $
%% $Revision: 116 $
%%=====================================================================

%get the size of control points
[n,d] = size(ctrl_pts);
if (nargin<3)
    lambda = 0;
end


%K = zeros(n);
% initialize the kernel with parameter lambda
K = lambda*ones(n); %% K only depends on ctrl_pts and lambda

%according to control point's dimension
switch d
  case 2
    for i=1:n
        for j=1:n
            %calculamos la distancia entre todos los pares de puntos
            r = norm(ctrl_pts(i,1:2) - ctrl_pts(j,1:2));
            %en caso de ser distancia positiva calculamos ecuacion
            %biharmonica. (funcion de suavidad)
            if (r>0)
                    K(i,j) =   r*r*log(r);
            end
        end
    end
  case 3
    for i=1:n
        for j=1:n
            %calculamos la distancia
            r = norm(ctrl_pts(i,1:3) - ctrl_pts(j,1:3));
            %para esto solo sacamos el negativo de la distancia (?)
            K(i,j) =   -r;
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (nargin>=2)
    
    %calculate each landmark's size
    [m,d] = size(landmarks);
    %U = zeros(m,n);
    
    % initialize the basis matrix with parameter lambda
    U = lambda*ones(m,n);
    
    %according  to the dimension
    switch d
        case 2
            for i=1:m
                for j=1:n
                    %calculate distance between landmarks and control point
                    r = norm(landmarks(i,1:2) - ctrl_pts(j,1:2));
                    %put this value in the smooth function
                    if (r>0)
                        U(i,j) =   r*r*log(r);
                    end
                end
            end
        case 3
            for i=1:m
                for j=1:n
                    %calculate the same distance but in 3 dimensions
                    r = norm(landmarks(i,1:3) - ctrl_pts(j,1:3));
                    %take only the negative value of r (?)
                    U(i,j) =   -r;
                end
            end
    end
end

