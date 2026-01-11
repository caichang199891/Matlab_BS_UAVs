function probe_set = build_probe_set(roi, B_int, cfg)
%BUILD_PROBE_SET Build probing sampling mask within ROI
% roi.mask{k}: MxN logical, or empty for full grid

M = cfg.dd.M;
N = cfg.dd.N;
K = cfg.scene.K_uav;

guard = cfg.dd.guard_bins;
valid_guard = false(M,N);
valid_guard((1+guard):(M-guard),(1+guard):(N-guard)) = true;

probe_set = struct();
probe_set.sample_mask = cell(1, K);
probe_set.sample_idx = cell(1, K);

for k = 1:K
    if isempty(roi)
        mask = true(M,N);
    else
        mask = roi.mask{k};
    end

    mask = mask & valid_guard;
    available = find(mask);
    if isempty(available)
        sample_mask = false(M,N);
        probe_set.sample_mask{k} = sample_mask;
        probe_set.sample_idx{k} = [];
        continue;
    end

    Bk = min(B_int(k), numel(available));
    idx = available(randperm(numel(available), Bk));
    sample_mask = false(M,N);
    sample_mask(idx) = true;

    probe_set.sample_mask{k} = sample_mask;
    probe_set.sample_idx{k} = idx;
end
end
