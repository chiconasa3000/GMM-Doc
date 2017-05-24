
%
function [axis_limits] = determine_border(Model, Scene)
%%=====================================================================
%% Module:    $RCSfile: determine_border.m,v $
%% Language:  MATLAB
%% Author:    $Author: bing.jian $
%% Date:      $Date: 2008-11-13 16:34:29 -0500 (Thu, 13 Nov 2008) $
%% Version:   $Revision: 109 $
%%=====================================================================

dim = size(Scene,2); %we obtain the dimension of the scene
axis_limits = zeros(dim,2); %vacia matriz de ejes de dim*2

%first evaluate the first and after the second dimension
for i=1:dim
    %obtain min value coord of actual dimension betwen scene and model
    min_i = min([Scene(:,i);Model(:,i)]);
    %obtain max value coord of actual dimension betwen scene and model
    max_i = max([Scene(:,i);Model(:,i)]);
    %obtain the segment and scale with 0.05 factor (it will be tha margin)
    margin_i = (max_i-min_i)*0.05;
    %in each dimension puts the margin spaced (x segment and y segment)
    axis_limits(i,:) = [min_i - margin_i max_i+margin_i];
end