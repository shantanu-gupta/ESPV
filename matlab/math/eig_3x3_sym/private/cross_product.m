function [y1, y2, y3] = cross_product(a1, a2, a3, b1, b2, b3)
%CROSS_PRODUCT
    y1 = a2 .* b3 - a3 .* b2;
    y2 = a3 .* b1 - a1 .* b3;
    y3 = a1 .* b2 - a2 .* b1;
end

