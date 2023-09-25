function [ec, cc, tc] = cat_t_features_3D(e1, c1, t1, e2, c2, t2)
%CAT_T_FEATURES_3D
    arguments
        e1 struct
        c1 struct
        t1 struct
        e2 struct
        c2 struct
        t2 struct
    end

    ec = struct;
    cc = struct;
    tc = struct;

    ec.strength = cat(3, e1.strength, e2.strength);
    ec.orientation = cat(3, e1.orientation, e2.orientation);
    ec.temporal_angle = cat(3, e1.temporal_angle, e2.temporal_angle);
    ec.normal_velocity = cat(3, e1.normal_velocity, e2.normal_velocity);
    ec.coherence = cat(3, e1.coherence, e2.coherence);
    if isfield(e1, 'strength_nms') && isfield(e2, 'strength_nms')
        ec.strength_nms = cat(3, e1.strength_nms, e2.strength_nms);
    end
    
    cc.strength = cat(3, c1.strength, c2.strength);
    cc.coherence = cat(3, c1.coherence, c2.coherence);
    cc.velocity = cat(4, c1.velocity, c2.velocity); % is 4D array
    if isfield(c1, 'importance') && isfield(c2, 'importance')
        cc.importance = cat(3, c1.importance, c2.importance);
    end

    tc.strength = cat(3, t1.strength, t2.strength);
end

