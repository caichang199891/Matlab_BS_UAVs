function ch = init_sparse_paths(state, scene, cfg)
%INIT_SPARSE_PATHS Initialize sparse paths for each UAV
K = scene.K_uav;
L = cfg.channel.L_paths;

ch = struct();
ch.paths = cell(1, K);
ch.DD_true = cell(1, K);

for k = 1:K
    uav_pos = state.uav.pos(k,:);
    uav_vel = state.uav.vel(k,:);
    bs_pos = state.bs.pos;
    bs_vel = state.bs.vel;

    los_vec = uav_pos - bs_pos;
    range = norm(los_vec);
    tau_los = range / cfg.channel.c;
    rel_vel = dot((uav_vel - bs_vel), los_vec / range);
    nu_los = 2 * rel_vel / cfg.channel.lambda;

    paths = struct('tau', {}, 'nu', {}, 'a', {});
    paths(1).tau = tau_los;
    paths(1).nu = nu_los;
    paths(1).a = (1 / (range + 1)) * exp(1j * 2 * pi * rand());

    for l = 2:L
        extra_delay = (0.1 + rand()) * tau_los;
        extra_nu = nu_los + (randn() * 0.3 * cfg.dd.delta_f / cfg.dd.N);
        paths(l).tau = tau_los + extra_delay;
        paths(l).nu = extra_nu;
        paths(l).a = (0.5 / (range + 1)) * exp(1j * 2 * pi * rand());
    end

    ch.paths{k} = paths;
    ch.DD_true{k} = channel.render_dd_grid(paths, cfg);
end
end
