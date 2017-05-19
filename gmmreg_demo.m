%This is a MATLB test script calling the binary executable based on the C++
%implementation. The readme.txt in the 'C++' directory explains how to
%obtain the binary executable which can be used here. Configuration files
%and data can be found in the 'data' directory.

function [ ] = gmmreg_demo(exe_path, f_config, method)
%%=====================================================================
%% $RCSfile: gmmreg_demo.m,v $
%% $Author: bing.jian $
%% $Date: 2009-02-10 02:13:49 -0500 (Tue, 10 Feb 2009) $
%% $Revision: 121 $
%%=====================================================================

%clear all;
close all;
cmd = sprintf('!%s %s %s', exe_path, f_config, method);
tic
eval(cmd);
%gmmreg_tps_mex(f_config)
toc

model_file = ml_GetPrivateProfileString('FILES','model', f_config);
scene_file = ml_GetPrivateProfileString('FILES','scene', f_config);

transformed_file = ml_GetPrivateProfileString('FILES','transformed_model', f_config);

M = load(model_file);
[n,d] = size(M);
scale = power(det(M'*M/n), 1/(2^d));
S = load(scene_file);
Transformed_M = load(transformed_file);
distAntesReg = L2_distance(M,S,scale);
distDespuesReg = L2_distance(Transformed_M,S,scale);

figure
set(gcf,'Name','Registro Rigido') 
subplot(1,2,1);
DisplayPoints(M,S,size(M,2)); axis off;
title(sprintf('L2distancia Antes: %f',distAntesReg));
subplot(1,2,2);
DisplayPoints(Transformed_M,S,size(S,2)); axis off
title(sprintf('L2distancia Despues: %f',distDespuesReg));
drawnow;
