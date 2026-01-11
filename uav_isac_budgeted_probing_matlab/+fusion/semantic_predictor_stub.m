function sem = semantic_predictor_stub(state, scene, cfg)
%SEMANTIC_PREDICTOR_STUB Predict blockage risk with noise
K = scene.K_uav;
base_risk = 0.2 * ones(1, K);
noise = cfg.sem.sigma_sem * randn(1, K);

p_hat = utils.clamp(base_risk + noise, 0, 1);
sem = struct();
sem.p_blk_hat = p_hat;
end
