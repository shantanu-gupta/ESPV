function [V, Rel, V0, Rel0] = vel_FJ1990_approx_withz(Rz, dirs, opts)
%VEL_FJ1990_APPROX_WITHZ
    % Replaces estimated local frequency with filter tuning itself
    % (reliability calculations are also different; they use z-scores)
    arguments
        Rz (:,:) cell
        dirs (:,3) single
        opts.zscore_weight_thresh single = 6
        opts.wsum_rel_thresh single = 1
        opts.solve_2D_pxwise_k single = []
    end

    [num_dirs, num_scales] = size(Rz);
    V0 = cell(num_scales, 1);
    Rel0 = cell(num_scales, 1);
    for i1 = 1:num_scales
        nx2 = cell(num_dirs, 1);
        nxny = cell(num_dirs, 1);
        ny2 = cell(num_dirs, 1);
        vnx = cell(num_dirs, 1);
        vny = cell(num_dirs, 1);
        w = cell(num_dirs, 1);
        for i2 = 1:num_dirs
            if ~isempty(Rz{i2,i1})
                % NOTE: these directions are in frequency-domain
                nx = dirs(i2, 1); ny = dirs(i2, 2); nt = dirs(i2, 3);
                % cot phi_k = -v
                vn = -nt ./ max(eps('single'), hypot(nx, ny));

                nx2{i2} = nx^2;
                nxny{i2} = nx*ny;
                ny2{i2} = ny^2;
                vnx{i2} = vn * nx;
                vny{i2} = vn * ny;
                w{i2} = 1 - exp(-max(0, Rz{i2,i1} - opts.zscore_weight_thresh));
            end
        end

        notempty = @(x) ~isempty(x);
        nx2 = nx2(cellfun(notempty, nx2));
        nxny = nxny(cellfun(notempty, nxny));
        ny2 = ny2(cellfun(notempty, ny2));
        vnx = vnx(cellfun(notempty, vnx));
        vny = vny(cellfun(notempty, vny));
        w = w(cellfun(notempty, w));

        wsum = sum(cat(4, w{:}), 4);
        rel_wsum = 1 - exp(-max(0, wsum - opts.wsum_rel_thresh));

        [v0, rel_i1d] = calc_2D_velocity_pxwise(nx2, nxny, ny2, vnx, vny, w, ...
                                              opts.solve_2D_pxwise_k);
        Rel0{i1} = rel_wsum .* rel_i1d;
        V0{i1} = v0;
    end

    if num_scales > 1
        [V, Rel] = vel_scalecomb_max(V0, Rel0);
    else
        V = V0{1};
        Rel = Rel0{1};
    end
end

