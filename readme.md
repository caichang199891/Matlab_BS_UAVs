多UAV + 可移动地面基站 + 预算受限主动测量(probing) + 多模态(运动/语义)驱动的 DD 域 ROI mask + Top-K 峰提取 +（可选）POMDP/RL 决策 + largest-remainder 预算整数分配

1) 主入口：run_experiment.m
入口脚本的工作流非常清晰：

加载默认配置 cfg.default_config() 并做基础校验 utils.assert_cfg(cfg)。

初始化随机数种子 sim.init_rng(cfg.sim.seed0)。

进入 Monte Carlo 总调度 sim.run_mc(cfg)。

保存结果并按需绘图。
对应文件：uav_isac_budgeted_probing_matlab/run_experiment.m。

2) Monte Carlo 驱动：sim.run_mc
run_mc 负责对每个 SNR 和每次 MC 运行“单次试验闭环”：

外层循环遍历 cfg.sim.snr_dB_vec。

内层循环遍历 cfg.sim.MC，为每次试验设置不同的随机种子。

每次调用 sim.run_single_trial(cfg, snr_dB, mc) 获取日志。

汇总为 results.logs{si} 并计算指标 metrics.compute_metrics。
对应文件：+sim/run_mc.m。

3) 单次试验闭环：sim.run_single_trial
这是核心闭环，每个时隙执行一次完整“感知-决策-测量-估计-反馈”流程：

3.1 初始化阶段
场景与实体初始化：

scene.generate_scene 构造场景参数结构。

scene.init_entities 初始化 UAV/BS 位置速度等状态。

信道初始化：channel.init_sparse_paths 生成稀疏路径并渲染 DD 网格。

Agent 初始化：agent.policy_baselines("init", ...)

日志初始化：sim.logger_init

对应文件：+sim/run_single_trial.m。

3.2 每个时隙 t 的闭环
闭环中每个时隙的主要模块顺序如下：

A) 真值推进：运动学 + 环境 + 信道
scene.step_entities 推进 UAV/BS 位置速度。

channel.update_sparse_paths 根据最新状态更新稀疏路径与 DD 网格。
对应文件：+sim/run_single_trial.m。

B) 多模态输入：运动 + 语义
fusion.motion_predictor_kf 输出预测位置/速度。

fusion.semantic_predictor_stub 输出语义遮挡风险 p_blk_hat。

fusion.predict_dd_center 用运动预测映射到 DD 域中心。

fusion.build_roi_mask 根据风险动态调整 ROI window。
对应文件：+sim/run_single_trial.m。

C) Agent 决策与预算整数化
agent.policy_baselines("step", ...) 输出连续权重 alpha。

probe.allocate_budget_lrm 将权重转成整数预算 B_int。
对应文件：+sim/run_single_trial.m。F:uav_isac_budgeted_probing_matlab/+sim/run_single_trial.m†L43-L55】

D) 生成测量集合
probe.build_probe_set 在 ROI 内选取每 UAV 的采样点构成 sample_mask。
对应文件：+sim/run_single_trial.m。

E) 仿真观测与峰提取
probe.simulate_probing_obs 采样 DD 网格并加噪得到部分观测。

fusion.extract_topk_peaks 在 ROI 内做 Top-K 峰提取。

fusion.estimate_channel_from_peaks 输出估计结果（stub）。
对应文件：+sim/run_single_trial.m。

F) 奖励计算
channel.compute_truth_sinr 计算真值 SINR。

agent.reward_fn 输出奖励。
对应文件：+sim/run_single_trial.m。

G) 记录日志
保存所有关键中间量。
对应文件：+sim/run_single_trial.m。

4) 关键模块流程与逻辑定位
下面按你论文关心的模块，给出逻辑定位与作用。

4.1 DD 域索引与渲染
channel.dd_indexing 定义 delay/doppler 分辨率与 bin 映射。

channel.render_dd_grid 把稀疏路径投射到 DD 网格。
对应文件：+channel/dd_indexing.m, +channel/render_dd_grid.m。

4.2 稀疏路径生成与演化
channel.init_sparse_paths 用几何参数初始化 LOS + 反射路径。

channel.update_sparse_paths 演化路径并支持 birth/death。
对应文件：+channel/init_sparse_paths.m, +channel/update_sparse_paths.m。

4.3 ROI + 预算 + 采样
ROI 由 fusion.build_roi_mask 通过语义风险调节窗口。

预算分配由 probe.allocate_budget_lrm 完成整数化。

采样策略由 probe.build_probe_set 产生 sample_mask。
对应文件：+fusion/build_roi_mask.m, +probe/allocate_budget_lrm.m, +probe/build_probe_set.m。

4.4 观测 + Top-K
probe.simulate_probing_obs 形成部分 DD 观测并加噪。

fusion.extract_topk_peaks 在 ROI 内做 Top-K 峰提取。
对应文件：+probe/simulate_probing_obs.m, +fusion/extract_topk_peaks.m。

4.5 Agent 与 Reward
agent.policy_baselines 提供 baseline 权重输出。

agent.reward_fn 实现论文式 reward（吞吐 - 预算 - outage）。
对应文件：+agent/policy_baselines.m, +agent/reward_fn.m。

5) 总结（闭环一句话）
每个时隙：状态推进 ➜ 运动/语义预测 ➜ ROI 生成 ➜ 预算分配 ➜ ROI 采样 ➜ DD 观测 ➜ Top-K 峰 ➜ 信道估计 ➜ SINR/奖励 ➜ 日志记录。
核心闭环完全在 sim.run_single_trial 里串起来了，所有关键模块位置如上。 


