%% Script de prueba de MATLAB
%   es el binario ejecutable basado en C++
%%
function [ ] = gmmreg_demo(exe_path, f_config, method)
%%=====================================================================
%% $RCSfile: gmmreg_demo.m,v $
%% $Author: bing.jian $
%% $Date: 2009-02-10 02:13:49 -0500 (Tue, 10 Feb 2009) $
%% $Revision: 121 $
%%=====================================================================

close all;
%llamando al ejecutable recibiendo ruta y archivo de configuracion y el
%metodo a usar
cmd = sprintf('!%s %s %s', exe_path, f_config, method);
tic
eval(cmd); %ejecucion del registro
toc

%el modelo de puntos
model_file = ml_GetPrivateProfileString('FILES','model', f_config);
%la escena de puntos
scene_file = ml_GetPrivateProfileString('FILES','scene', f_config);
%el archivo de transformacion
transformed_file = ml_GetPrivateProfileString('FILES','transformed_model', f_config);

%carga del modelo
M = load(model_file);
[n,d] = size(M);
%la escala como ingreso para el calculo de la metrica
%se calcula de la amtriz de covarianza del model
scale = power(det(M'*M/n), 1/(2^d)); %(M^2/numPuntos)^(1/2^d)

%carga de la escena
S = load(scene_file);
%carga de la transformacion
Transformed_M = load(transformed_file);

%calculo de la metrica antes y despues registro
distAntesReg = L2_distance(M,S,scale);
distDespuesReg = L2_distance(Transformed_M,S,scale);

%grafica del registro Antes y Despues
figure
set(gcf,'Name','Registro Rigido')
subplot(1,2,1);
DisplayPoints(M,S,size(M,2)); axis off;
title(sprintf('L2distancia Antes: %f',distAntesReg));

subplot(1,2,2);
DisplayPoints(Transformed_M,S,size(S,2)); axis off
title(sprintf('L2distancia Despues: %f',distDespuesReg));
drawnow;
