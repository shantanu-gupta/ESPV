function [S, emap] = synth_img_step_edge(L, theta, c, alpha, center)
%GEN_STEP_EDGE
    if nargin < 5
        center = [0 0];
    end
    S = zeros([L L]);
    xv = range_zero_centered(L);
    [xx, yy] = meshgrid(xv, xv);
    z = (xx - center(1)) * cosd(theta) + (yy - center(2)) * sind(theta) >= 0;
    S(z) = c * (1 + alpha);
    S(~z) = c * (1 - alpha);

    emap = abs((xx - center(1)) * cosd(theta) + (yy - center(2)) * sind(theta)) <= 0.5;
end

