function save_results(results, cfg)
%SAVE_RESULTS Save results to MAT file
if ~exist(cfg.sim.save_dir, 'dir')
    mkdir(cfg.sim.save_dir);
end
fname = fullfile(cfg.sim.save_dir, 'results.mat');
save(fname, 'results');
end
