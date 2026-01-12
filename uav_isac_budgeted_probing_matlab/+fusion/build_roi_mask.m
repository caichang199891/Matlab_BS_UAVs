function roi = build_roi_mask(dd_center, sem, cfg)
%BUILD_ROI_MASK 为每个UAV构造 MxN ROI mask
% dd_center: struct with fields delay_idx(1xK), doppler_idx(1xK)
% sem.p_blk_hat: 1xK 预测遮挡风险 [0,1]

M = cfg.dd.M; N = cfg.dd.N; K = cfg.scene.K_uav;
roi = struct();
roi.mask = cell(1,K);
roi.win  = zeros(K,2);

for k = 1:K
    p = utils.clamp(sem.p_blk_hat(k), 0, 1);

    % 窗口插值：风险越高 -> 窗口越大
    wmin = cfg.sem.window_min;
    wmax = cfg.sem.window_max;
    hw = round(wmin + (wmax - wmin)*p); % half-widths
    roi.win(k,:) = hw;

    c_tau = dd_center.delay_idx(k);
    c_nu  = dd_center.doppler_idx(k);

    mask = false(M,N);
    tau_rng = max(1, c_tau-hw(1)) : min(M, c_tau+hw(1));
    nu_rng  = max(1, c_nu -hw(2)) : min(N, c_nu +hw(2));
    mask(tau_rng, nu_rng) = true;

    roi.mask{k} = mask;
end
end
