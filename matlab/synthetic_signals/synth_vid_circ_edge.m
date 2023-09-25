function [S, emap] = synth_vid_circ_edge(L, radius, c, alpha, N, v)
%GEN_STEP_EDGE
    S = zeros([L L N], 'single');
    emap = false(size(S));
    % the 0.5 is for consistency with gen_step_edge_video
    loc0 = -(N/2)*v + [0.5 0.5];
    for n = 1:N
        [img, em] = synth_img_circ_edge(L, radius, c, alpha, loc0 + n*v);
        S(:,:,n) = img;
        emap(:,:,n) = em;
    end
end

