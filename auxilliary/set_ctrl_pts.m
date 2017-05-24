%% function [ctrl_pts] = set_ctrl_pts(M,S,interval)
%it computes control point with model, scene and interval betwen control
%points
function [ctrl_pts] = set_ctrl_pts(M,S,interval)
%%=====================================================================
%% Project:   Point Set Registration using Gaussian Mixture Model
%% Module:    $RCSfile: set_ctrl_pts.m,v $
%% Language:  MATLAB
%% Author:    $Author: bing.jian $
%% Date:      $Date: 2008-11-13 16:34:29 -0500 (Thu, 13 Nov 2008) $
%% Version:   $Revision: 109 $
%%=====================================================================

%it evaluate the size of the axis acoord to the space on model and scene
[axis_limits] = determine_border(M, S);

%obtain the min an max on each axis (X,Y)
x_min = axis_limits(1,1);
x_max = axis_limits(1,2);
y_min = axis_limits(2,1);
y_max = axis_limits(2,2);

%in case we don't have the interval
%the default interval will be 5
if (nargin<3)
    interval = 5;
end

[m,d] = size(M);

%in case of 2 dimensions
if (d==2)
    %very similar to meshgrid function but it uses a separation between 2
    %values the min and max value. Netherless it fills with the numbers
    %gaved
    [x,y] = ndgrid(linspace(x_min,x_max,interval), linspace(y_min,y_max,interval));
    n_pts = interval*interval; %number of points accord to the interval
    ctrl_pts = [reshape(x,n_pts,1) reshape(y,n_pts,1)]; %final control points
    
end

%in case of 3 dimensions
if (d==3)
    z_min = axis_limits(3,1);
    z_max = axis_limits(3,2);
    [x,y,z] = ndgrid(linspace(x_min,x_max,interval), linspace(y_min,y_max,interval),linspace(z_min,z_max,interval));
    n_pts = interval*interval*interval; %number of points accord to the interval
    ctrl_pts = [reshape(x,n_pts,1) reshape(y,n_pts,1) reshape(z,n_pts,1)]; %final control points
end

%plot(ctrl_pts(:,1),ctrl_pts(:,2),'r*');
