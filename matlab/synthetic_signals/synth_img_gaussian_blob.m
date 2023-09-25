function [S] = synth_img_gaussian_blob(L, sigma, b, beta, center)
%GEN_GAUSSIAN_BLOB
    if nargin < 5
        center = [0 0];
    end
    if mod(L,2) == 0
        xv = (-L/2):(L/2)-1;
    else
        xv = (-(L-1)/2):((L-1)/2);
    end
    [xx, yy] = meshgrid(xv, xv);
    d = hypot(xx - center(1), yy - center(2));
    S = b * (1 + beta * exp((-1/(2*sigma^2)) * d.^2));
end
