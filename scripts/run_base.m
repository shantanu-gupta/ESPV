DATA = load(DATA_FILE);

B = DATA.B;     % temporally low-passed binary video (block-wise sum, no overlaps)
M = DATA.M;     % how many binary frames were summed to get B

% Implementation assumes B is scaled to range [0, 1]
if M ~= 1
    B = B .* (1.0 / M);
end

c_est = ippd(mean(B(OUT_IMIN:OUT_IMAX,OUT_JMIN:OUT_JMAX,:), 'all'));
fprintf('Flux level: %.4f ppp.\n', c_est * M);

t0 = tic;
local_flux = ippd(imgaussfilt3(B, 10));
flux_noise_std = binom_noise_std(local_flux, M);
T = toc(t0);
fprintf('Estimate local mean flux: %.3f seconds.\n', T);

t0 = tic;
[H, W, N] = size(B);
filts.input_size = [H W N];
filts = filts.set_up_filters();
T = toc(t0);
fprintf('Filter initialization: %.3f seconds.\n', T);

t0 = tic;
[R, Rz] = filts.response(B, flux_noise_std);
T = toc(t0);
fprintf('Get filter responses: %.3f seconds.\n', T);

t0 = tic;
[PC_x2, PC_y2, PC_t2, PC_xy, PC_yt, PC_xt] ...
    = phase_congruency_3D_structure_tensor(R, filts.tuning_directions(), ...
                                        filter_energies=filts.filter_energies, ...
                                        flux_noise_std=flux_noise_std, ...
                                        noise_thresh_zmin=TPC_NOISE_THRESH_ZMIN);
[edges, ~, ~] = features_3D_structure_tensor(PC_x2, PC_y2, PC_t2, PC_xy, PC_yt, PC_xt);
T = toc(t0);
fprintf('edge_detection_TPC: %.3f seconds.\n', T);

t0 = tic;
flo1 = flo_1D_to_uv(edges.normal_velocity, edges.orientation);
rel_flo1 = (edges.strength > prctile(edges.strength, 75, 'all')) ...
            & (abs(edges.normal_velocity) < MAX_FLO) ...
            & (edges.coherence > 0.5);
T = toc(t0);
fprintf('edge_velocities_TPC: %.3f seconds.\n', T);

t0 = tic;
[~, ~, flo2_FJ_ms, rel2_FJ_ms] = vel_FJ1990_approx_withz(Rz, filts.tuning_directions(), ...
                                                            solve_2D_pxwise_k=FJ_SOLVE_2D_PXWISE_K);
T = toc(t0);
fprintf('vel_FJ1990_approx_withz_multiscale: %.3f seconds.\n', T);

B = B(OUT_IMIN:OUT_IMAX,OUT_JMIN:OUT_JMAX,1+N_SKIP_OUTPUT:end-N_SKIP_OUTPUT);
estr = edges.strength(OUT_IMIN:OUT_IMAX,OUT_JMIN:OUT_JMAX,1+N_SKIP_OUTPUT:end-N_SKIP_OUTPUT);
flo1 = flo1(OUT_IMIN:OUT_IMAX,OUT_JMIN:OUT_JMAX,:,1+N_SKIP_OUTPUT:end-N_SKIP_OUTPUT);
rel_flo1 = rel_flo1(OUT_IMIN:OUT_IMAX,OUT_JMIN:OUT_JMAX,1+N_SKIP_OUTPUT:end-N_SKIP_OUTPUT);
for s = 1:numel(flo2_FJ_ms)
    flo2_FJ_ms{s} = flo2_FJ_ms{s}(OUT_IMIN:OUT_IMAX,OUT_JMIN:OUT_JMAX,:,1+N_SKIP_OUTPUT:end-N_SKIP_OUTPUT);
    rel2_FJ_ms{s} = rel2_FJ_ms{s}(OUT_IMIN:OUT_IMAX,OUT_JMIN:OUT_JMAX,1+N_SKIP_OUTPUT:end-N_SKIP_OUTPUT);
end

%% save visualizations
if isempty(OUTPUT_NAME)
    OUTPUT_NAME = strrep(seq_name, '/', '_');
end
OUTPUT_DIR = fullfile(OUTPUT_BASEDIR, OUTPUT_NAME);
if ~isfolder(OUTPUT_DIR)
    mkdir(OUTPUT_DIR);
end

B_v = rescale_prctile(B);
save_video(B_v, fullfile(OUTPUT_DIR, 'B'));

estr_v = vis_edge(estr, false, ESTR_VIS_PRCTILE_THRESH);
save_video(estr_v, fullfile(OUTPUT_DIR, 'estr_TPC'));

flo1_v = vis_flo_dense(flo1, rel_flo1, MAX_FLO, FLO1_VIS_THICKEN);
save_video(flo1_v, fullfile(OUTPUT_DIR, 'flo1_TPC'));

for s = 1:numel(flo2_FJ_ms)
    flo2_FJ_ms_c = vis_flo_dense(flo2_FJ_ms{s}, rel2_FJ_ms{s} > FLO2_REL_THRESH, MAX_FLO);
    save_video(flo2_FJ_ms_c, fullfile(OUTPUT_DIR, sprintf('flo2_FJ_ms_%d', s)));
end
