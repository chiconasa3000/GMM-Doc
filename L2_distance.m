%function which calculates the metric of least squares
function [dist] = L2_distance(model, scene, scale)
    %model^2 + scene^2 + 2*scene*model
    dist = GaussTransform(model,model,scale) + GaussTransform(scene,scene,scale) - 2*GaussTransform(model,scene,scale);
end

