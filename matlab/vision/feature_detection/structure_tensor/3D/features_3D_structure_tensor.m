function [edges, corners, transients] ...
    = features_3D_structure_tensor(Ix2, Iy2, It2, Ixy, Iyt, Ixt)
%FEATURES_3D_STRUCTURE_TENSOR
    [evals, evecs] = eig_3x3_sym(Ix2, Ixy, Ixt, Iy2, Iyt, It2);

    edges = struct;
    edges.strength = evals(:,:,:,1);
    [~, edges.orientation, edges.temporal_angle, edges.normal_velocity] ...
        = edge_props_3D(evecs(:,:,:,1,1), evecs(:,:,:,2,1), evecs(:,:,:,3,1));
    edges.coherence = edge_coherence(edges.strength, evals(:,:,:,2));

    if nargout >= 2
        corners = struct;
        corners.strength = evals(:,:,:,2);
        corners.coherence = corner_coherence(corners.strength, evals(:,:,:,3));
        corners.velocity = permute(evecs(:,:,:,1:2,3) ./ max(eps('single'), evecs(:,:,:,3,3)), ...
                                   [1 2 4 3]);
    end

    if nargout >= 3
        transients = struct;
        transients.strength = evals(:,:,:,3);
    end
end
