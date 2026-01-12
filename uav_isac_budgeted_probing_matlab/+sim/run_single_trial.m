function log = run_single_trial(cfg, snr_dB, mc_id)
%RUN_SINGLE_TRIAL 单条轨迹/单次MC：T时隙闭环

% 1) 场景初始化
scene_struct = scene.generate_scene(cfg);
state = scene.init_entities(scene_struct, cfg);

% 2) 信道初始化（稀疏Top-L路径）
ch = channel.init_sparse_paths(state, scene_struct, cfg);

% 3) Agent 初始化（baseline 或 RL stub）
agent_state = agent.policy_baselines("init", [], cfg);

% 4) logger
log = sim.logger_init(cfg, snr_dB, mc_id, scene_struct);

T  = cfg.sim.T;
dt = cfg.sim.dt;

for t = 1:T
    % -------------------------
    % A) 真值推进：运动学 + 环境 + 信道演化
    % -------------------------
    [state, scene_struct] = scene.step_entities(state, scene_struct, cfg, dt);
    ch = channel.update_sparse_paths(ch, state, scene_struct, cfg, dt);

    % -------------------------
    % B) 多模态输入：运动 + 语义（遮挡风险）
    % -------------------------
    motion = fusion.motion_predictor_kf(state, cfg);      % 可输出预测位置/速度及不确定度
    sem    = fusion.semantic_predictor_stub(state, scene_struct, cfg); % 输出 p_blk_hat (每UAV)

    % 预测 DD 中心（由运动学把 v/τ 映射到 DD）
    dd_center = fusion.predict_dd_center(motion, cfg);

    % 生成 ROI mask（语义调窗口大小）
    if cfg.probe.use_roi
        roi = fusion.build_roi_mask(dd_center, sem, cfg);  % roi.mask{kuav} : MxN logical
    else
        roi = []; % 空表示全域
    end

    % -------------------------
    % C) Agent 决策：给出每UAV“连续预算意图”或权重，再转整数预算
    % -------------------------
    obs_agent = struct();
    obs_agent.motion = motion;
    obs_agent.sem    = sem;
    obs_agent.prev   = log.last_obs; %#ok<NASGU> % 可选：历史观测（POMDP）

    [act, agent_state] = agent.policy_baselines("step", obs_agent, cfg, agent_state);
    % act.alpha(kuav) 表示预算分配权重（连续）

    B_int = probe.allocate_budget_lrm(act.alpha, cfg.probe.B_tot, cfg.probe.B_min, cfg.probe.B_max);

    % -------------------------
    % D) 生成 probing 集合（每UAV在 ROI 内挑选 B_i 个点/波束/导频位置）
    % -------------------------
    probe_set = probe.build_probe_set(roi, B_int, cfg);

    % -------------------------
    % E) 仿真观测：发导频 -> 接收 -> 形成“部分DD观测”
    % -------------------------
    y = probe.simulate_probing_obs(ch, probe_set, snr_dB, cfg);

    % 峰提取：在 ROI 内做 Top-K
    peaks = fusion.extract_topk_peaks(y, roi, cfg.probe.TopK, cfg);

    % 参数估计/信道重建（可输出DD网格估计或路径参数估计）
    est = fusion.estimate_channel_from_peaks(peaks, cfg);

    % -------------------------
    % F) 计算真值SINR、估计SINR、reward
    % -------------------------
    sinr_true = channel.compute_truth_sinr(ch, state, scene_struct, cfg);
    r = agent.reward_fn(sinr_true, B_int, cfg);

    % -------------------------
    % G) 记录日志
    % -------------------------
    stepinfo = struct();
    stepinfo.t = t;
    stepinfo.state = state;
    stepinfo.motion = motion;
    stepinfo.sem = sem;
    stepinfo.dd_center = dd_center;
    stepinfo.B_int = B_int;
    stepinfo.probe_set = probe_set;
    stepinfo.y = y;
    stepinfo.peaks = peaks;
    stepinfo.est = est;
    stepinfo.sinr_true = sinr_true;
    stepinfo.reward = r;

    log = sim.logger_step(log, stepinfo, cfg);
end

log = sim.logger_finalize(log, cfg);
end
