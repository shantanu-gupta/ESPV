function [emap] = hysthresh_2(estr, thresh, min_edge_length)
%HYSTHRESH This is just Kovesi's code that also accepts 3D (video) input
%          along with a min_edge_length parameter
    if nargin < 2 || isempty(thresh)
        thresh = [0.5 0.2];
    end
    if nargin < 3 || isempty(min_edge_length)
        min_edge_length = 0;
    end

    if numel(thresh) == 1
        hi_thresh = thresh(1);
        lo_thresh = 0.4 * hi_thresh;
    elseif numel(thresh) == 2
        lo_thresh = min(thresh);
        hi_thresh = max(thresh);            
    end

    emap = estr > hi_thresh;
    above_lo = estr > lo_thresh;
    for n = 1:size(estr, 3)
        [r, c] = find(above_lo(:,:,n));
        sel = bwselect(emap(:,:,n), c, r, 8);
        if min_edge_length > 0
            sel = bwareaopen(sel, min_edge_length);
        end
        emap(:,:,n) = sel;
    end
end
