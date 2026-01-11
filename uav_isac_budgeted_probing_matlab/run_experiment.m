clear; clc;
cfg = cfg.default_config();
cfg = utils.assert_cfg(cfg);

sim.init_rng(cfg.sim.seed0);

results = sim.run_mc(cfg);

metrics.save_results(results, cfg);
if cfg.metrics.plot
    metrics.plot_results(results, cfg);
end
