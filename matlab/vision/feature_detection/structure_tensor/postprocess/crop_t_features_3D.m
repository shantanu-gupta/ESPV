function [er, cr, tr] = crop_t_features_3D(e, c, t, n0, n1)
%CROP_T_FEATURES_3D
    arguments
        e struct
        c struct
        t struct
        n0 uint32 = 1
        n1 uint32 = []
    end

    N = size(e.strength, 3);
    if isempty(n1)
        n1 = N;
    end

    er = e;
    cr = c;
    tr = t;

    er.strength = er.strength(:,:,n0:n1);
    er.orientation = er.orientation(:,:,n0:n1);
    er.temporal_angle = er.temporal_angle(:,:,n0:n1);
    er.normal_velocity = er.normal_velocity(:,:,n0:n1);
    er.coherence = er.coherence(:,:,n0:n1);
    if isfield(er, 'strength_nms')
        er.strength_nms = er.strength_nms(:,:,n0:n1);
    end
    
    cr.strength = cr.strength(:,:,n0:n1);
    cr.coherence = cr.coherence(:,:,n0:n1);
    cr.velocity = cr.velocity(:,:,:,n0:n1); % is 4D array
    if isfield(cr, 'importance')
        cr.importance = cr.importance(:,:,n0:n1);
    end

    tr.strength = tr.strength(:,:,n0:n1);
end

