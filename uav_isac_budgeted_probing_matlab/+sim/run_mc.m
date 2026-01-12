function results = run_mc(cfg)
%RUN_MC 多SNR、多MC 的总调度

snr_vec = cfg.sim.snr_dB_vec;
MC      = cfg.sim.MC;

results = struct();
results.cfg = cfg;
results.snr_dB_vec = snr_vec;

for si = 1:numel(snr_vec)
    snr_dB = snr_vec(si);
    trial_logs = cell(MC,1);

    for mc = 1:MC
        seed = cfg.sim.seed0 + 1000*si + mc;
        sim.init_rng(seed);

        log = sim.run_single_trial(cfg, snr_dB, mc);
        trial_logs{mc} = log;
    end

    results.logs{si} = trial_logs;
    results.metrics(si) = metrics.compute_metrics(trial_logs, cfg);
end
end
