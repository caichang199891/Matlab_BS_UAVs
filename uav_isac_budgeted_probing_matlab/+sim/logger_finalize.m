function log = logger_finalize(log, cfg)
%LOGGER_FINALIZE Finalize log, compute quick aggregates
rewards = zeros(1, cfg.sim.T);
for t = 1:cfg.sim.T
    if ~isempty(log.steps{t})
        rewards(t) = log.steps{t}.reward;
    end
end
log.reward_mean = mean(rewards);
log.reward_sum = sum(rewards);
end
