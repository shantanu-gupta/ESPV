addpath(genpath('src'));

clearvars;

[scriptdir, scriptname, ~] = fileparts(mfilename('fullpath'));
DATA_DIR = fullfile(scriptdir, 'data', 'Fig07_edge_vs_flux_circle_sim');

load(fullfile(DATA_DIR, 'data.mat'), '-mat', 'Cvals', 'Mvals', 'Y_3D', 'eX_2D', 'sim_params', 'IND_FRAME');

filt = logGabor_bank_3D_sep_t();
filt.input_size = size(Y_3D{1,1});
filt.min_wavelength = 6;
filt.num_scales = 3;
filt = filt.set_up_filters();

TPC_NOISE_THRESH_ZMIN = 2;

OUTPUT_DIR = fullfile(scriptdir, 'output', 'Fig07');
if ~isfolder(OUTPUT_DIR)
    mkdir(OUTPUT_DIR);
end

estr = cell(size(Y_3D));
ind_vis = IND_FRAME + [-10:10];
for i1 = 1:size(Y_3D,1)
    c = Cvals(i1);
    for i2 = 1:size(Y_3D,2)
        M = Mvals(i2);
        y = Y_3D{i1,i2}/M;
        local_flux = ippd(imgaussfilt3(y, 10));
        flux_noise_std = binom_noise_std(local_flux, M);
        [R, Rz] = filt.response(y, flux_noise_std);
        [PC_x2, PC_y2, PC_t2, PC_xy, PC_yt, PC_xt] ...
            = phase_congruency_3D_structure_tensor(R, filt.tuning_directions(), ...
                                                filter_energies=filt.filter_energies, ...
                                                flux_noise_std=flux_noise_std, ...
                                                noise_thresh_zmin=TPC_NOISE_THRESH_ZMIN);
        [edges, ~, ~] = features_3D_structure_tensor(PC_x2, PC_y2, PC_t2, PC_xy, PC_yt, PC_xt);
        estr{i1,i2} = edges.strength;
        save_video(vis_edge(estr{i1,i2}(:,:,ind_vis)), ...
                   fullfile(OUTPUT_DIR, sprintf('edges_%dbit_c%.2f', calc_bitdepth(M), c*M)), ...
                   3);
    end
end

save(fullfile(DATA_DIR, 'data.mat'), 'estr', '-append');
