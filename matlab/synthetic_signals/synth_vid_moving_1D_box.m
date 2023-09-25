function [Y] = synth_vid_moving_1D_box(L, w, N, v, loc0)
%MOVING_1D_BOX
    if nargin < 5
        loc0 = L/2 - (N/2)*v;
    end
    Y = zeros([N L]);
    for n = 1:N
        loc = loc0 + v*n;
        j0 = max(1, min(L, round(loc-floor(w/2))));
        j1 = max(1, min(L, round(loc+floor(w/2))));
        Y(n,j0:j1) = 1;
    end
end

