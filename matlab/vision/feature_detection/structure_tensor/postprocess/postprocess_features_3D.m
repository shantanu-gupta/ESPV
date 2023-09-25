function [edges, corners, transients] = postprocess_features_3D(edges, corners, transients, ...
                                                                edge_opts, ...
                                                                corner_opts)
%POSTPROCESS_FEATURES_3D
    arguments
        edges struct
        corners struct
        transients struct
        edge_opts.edge_coh_min single = 0
        edge_opts.edge_ori_sm_sigma single = 1
        corner_opts.corner_coh_min single = 0
        corner_opts.corner_v_max single = inf('single')
        corner_opts.corner_nms_win double = 3
    end

    estr = edges.strength;
    if edge_opts.edge_coh_min > 0
        estr = estr .* (edges.coherence > edge_opts.edge_coh_min);
    end
    [eori_sm, ephi_sm] = smoothorient_3D(edges.orientation, edges.temporal_angle, ...
                                         edge_opts.edge_ori_sm_sigma);
    edges.strength_nms = nms3(estr, eori_sm, ephi_sm);

    corners.importance = corner_importance(corners.strength, corners.coherence, corners.velocity, ...
                            corner_opts.corner_coh_min, corner_opts.corner_v_max, corner_opts.corner_nms_win);
end

