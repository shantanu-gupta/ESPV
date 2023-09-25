addpath(genpath('matlab'));

clearvars;

rng(12, 'simdTwister');

[scriptdir, scriptname, ~] = fileparts(mfilename('fullpath'));
DATA_DIR = fullfile(scriptdir, 'data', 'Fig07_edge_vs_flux_circle_sim');
if ~isfolder(DATA_DIR)
    mkdir(DATA_DIR);
end

L = 128;
N = 128; IND_FRAME = ceil(N/2);
radius = 40;
v = [1 0];
alpha = 0.4;
c0 = 0.5;

[X_3D, eX_3D] = synth_vid_circ_edge(L, radius, c0, alpha, N, v);
eX_2D = eX_3D(:,:,IND_FRAME);

Cvals = [0.01 0.1 1];
Mvals = [1 7 63];

Y_3D = cell(numel(Cvals), numel(Mvals));
sim_params = cell(numel(Cvals), numel(Mvals));
ind_vis = IND_FRAME + [-10:10];
for i1 = 1:numel(Cvals)
    c = Cvals(i1);
    Xc = (c/c0) * X_3D;
    for i2 = 1:numel(Mvals)
        M = Mvals(i2);
        Y_3D{i1,i2} = quanta_sample_direct(M*Xc, [], M);
        sim_params{i1,i2} = struct('c', c, 'M', M);
        if M == 1
            y_vis = Y_3D{i1,i2};
        else
            y_vis = rescale(Y_3D{i1,i2}, 'InputMin', 0, 'InputMax', prctile(Y_3D{i1,i2}, 97, 'all'));
        end
        save_video(y_vis(:,:,ind_vis), ...
                   fullfile(DATA_DIR, sprintf('obs_%dbit_c%.2f', calc_bitdepth(M), c*M)), ...
                   3);
    end
end

save_video(X_3D(:,:,ind_vis), fullfile(DATA_DIR, 'true_seq'), 1);
save(fullfile(DATA_DIR, 'data.mat'));
