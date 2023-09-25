function [zc] = vis_complex_number(z, p, scale_r)
%VIS_COMPLEX_NUMBER
    if nargin < 2 || isempty(p)
        p = 1.4;
    end
    if nargin < 3 || isempty(scale_r)
        scale_r = true;
    end

    assert(ndims(z) == 2); %#ok<ISMAT> 
    [th, r] = cart2pol(real(z), imag(z));
    th = rescale(th);
    if scale_r
        r = rescale(r);
    end
    if p ~= 1
        r = r .^ p;
    end
    o = ones(size(z));
    zc = hsv2rgb(cat(3, th, r, o));
end

