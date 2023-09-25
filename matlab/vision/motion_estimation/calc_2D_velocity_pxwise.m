function [V, rel] = calc_2D_velocity_pxwise(nx2, nxny, ny2, vnx, vny, w, k)
%CALC_2D_VELOCITY_PXWISE
    if nargin < 7 || isempty(k)
        k = [];
    end

    num_orient = size(nx2, 1);
    if nargin < 6 || isempty(w)
        w = cell(num_orient, 1);
        for o = 1:num_orient
            w{o} = 1;
        end
    end

    if (isscalar(nx2{1}) && isscalar(w{1}))
        V = zeros([1 1 2 1]);
        rel = true;
        return;
    end

    if ~isscalar(nx2{1})
        [H, W, N] = size(nx2{1}, [1 2 3]);
        V = zeros([H W 2 N], 'like', nx2{1});
    elseif ~isscalar(w{1})
        [H, W, N] = size(w{1}, [1 2 3]);
        V = zeros([H W 2 N], 'like', w{1});
    end

    nx2 = cat(4, nx2{:});
    nxny = cat(4, nxny{:});
    ny2 = cat(4, ny2{:});
    vnx = cat(4, vnx{:});
    vny = cat(4, vny{:});
    w = cat(4, w{:});

    if all(size(w, [1 2 3]) == 1) && all(w(:) == 1)
        NtN_11 = sum(nx2, 4);
        NtN_12 = sum(nxny, 4);
        NtN_22 = sum(ny2, 4);
        NtVn_1 = sum(vnx, 4);
        NtVn_2 = sum(vny, 4);
    else
        NtN_11 = sum(w .* nx2, 4);
        NtN_12 = sum(w .* nxny, 4);
        NtN_22 = sum(w .* ny2, 4);
        NtVn_1 = sum(w .* vnx, 4);
        NtVn_2 = sum(w .* vny, 4);
    end
    
    if nargout > 1
        [vx, vy, rel] = solve_linear_eq_2x2_sym(NtN_11, NtN_12, NtN_22, NtVn_1, NtVn_2, k);
    else
        [vx, vy] = solve_linear_eq_2x2_sym(NtN_11, NtN_12, NtN_22, NtVn_1, NtVn_2, k);
    end
    V(:,:,1,:) = permute(vx, [1 2 4 3]);
    V(:,:,2,:) = permute(vy, [1 2 4 3]);
end

