function dd = dd_indexing(cfg)
%DD_INDEXING Delay-Doppler indexing helpers for OTFS-like grid
% Returns resolution, bin centers, and mapping helpers.

M = cfg.dd.M;
N = cfg.dd.N;
delta_f = cfg.dd.delta_f;
T_sym = cfg.dd.T_sym;

% Delay and Doppler resolution
% tau_res: 1/(M * delta_f), nu_res: 1/(N * T_sym)
 tau_res = 1 / (M * delta_f);
 nu_res = 1 / (N * T_sym);

% Bin centers (1-based indexing)
 tau_bins = (0:M-1) * tau_res;
 nu_bins = ((-floor(N/2)):(ceil(N/2)-1)) * nu_res;

 dd = struct();
 dd.M = M;
 dd.N = N;
 dd.tau_res = tau_res;
 dd.nu_res = nu_res;
 dd.tau_bins = tau_bins;
 dd.nu_bins = nu_bins;

 dd.tau_to_idx = @(tau) clamp_idx(round(tau./tau_res) + 1, M);
 dd.nu_to_idx = @(nu) clamp_idx(round(nu./nu_res) + floor(N/2) + 1, N);

 dd.idx_to_tau = @(idx) tau_bins(clamp_idx(idx, M));
 dd.idx_to_nu = @(idx) nu_bins(clamp_idx(idx, N));
end

function idx = clamp_idx(idx, maxv)
idx = max(1, min(maxv, idx));
end
