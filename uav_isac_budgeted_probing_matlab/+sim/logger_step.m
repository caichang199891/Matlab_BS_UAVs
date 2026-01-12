function log = logger_step(log, stepinfo, cfg)
%LOGGER_STEP Append per-step info
log.steps{stepinfo.t} = stepinfo;
log.last_obs = stepinfo;
if mod(stepinfo.t, cfg.metrics.log_every) == 0
    % no-op placeholder for streaming logs
end
end
