function [S, emap] = synth_img_circ_edge(L, r, c, alpha, center)
%GEN_CIRCLE_EDGE
    if nargin < 5
        center = [0 0];
    end
    S = zeros([L L]);
    if mod(L,2) == 0
        xv = (-L/2):(L/2)-1;
    else
        xv = (-(L-1)/2):((L-1)/2);
    end
    [xx, yy] = meshgrid(xv, xv);
    xc = center(1); yc = center(2);
    z = ((((xx-xc).^2) + ((yy-yc).^2)) <= (r^2));
    S(z) = c * (1 + alpha);
    S(~z) = c * (1 - alpha);

    emap = (abs(hypot((xx-xc), (yy-yc)) - r) <= 0.5);
end

