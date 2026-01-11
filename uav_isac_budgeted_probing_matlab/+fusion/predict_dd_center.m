function dd_center = predict_dd_center(motion, cfg)
%PREDICT_DD_CENTER Map predicted motion to DD grid center indices
K = cfg.scene.K_uav;

dd = channel.dd_indexing(cfg);

delay_idx = zeros(1, K);
doppler_idx = zeros(1, K);

for k = 1:K
    uav_pos = motion.uav_pos_hat(k,:);
    uav_vel = motion.uav_vel_hat(k,:);
    bs_pos = motion.bs_pos;
    bs_vel = motion.bs_vel;

    los_vec = uav_pos - bs_pos;
    range = norm(los_vec);
    tau = range / cfg.channel.c;
    rel_vel = dot((uav_vel - bs_vel), los_vec / max(range, eps));
    nu = 2 * rel_vel / cfg.channel.lambda;

    delay_idx(k) = dd.tau_to_idx(tau);
    doppler_idx(k) = dd.nu_to_idx(nu);
end

 dd_center = struct();
 dd_center.delay_idx = delay_idx;
 dd_center.doppler_idx = doppler_idx;
end
