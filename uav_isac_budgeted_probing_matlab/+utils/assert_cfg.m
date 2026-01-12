function cfg = assert_cfg(cfg)
%ASSERT_CFG Basic configuration sanity checks
assert(cfg.probe.B_tot >= cfg.probe.B_min * cfg.scene.K_uav, 'B_tot too small');
assert(cfg.probe.B_max >= cfg.probe.B_min, 'B_max < B_min');
end
