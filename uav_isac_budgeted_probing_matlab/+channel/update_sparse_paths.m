function ch = update_sparse_paths(ch, state, scene, cfg, dt)
%UPDATE_SPARSE_PATHS Update path parameters with simple dynamics
K = scene.K_uav;
L = cfg.channel.L_paths;

for k = 1:K
    paths = ch.paths{k};

    uav_pos = state.uav.pos(k,:);
    uav_vel = state.uav.vel(k,:);
    bs_pos = state.bs.pos;
    bs_vel = state.bs.vel;

    los_vec = uav_pos - bs_pos;
    range = norm(los_vec);
    rel_vel = dot((uav_vel - bs_vel), los_vec / max(range, eps));

    for l = 1:numel(paths)
        paths(l).tau = max(0, paths(l).tau + (rel_vel / cfg.channel.c) * dt + 1e-7 * randn());
        paths(l).nu = paths(l).nu + 0.1 * randn();
        paths(l).a = paths(l).a * exp(1j * 0.1 * randn());
    end

    if rand() < cfg.channel.path_birth_prob && numel(paths) < L
        newp = struct();
        newp.tau = range / cfg.channel.c + (0.1 + rand()) * (range / cfg.channel.c);
        newp.nu = 2 * rel_vel / cfg.channel.lambda + randn() * 0.2;
        newp.a = (0.3 / (range + 1)) * exp(1j * 2 * pi * rand());
        paths(end+1) = newp;
    end

    if rand() < cfg.channel.path_death_prob && numel(paths) > 1
        paths = paths(1:end-1);
    end

    ch.paths{k} = paths;
    ch.DD_true{k} = channel.render_dd_grid(paths, cfg);
end
end
