function m = compute_metrics(trial_logs, cfg)
%COMPUTE_METRICS Aggregate metrics over trials
num_trials = numel(trial_logs);
rewards = zeros(num_trials,1);

for i = 1:num_trials
    rewards(i) = trial_logs{i}.reward_mean;
end

m = struct();
m.reward_mean = mean(rewards);
m.reward_std = std(rewards);
end
