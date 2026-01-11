function [act, st] = policy_rl_stub(mode, obs, cfg, st)
%POLICY_RL_STUB Placeholder for RL policy
K = cfg.scene.K_uav;
if mode == "init"
    st = struct();
    act = struct('alpha', ones(1,K));
    return;
end
act = struct('alpha', ones(1,K));
end
