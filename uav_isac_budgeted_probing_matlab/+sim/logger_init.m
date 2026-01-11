function log = logger_init(cfg, snr_dB, mc_id, scene)
%LOGGER_INIT Initialize logging struct
log = struct();
log.snr_dB = snr_dB;
log.mc_id = mc_id;
log.scene = scene;
log.steps = cell(1, cfg.sim.T);
log.last_obs = [];
end
