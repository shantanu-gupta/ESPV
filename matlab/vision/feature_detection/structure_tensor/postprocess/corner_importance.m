function [imp] = corner_importance(strength, coherence, velocities, coh_min, v_max, nms_win)
%CORNER_IMPORTANCE
    if nargin < 4 || isempty(coh_min)
        coh_min = 0;
    end
    if nargin < 5 || isempty(v_max)
        v_max = inf('single');
    end
    if nargin < 6 || isempty(nms_win)
        nms_win = 3;
    end

    local_max_str = ordfilt2_video(strength, nms_win^2, ones([nms_win nms_win]));
    imp = strength .* (strength == local_max_str);

    if coh_min > 0
        imp = imp .* (coherence > coh_min);
    end
    
    if v_max < inf('single')
        v_mag = squeeze(vecnorm(velocities, 2, 3));
        imp = imp .* (v_mag < v_max);
    end
end

