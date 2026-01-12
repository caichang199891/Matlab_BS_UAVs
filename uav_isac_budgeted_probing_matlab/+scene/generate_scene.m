function scene = generate_scene(cfg)
%GENERATE_SCENE Setup static scene parameters
scene = struct();
scene.area_xy = cfg.scene.area_xy;
scene.h_bs = cfg.scene.h_bs;
scene.h_uav = cfg.scene.h_uav;
scene.K_uav = cfg.scene.K_uav;
scene.bs_mobile = cfg.scene.bs_mobile;
scene.obs = cfg.scene.obs;
end
