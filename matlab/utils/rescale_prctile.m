function [xs] = rescale_prctile(x, p_hi, p_lo)
%AUTOSCALE_INTENSITY
    if nargin < 2 || isempty(p_hi)
        p_hi = 97;
    end
    if nargin < 3 || isempty(p_lo)
        p_lo = 0;
    end

    xs = rescale(x, 'InputMin', prctile(x, p_lo, 'all'), ...
                    'InputMax', prctile(x, p_hi, 'all'));
end

