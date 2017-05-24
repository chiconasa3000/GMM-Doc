%% function [param, transformed_model, history, config] = gmmreg_L2(config)
%% OUTPUT
% param are the parameters calculated
% transformed_model is the model already transformed
% history is the progress on the registration
% config is updated parameters about the the config file
%% INPUT 
% config is the initial file configuration's parameters

function [param, transformed_model, history, config] = gmmreg_L2(config)
%%=====================================================================
%% $Author: bing.jian $
%% $Date: 2009-02-10 02:13:49 -0500 (Tue, 10 Feb 2009) $
%% $Revision: 121 $
%%=====================================================================

% Set up shared variables with OUTFUN
history.x = [ ];
history.fval = [ ];

%you should use the function "initialize_config.m" and pass like argument
if nargin<1
    error('Usage: gmmreg_L2(config)');
end

% number of points and dimensions in model set
[n,d] = size(config.model);

% the unique dimensions are two and three dimensions
if (d~=2)&&(d~=3)
    error('The current program only deals with 2D or 3D point sets.');
end

%% Prepare the optimization's options
% Show iterations, use largescale, use gradient on objective function,
% tolerance of function, constraint and x value minus of 0.0..10
options = optimset( 'display','iter', 'LargeScale','on','GradObj','on', 'TolFun',1e-010, 'TolX',1e-010, 'TolCon', 1e-10);
%function which determines the end of optimization
options = optimset(options, 'outputfcn',@outfun);
%number of iterations
options = optimset(options, 'MaxFunEvals', config.max_iter);


tic
%% We choose between TPS transformation and other kind of transformations
switch lower(config.motion)
    %% TPS Transformation
    case 'tps'
        scene = config.scene; % scene
        scale = config.scale;
        %they are the parameters of transformation that method will return
        alpha = config.alpha; %initial param alfa
        beta = config.beta; %initial param beta
        
        [n,d] = size(config.ctrl_pts); % control points
        [m,d] = size(config.model); % model
        
        % we use control points and landmarks in order to find kernel
        [K,U] = compute_kernel(config.ctrl_pts, config.model);
        
        %Pm Pn PP are modified landmarks and control points
        Pm = [ones(m,1) config.model];
        Pn = [ones(n,1) config.ctrl_pts];
        
        %It get a basis ortonormal of Modified control points
        %because it helps to resolve a matrix system
        PP = null(Pn');  % or use qr(Pn)
        
        basis = [Pm U*PP]; % final basis ortonormal it combines (control points and landmarks)
        kernel = PP'*K*PP; % kernel combines (kernel and control points)
        
        %the initial parameters of tps (no rigid)
        init_tps = config.init_tps;  % it should always be of size d*(n-d-1)
        
        % in case the affine params is empty it prepare with default
        % parameters
        if isempty(config.init_affine)
            % for your convenience, [] implies default affine
            config.init_affine = repmat([zeros(1,d) 1],1,d);
        end
        
        
        %% in case the affine option is turned on or off
        % optimize both affine and tps
        if config.opt_affine 
            init_affine = [ ];
            x0 = [config.init_affine init_tps(end+1-d*(n-d-1):end)];
        % optimize tps only
        else 
            init_affine = config.init_affine;
            x0 = init_tps(end+1-d*(n-d-1):end);
        end
        
        %Pass all globalParam's TPS and paramsLocal's TPS and
        %optimization's options.
        %It minimize a non restricted (unconstrained) function objective
        param = fminunc(@(x)gmmreg_L2_tps_costfunc(x, init_affine, basis, kernel, scene, scale, alpha, beta, n, d), x0,  options);
        
        %% UPDATED PARAMS AND MODEL
        
        %updated the model with the motion, final params and control points
        transformed_model = transform_pointset(config.model, config.motion, param, config.ctrl_pts, init_affine);
        
        % if use boths kind of params updated with the new params
        if config.opt_affine
            config.init_tps = param(end+1-d*(n-d-1):end);
            config.init_affine = param(1:d*(d+1));
        %if use only tps params updated with the new params
        else
            config.init_tps = param;
        end
    %% The Others Transformations
    otherwise
        
        % the initial params
        x0 = config.init_param;
        
        %compute the new params with optimization options, file config and Lb,Ub which will be used in
        %factorization LU (use in solving matrix system) 
        %it minimizes a restricted (constrained) objective function
        param = fmincon(@gmmreg_L2_costfunc, x0, [ ],[ ],[ ],[ ], config.Lb, config.Ub, [ ], options, config);
        
        %% UPDATED MODEL AND PARAMS
        %updated the model with the new parameters and motion
        transformed_model = transform_pointset(config.model, config.motion, param);
        %updated the new params
        config.init_param = param;
end
toc

%% Function used in order to finish the optimization
% it receives new x, optimValues, state, and other arguments
    function stop = outfun(x,optimValues,state,varargin)
        %initial value for stop
        stop = false;
        
        %accord to the value of state
        switch state
            
            %if the evaluation is on initial state
            case 'init'
                %if display is on set the letters of axes with size 16
                if config.display>0
                    set(gca,'FontSize',16);
                end
                
            %if actual state is on iteration
            case 'iter'
                %updated the history of values the new params x
                %and updated the history of values of function objective
                history.fval = [history.fval; optimValues.fval];
                history.x = [history.x; reshape(x,1,length(x))];
                
                %in case of display is on
                if config.display>0
                    hold off
                    switch lower(config.motion)
                        %in case of tps transformation
                        case 'tps'
                            %update the model with the new params
                            transformed = transform_pointset(config.model, config.motion, x, config.ctrl_pts,init_affine);
                        %in case of other transformation
                        otherwise
                            %update the model with the new params
                            transformed = transform_pointset(config.model, config.motion, x);
                    end
                    
                    %calculate the metric between scene and transf model
                    dist = L2_distance(transformed,config.scene,config.scale);
                    %graphic boths landmarks
                    DisplayPoints(transformed,config.scene,d);
                    title(sprintf('L2distance: %f',dist));
                    drawnow;
                end
            case 'done'
                %hold off
            otherwise
        end
    end


end

%it calculates the metric least squares using gaussian concepts betwen
%model and scene
function [dist] = L2_distance(model, scene, scale)
    %model^2 + scene^2 + 2*scene*model
    dist = GaussTransform(model,model,scale) + GaussTransform(scene,scene,scale) - 2*GaussTransform(model,scene,scale);
end


