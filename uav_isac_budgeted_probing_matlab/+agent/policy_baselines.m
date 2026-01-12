function [act, st] = policy_baselines(mode, obs, cfg, st)
%POLICY_BASELINES 输出 act.alpha(1xK) 用于预算分配
% 你可以实现：
%  (1) uniform: alpha=1
%  (2) risk-aware: alpha ∝ p_blk_hat 或 ∝ (1 - p_blk_hat)
%  (3) uncertainty-aware: alpha ∝ motion.sigma 等

K = cfg.scene.K_uav;

if mode == "init"
    st = struct();
    act = struct('alpha', ones(1,K));
    return;
end

p = obs.sem.p_blk_hat; % 1xK
% 示例：风险越高越多测
alpha = 0.2 + p;  % 防止为0
act = struct('alpha', alpha);

end
