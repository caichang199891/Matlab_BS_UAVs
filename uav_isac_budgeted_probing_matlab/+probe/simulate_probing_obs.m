function y = simulate_probing_obs(ch, probe_set, snr_dB, cfg)
%SIMULATE_PROBING_OBS 按 probe_set 在DD域采样并加噪形成部分观测
K = cfg.scene.K_uav;
y = struct();
y.dd_obs = cell(1,K);

for k = 1:K
    DD_true = ch.DD_true{k};  % MxN（由 render_dd_grid 得到）
    mask_sample = probe_set.sample_mask{k}; % MxN logical：哪些点被测了
    Z = abs(DD_true).^2;

    % 只保留采样点，其余设为0
    Zobs = zeros(size(Z));
    Zobs(mask_sample) = Z(mask_sample);

    % 加噪
    Zobs = probe.add_noise(Zobs, snr_dB, cfg);

    y.dd_obs{k} = Zobs;
end
end
