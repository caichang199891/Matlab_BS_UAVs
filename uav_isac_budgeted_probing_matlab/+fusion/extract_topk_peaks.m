function peaks = extract_topk_peaks(y, roi, TopK, cfg)
%EXTRACT_TOPK_PEAKS 在 ROI mask 限定区域内取TopK峰
% y.dd_obs{k}: MxN 观测能量图（或相关输出）

K = cfg.scene.K_uav;
peaks = struct();
peaks.list = cell(1,K);

for k = 1:K
    Z = y.dd_obs{k}; % MxN
    if isempty(roi)
        mask = true(size(Z));
    else
        mask = roi.mask{k};
    end

    Zm = Z;
    Zm(~mask) = -inf;

    % 取TopK
    [vals, idx] = maxk(Zm(:), TopK);
    [tau_idx, nu_idx] = ind2sub(size(Zm), idx);

    peaks.list{k} = table(tau_idx(:), nu_idx(:), vals(:), ...
        'VariableNames', {'delay_idx','doppler_idx','score'});
end
end
