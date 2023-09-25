function [V] = flo_1D_to_uv(vn, vori)
%FLO_1D_TO_UV
    sz = size(vn);
    if numel(sz) < 3
        sz = [sz 1 1];
    end
    u = reshape(vn .* cosd(vori), [sz(1:2) 1 sz(3:end)]);
    v = reshape(vn .* sind(vori), [sz(1:2) 1 sz(3:end)]);
    V = cat(3, u, v);
end

