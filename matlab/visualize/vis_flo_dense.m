function [flo_v] = vis_flo_dense(flo, rel_bin, max_flo, thicken)
%VIS_FLO_DENSE
    if nargin < 2
        rel_bin = [];
    end
    if nargin < 3
        max_flo = [];
    end
    if nargin < 4 || isempty(thicken)
        thicken = 0;
    end

    if thicken > 0
        assert(~isempty(rel_bin));
    end

    N = size(flo, 4);
    flo_v = zeros([size(flo, [1 2]) 3 N], 'uint8');
    for n = 1:N
        u_n = flo(:,:,1,n);
        v_n = flo(:,:,2,n);
        if ~isempty(rel_bin)
            rel_bin_n = rel_bin(:,:,n);
            if thicken > 0
                [D, ind_src] = bwdist(rel_bin_n);
                ind_fill = (D > 0) & (D < thicken);
                u_n(ind_fill) = u_n(ind_src(ind_fill));
                v_n(ind_fill) = v_n(ind_src(ind_fill));
                rel_bin_n = rel_bin_n | ind_fill;
            end
            u_n(~rel_bin_n) = 0;
            v_n(~rel_bin_n) = 0;
        end
        flo_v(:,:,:,n) = flowToColor(cat(3, u_n, v_n), max_flo);
    end
end
