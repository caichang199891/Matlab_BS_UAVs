function sinr = compute_truth_sinr(ch, state, scene, cfg)
%COMPUTE_TRUTH_SINR Simple SINR proxy from path powers
K = scene.K_uav;
sinr = zeros(1, K);

for k = 1:K
    paths = ch.paths{k};
    power = sum(abs([paths.a]).^2);
    noise = 1;
    sinr(k) = power / noise;
end
end
