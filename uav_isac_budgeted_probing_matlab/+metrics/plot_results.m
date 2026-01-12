function plot_results(results, cfg)
%PLOT_RESULTS Plot basic reward vs SNR
snr_vec = results.snr_dB_vec;
reward = arrayfun(@(m) m.reward_mean, results.metrics);

figure; plot(snr_vec, reward, '-o');
xlabel('SNR (dB)'); ylabel('Mean Reward'); grid on;
title('Reward vs SNR');
end
