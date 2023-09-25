addpath(genpath('matlab'));

clearvars;
[scriptdir, scriptname, ~] = fileparts(mfilename('fullpath'));
plot_dir = fullfile(scriptdir, 'output', 'Fig11');
if ~isfolder(plot_dir)
    mkdir(plot_dir);
end

FIG_W = 4;
FIG_H = 2;

S = 240;
P = 1;
N = P*S;
tn = ((0:N-1))/S;

phi = rand() * 2 * pi;
k = 1;

cosvals = cos(2*pi*k*tn + phi);
sinvals = sin(2*pi*k*tn + phi);
sinvals2 = sinvals .^ 2;

Cvals = logspace(-1.5, 0.8, 30);
alpha = 0.5;

R = 1000;
I_pp_quanta_1bit = zeros(1, numel(Cvals));
phi_est_quanta_1bit = zeros(R, numel(Cvals));
for i1 = 1:numel(Cvals)
    c = Cvals(i1);
    a = alpha * c;

    F = c + a * cosvals;

    % 1-bit sampling
    pr = ppd(F(ones(R,1),:));
    B = quanta_sample_direct(F(ones(R,1),:));
    FB = fft(B, [], 2);
    coef = FB(:,1+k*P);
    phi_est_quanta_1bit(:,i1) = angle(coef);

    In_quanta_1bit = fi_px_quanta_1bit(F);
    I_pp_quanta_1bit(i1) = (a^2) * sum(In_quanta_1bit .* sinvals2);
end

phi_CRLB_quanta_1bit = min(180, rad2deg(1 ./ sqrt(I_pp_quanta_1bit)));

phi_error_quanta_1bit = rad2deg(angdiff(phi_est_quanta_1bit, phi(ones(R,1), ones(numel(Cvals),1))));
phi_RMSE_quanta_1bit = sqrt(mean(phi_error_quanta_1bit.^2, 1));

fig = figure('Units', 'inches', 'Position', [10 10 FIG_W FIG_H]);
semilogx(Cvals, phi_CRLB_quanta_1bit, '-o', 'LineWidth', 2, 'DisplayName', 'CRLB');
hold on;
semilogy(Cvals, phi_RMSE_quanta_1bit, '-o', 'LineWidth', 2, 'DisplayName', 'RMSE from DFT');
xticks([1e-2 1e-1 1 10]);
yticks([20 40 60]);
xlabel('mean flux \it c');
ylabel('phase RMSE (deg)');
title({sprintf('N = %d, k_0 = %d, a = %.1f c', N, k, alpha)});
legend;
fpath_svg = fullfile(plot_dir, sprintf('%s_1bit.svg', scriptname));
set(fig, 'Renderer', 'painters');
saveas(fig, fpath_svg);
close(fig);
