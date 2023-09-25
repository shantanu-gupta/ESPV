function [b] = calc_bitdepth(M)
%CALC_BITDEPTH
    b = max(1, ceil(log2(M)));
end

