function motion = motion_predictor_kf(state, cfg)
%MOTION_PREDICTOR_KF Simple noisy motion prediction stub
K = cfg.scene.K_uav;

pos_noise = cfg.motion.sigma_pos * randn(K,3);
vel_noise = cfg.motion.sigma_vel * randn(K,3);

motion = struct();
motion.uav_pos_hat = state.uav.pos + pos_noise;
motion.uav_vel_hat = state.uav.vel + vel_noise;
motion.bs_pos = state.bs.pos;
motion.bs_vel = state.bs.vel;
motion.sigma_pos = cfg.motion.sigma_pos;
motion.sigma_vel = cfg.motion.sigma_vel;
end
