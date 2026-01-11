function state = init_entities(scene, cfg)
%INIT_ENTITIES Initialize UAVs and BS positions
K = scene.K_uav;
area = scene.area_xy;

state = struct();
state.t = 0;
state.uav.pos = [area(1) * rand(K,1), area(2) * rand(K,1), scene.h_uav * ones(K,1)];
state.uav.vel = [2*rand(K,1)-1, 2*rand(K,1)-1, zeros(K,1)];

state.bs.pos = [area(1)/2, area(2)/2, scene.h_bs];
state.bs.vel = [0, 0, 0];

state.obs = scene.obs;
end
