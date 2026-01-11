function cfg = sanity_config_fast()
%SANITY_CONFIG_FAST 更快的 sanity 运行配置
cfg = cfg.default_config();
cfg.sim.MC = 2;
cfg.sim.T = 20;
cfg.sim.snr_dB_vec = 10;
end
