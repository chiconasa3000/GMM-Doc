%% Perform thin-plate spline warping
%% Input:
%%       landmarks:   source pts stored in nxd matrix.  
%%       parameters:  parameters in nxd matrix where first (d+1) rows are
%%       affine parameters corresponding to <1,x,y>
%% Output:
%%       warped_pts:  target pts in nxd matrix
%%       energy:      bending energy

function [warped_pts, bending_energy] = transform_by_tps(param, landmarks, ctrl_pts)
%%=====================================================================
%% $RCSfile: transform_by_tps.m,v $
%% $Author: bing.jian $
%% $Date: 2008-11-30 18:09:59 -0500 (Sun, 30 Nov 2008) $
%% $Revision: 116 $
%%=====================================================================

%in case of 2 dimensions

if (nargin==2)
    %size of landmarks
    [n,d] = size(landmarks);
    
    %compute basis matrix 'U' with landmarks
    [B,lambda] = compute_basis(landmarks);
    
    %applied the params to obtain point deformed (warped points)
    warped_pts = B*param;
    
    %params of tps
    tps_param = param(d+2:n,:);
    
    %energy of deformation  it get only part (trace of entire matrix)
    %with tps_params
    bending_energy = trace(tps_param'*diag(lambda)*tps_param);
    
else
    %in case it contains CONTROL POINTS
    [m,d] = size(landmarks);
    [n,d] = size(ctrl_pts);
    
    %compute kernel and basis matrix with control points and landmarks
    [K,U] = compute_kernel(ctrl_pts,landmarks);
    
    % P with m landmarks
    Pm = [ones(m,1) landmarks];
    % P with n control points
    Pn = [ones(n,1) ctrl_pts];
    
    %PP basis ortogonal*basis matrix add the landmarks
    % is the matriz B
    PP = null(Pn'); B = [Pm U*PP]; 
    
    %matrix B with params obtain the landmarks deformed
    warped_pts = B*param;
    
    %obtain the tps_param
    tps_param = param(d+2:n,:);
    
    % basis general * Kernel * basis general and tps param
    % energy of deformation.
    bending_energy = trace(tps_param'*PP'*K*PP*tps_param);
end

