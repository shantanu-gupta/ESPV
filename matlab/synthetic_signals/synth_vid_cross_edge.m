function [S, emap] = synth_vid_cross_edge(L, theta, c, alpha, N, v)
%GEN_STEP_EDGE
    S = zeros([L L N], 'single');
    emap = false(size(S));
    % the 0.5 makes it so that cropping around the center gives symmetric
    % images
    loc0 = -(N/2)*v + [0.5 0.5];
    for n = 1:N
        [img, em] = synth_img_cross_edge(L, theta, c, alpha, loc0 + n*v);
        S(:,:,n) = img;
        emap(:,:,n) = em;
    end
end

