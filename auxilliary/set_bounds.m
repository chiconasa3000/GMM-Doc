% prepare the parameters for optimization 
function [x0, Lb, Ub] = set_bounds(motion)
%%=====================================================================
%% $RCSfile: set_bounds.m,v $
%% $Author: bing.jian $
%% $Date: 2008-11-13 16:34:29 -0500 (Thu, 13 Nov 2008) $
%% $Revision: 109 $
%%=====================================================================

%there exist 4 types of transformation (rigid2D, rigid3D, affine2D, affine3D)
switch lower(motion)
    %in case a rigid transformation en 2 dimensions
    case 'rigid2d'
        %parameters of transformation
        x0 = [0,0,0];    %[ translation_x, translation_y,  rotation_theta]
        
        %with limits we defines Lb and Ub  terms for factorization
        %and it carries DTHETA
        MAX_DX = 80;  MAX_DY = 80;   MAX_DTHETA = pi;
        MIN_DX = -80;  MIN_DY = -80;   MIN_DTHETA = -pi;
        %column vector
        Lb = [MIN_DX; MIN_DY; MIN_DTHETA];
        Ub = [MAX_DX; MAX_DY; MAX_DTHETA];
        
    %in case a rigid transformation in 3 dimensions
    case 'rigid3d'     %[unit quaternion,  translation_xyz] 
       %parameters of rigid 3d
       x0 = [0,0,0, 1, 0, 0, 0];
       %parameters for Lu and Ub
       MAX_DX = 40;
       MAX_DY = 40;
       MAX_DZ = 40;
       MIN_DX = -40;
       MIN_DY = -40;
       MIN_DZ = -40;
       %column vector
       Lb = [-1 ; -1; -1; -1; MIN_DX; MIN_DY; MIN_DZ;];
       Ub = [1 ; 1; 1; 1; MAX_DX; MAX_DY; MAX_DZ;];
       
    %in case of affine transformation in 2 dimensions
    case 'affine2d'
        %parameters of affine 2D
        d = 2;
        x0 = repmat([zeros(1,d) 1],1,d);  %[translation_xy, reshape(eye(2),1,4)]
        
        %limits for Lb and Ub 2D in this case it carries inf
        MAX_DX = 40;
        MAX_DY = 40;
        MIN_DX = -40;
        MIN_DY = -40;
        Lb = [MIN_DX; MIN_DY; -inf; -inf; -inf; -inf];
        Ub = [MAX_DX; MAX_DY; inf; inf; inf; inf];
        
    %in case of affine transformation in 3 dimensions
    case 'affine3d'
        %params for affine 3D
        d = 3;
        x0 = repmat([zeros(1,d) 1],1,d);  %[translation_xyz, reshape(eye(3),1,9)]
        
        %limits for Lb and Ub with infs in below rows
        MAX_DX = 100;
        MAX_DY = 100;
        MAX_DZ = 100;
        MIN_DX = -100;
        MIN_DY = -100;
        MIN_DZ = -100;
        Lb = [MIN_DX; MIN_DY; MIN_DZ; 0; -inf; -inf; -inf; 0; -inf; -inf; -inf; 0];
        Ub = [MAX_DX; MAX_DY; MAX_DZ; inf; inf; inf; inf; inf; inf; inf; inf; inf];
    otherwise
        error('Unknown motion type');
end;


