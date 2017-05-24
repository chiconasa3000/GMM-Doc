% Perform a spatial tranformation on a given pointset
% motion:  the motion model represented by string, can be
%         'rigid2d',    'rigid3d', 'affine2d',  'affine3d', 'tps'
% parameter: a row vector of params of transformation
function [transformed_pointset] = transform_pointset(pointset, motion, parameter, varargin)
%%=====================================================================
%% $RCSfile: transform_pointset.m,v $
%% $Author: bing.jian $
%% $Date: 2008-11-13 16:34:29 -0500 (Thu, 13 Nov 2008) $
%% $Revision: 109 $
%%=====================================================================

%according to the motion update the model with the correct transformation
switch lower(motion)
    case 'rigid2d'
        transformed_pointset = transform_by_rigid2d(pointset, parameter);
    case 'rigid3d'
        transformed_pointset = transform_by_rigid3d(pointset, parameter);
    case 'affine2d'
        transformed_pointset = transform_by_affine2d(pointset, parameter);
    case 'affine3d'
        transformed_pointset = transform_by_affine3d(pointset, parameter);
    case 'tps'
        %control points
        ctrl_pts = varargin{1};
        %size of control points
        [n,d] = size(ctrl_pts);
        
        %initial affine matrix
        init_affine = varargin{2};
        %union of param tps and affine matrix
        miparam = [init_affine parameter];
        
        %files and columns of size of general param (?)
        [mipf,mipc] = size(miparam) 
        
        %adapt parameters according to the size of control points
        p = reshape([init_affine parameter],d,n); 
        %files and columns of adapt parameters (?)
        [pf,pc] = size(p)
        p = p'; 
        
        %adapt the pointset with control points and adapt parameters
        transformed_pointset = transform_by_tps(p, pointset, ctrl_pts);
    otherwise
        error('Unknown motion type');
end;


