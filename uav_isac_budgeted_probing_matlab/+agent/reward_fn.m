function r = reward_fn(sinr_true, B_int, cfg)
%REWARD_FN 对齐你论文 reward：sum w log2(1+SINR) - lambda_B * budget - lambda_O * outage
w = cfg.reward.w_uav;
Gamma = cfg.reward.Gamma_sinr;

% 保证单位一致：sinr_true 若为dB需转线性，这里假设线性
term_rate = sum(w .* log2(1 + sinr_true));

term_budget = cfg.reward.lambda_B * sum(B_int) / cfg.probe.B_tot;

term_outage = cfg.reward.lambda_O * sum(sinr_true < Gamma);

r = term_rate - term_budget - term_outage;
end
