%% gmmreg_L2_costfunc
%this function is pass in the options of optimization
% param contains the initial parameters of transformation
% config contains the parameters of configuration 

function [f,g] = gmmreg_L2_costfunc(param, config)
%%=====================================================================
%% $RCSfile: gmmreg_L2_costfunc.m,v $
%% $Author: bing.jian $
%% $Date: 2008-11-13 16:34:29 -0500 (Thu, 13 Nov 2008) $
%% $Revision: 109 $
%%=====================================================================

%get model, scene, motion, and scale
model = config.model;
scene = config.scene;
motion = config.motion;
scale = config.scale;

%transform the model with the initial parameters
[transformed_model] = transform_pointset(model, motion, param);

% the only motions are [rigid2D,3D and affine 2D,3D] tps no cover
%according to the motion
switch lower(config.motion)
    case 'rigid2d'
        %apply the gauss tranform to get grad and function
        [f, grad] = rigid_costfunc(transformed_model, scene, scale);
        grad = grad';
        %only get 2 parameters by translation 
        g(1) = sum(grad(1,:));
        g(2) = sum(grad(2,:));
        grad = grad*model; %update with traslation
        
        %the third param is the angle of rotation
        theta = param(3);
        r = [-sin(theta) -cos(theta);
             cos(theta)  -sin(theta)];
        g(3) = sum(sum(grad.*r)); %update with rotation matrix
    case 'rigid3d'
        %calculate gauss transform
       [f,grad] = rigid_costfunc(transformed_model, scene, scale);
       % calculate rotation with quaternion angle but transform in rotation
        [r,gq] = quaternion2rotation(param(1:4));
        grad = grad';
        gm = grad*model; %update with rotation
        
        %there are 4 parameters quaternion
        g(1) = sum(sum(gm.*gq{1}));
        g(2) = sum(sum(gm.*gq{2}));
        g(3) = sum(sum(gm.*gq{3}));
        g(4) = sum(sum(gm.*gq{4}));        
        
        %there are 3 parameteres of traslation
        g(5) = sum(grad(1,:));
        g(6) = sum(grad(2,:));
        g(7) = sum(grad(3,:));
        
    case 'affine2d'
        %calculate gauss transform
        [f,grad] = general_costfunc(transformed_model, scene, scale);
        grad = grad';
        %there are 2 parameters of traslation
        g(1) = sum(grad(1,:));
        g(2) = sum(grad(2,:));
        
        %the rest of paramteres are matriz affine
        g(3:6) = reshape(grad*model,1,4);
        
    case 'affine3d'
        [f,grad] = general_costfunc(transformed_model, scene, scale);
        grad = grad';
        
        %there 3 parameters of traslation
        g(1) = sum(grad(1,:));
        g(2) = sum(grad(2,:));
        g(3) = sum(grad(3,:));
        
        %there are 9 parameters of matrix affine
        g(4:12) = reshape(grad*model,1,9);
    otherwise
        error('Unknown motion type');
end;

%% GAUSS TRANSFORM FOR RIGID TRANSFORMATION
function [f, g] = rigid_costfunc(A, B, scale)
[f, g] =  GaussTransform(A,B,scale);
%get the negative value (?)
f = -f; g = -g;

%% GAUSS TRANSFORM FOR AFFINE TRANSFORMATION
function [f, g] = general_costfunc(A, B, scale)
%calculate gauss for AA and for AB
[f1, g1] = GaussTransform(A,A,scale);
[f2, g2] = GaussTransform(A,B,scale);

%% FUNCTION 
%the new f es f1 - 2*f2 (?)
f =  f1 - 2*f2;

%% GRADIENT
%the new g es 2*g1 - 2*g2 (?)
g = 2*g1 - 2*g2;