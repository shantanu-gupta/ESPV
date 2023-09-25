function [S, emap] = synth_img_line_edge(L, thickness, theta, c, alpha, center)
%GEN_LINE_EDGE
    % alpha can be set negative here, for dark line on light background
    if nargin < 6
        center = [0 0];
    end
    S = zeros([L L]);
    xv = range_zero_centered(L);
    [xx, yy] = meshgrid(xv, xv);
    d = abs((xx - center(1)) * cosd(theta) + (yy - center(2)) * sind(theta));
    z = (d <= (thickness/2));
    v0 = c * (1 - alpha);
    v1 = c * (1 + alpha);
    S(z) = v1;
    S(~z) = v0;

    emap = (d <= 0.5);
end

