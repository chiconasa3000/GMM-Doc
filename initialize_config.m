%% Simulated File Configuration
%  this prepares the all data for config
% INPUT: model, scene and motion

function [config] = initialize_config(model, scene, motion)

config.model = model;
config.scene = scene;
config.motion = motion;

% estimate the scale from the covariance matrix
[n,d] = size(model);
config.scale = power(det(model'*model/n), 1/(2^d));
config.display = 1;
%params for other transformation
config.init_param = [ ];
config.max_iter = 1000;
config.normalize = 0;


switch lower(motion)
    %params for TPS Transformation
    case 'tps'
        interval = 5;
        %set control points with interval scene and model
        %because it needs the proportions inside of the model and
        %scene border.
        config.ctrl_pts =  set_ctrl_pts(model, scene, interval);
        
        %parameters alpha and beta
        config.alpha = 1;
        config.beta = 0;
        config.opt_affine = 0;
        [n,d] = size(config.ctrl_pts); % number of points in model set
        
        %initial parameters by default
        config.init_tps = zeros(n-d-1,d);
        init_affine = repmat([zeros(1,d) 1],1,d);
        
        %it combines tps and affine parameters
        config.init_param = [init_affine zeros(1, d*n-d*(d+1))];
        config.init_affine = [ ];
        
    %params for Other Transformations
    otherwise
        %set limits only put the motion
        %it uses limits by default to give the values to the Lu and Ub
        [x0,Lb,Ub] = set_bounds(motion);
        config.init_param = x0;
        config.Lb = Lb;
        config.Ub = Ub;
end

