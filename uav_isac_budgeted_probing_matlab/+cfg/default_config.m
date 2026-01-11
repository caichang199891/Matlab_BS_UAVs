function cfg = default_config()
%DEFAULT_CONFIG 统一参数入口，所有模块只读 cfg，避免散落的 magic numbers

% -------------------------
% 仿真控制
% -------------------------
cfg.sim.MC        = 50;     % Monte Carlo 次数
cfg.sim.T         = 200;    % 时隙数
cfg.sim.dt        = 0.1;    % 时隙长度(s)
cfg.sim.snr_dB_vec= 5:5:20; % SNR sweep
cfg.sim.seed0     = 20260111;
cfg.sim.save_dir  = "./results";

% -------------------------
% 场景与实体
% -------------------------
cfg.scene.area_xy = [800, 800];   % 区域尺寸 (m)
cfg.scene.h_bs    = 10;           % 地面基站高度(可设为车载) (m)
cfg.scene.h_uav   = 80;           % UAV 典型高度 (m)
cfg.scene.K_uav   = 6;            % UAV 数
cfg.scene.bs_mobile = true;       % 基站是否移动
cfg.scene.obs.enable = true;      % 是否启用障碍(楼宇)遮挡
cfg.scene.obs.count  = 20;        % 障碍物数量(简化为矩形柱体)

% 运动学噪声（用于“运动模态不准”）
cfg.motion.sigma_pos = 0.5;   % m
cfg.motion.sigma_vel = 0.2;   % m/s

% -------------------------
% 信道（稀疏时变：Top-L 路径）
% -------------------------
cfg.channel.L_paths   = 3;        % 每个UAV的主要路径数(可含LOS+反射)
cfg.channel.fc        = 28e9;     % 载频
cfg.channel.c         = 3e8;
cfg.channel.lambda    = cfg.channel.c / cfg.channel.fc;
cfg.channel.path_birth_prob = 0.02;  % 动态散射体导致路径birth/death（可选）
cfg.channel.path_death_prob = 0.02;

% -------------------------
% DD 网格 / 波形
% -------------------------
cfg.dd.M = 64;    % delay bins
cfg.dd.N = 32;    % doppler bins
cfg.dd.delta_f = 15e3;      % 子载波间隔(示例)
cfg.dd.T_sym   = 1/cfg.dd.delta_f;
cfg.dd.guard_bins = 2;      % 保护带

% OTFS / AFDM 选择
cfg.waveform.type = "OTFS"; % "OTFS" or "AFDM"
cfg.waveform.pilot_power = 1.0;

% -------------------------
% 主动测量(probing)预算
% -------------------------
cfg.probe.B_tot   = 64;        % 全局总测量预算/时隙（整数）
cfg.probe.B_min   = 2;         % 每UAV最小预算
cfg.probe.B_max   = 24;        % 每UAV最大预算
cfg.probe.TopK    = 5;         % 每UAV提取Top-K峰
cfg.probe.use_roi = true;      % 是否启用ROI mask

% -------------------------
% 语义风险（遮挡概率）模型：用于动态调 ROI 窗口
% -------------------------
cfg.sem.sigma_sem = 0.15;      % 语义预测噪声（越大越不准）
cfg.sem.window_min = [3, 2];   % [delay_halfwidth, doppler_halfwidth] 最小窗口
cfg.sem.window_max = [12, 8];  % 最大窗口

% -------------------------
% 决策 / 奖励（与你论文 reward 对齐）
% -------------------------
cfg.agent.type = "baseline"; % "baseline" or "rl_stub"
cfg.reward.w_uav = ones(1, cfg.scene.K_uav);
cfg.reward.lambda_B = 0.02;
cfg.reward.lambda_O = 1.0;
cfg.reward.Gamma_sinr = 5; % SINR门限（线性域/或dB需统一）

% -------------------------
% 指标输出
% -------------------------
cfg.metrics.log_every = 1;
cfg.metrics.plot = true;

end
