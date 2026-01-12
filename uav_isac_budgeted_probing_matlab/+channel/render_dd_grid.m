function DD = render_dd_grid(paths, cfg)
%RENDER_DD_GRID 将稀疏路径渲染到 MxN DD 网格（理想化/含泄漏可选）
% paths: struct array with fields tau (s), nu (Hz), a (complex)
M = cfg.dd.M; N = cfg.dd.N;
DD = complex(zeros(M,N));

if isempty(paths)
    return;
end

dd = channel.dd_indexing(cfg);

for i = 1:numel(paths)
    tau_idx = dd.tau_to_idx(paths(i).tau);
    nu_idx = dd.nu_to_idx(paths(i).nu);
    DD(tau_idx, nu_idx) = DD(tau_idx, nu_idx) + paths(i).a;
end
end
