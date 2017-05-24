%% AFFINE 2D (2 traslation, 4 affine)
% [result] = transform_by_affine2d(pointset, param)
% perform a 2D affine transform on a pointset and
% return the transformed pointset
% the param is expected in the order of 
%  [tx ty a11 a21 a12 a22] or
%  [tx a11 a12 ]
%  [ty a21 a22 ]
%
% See also: transform_by_affine3d, transform_by_rigid2d
function [result] = transform_by_affine2d(pointset, param)
%%=====================================================================
%% $RCSfile: transform_by_affine2d.m,v $
%% $Author: bing.jian $
%% $Date: 2008-11-13 16:34:29 -0500 (Thu, 13 Nov 2008) $
%% $Revision: 109 $
%%=====================================================================

%size of landmarks
n = size(pointset,1);
%affine matrix with initial params
A = reshape(param,2,3);   A = A';
%transform the pointset with the params 
%ojo add vector of ones
result =  [ones(n,1)  pointset(:,1:2)]*A;


