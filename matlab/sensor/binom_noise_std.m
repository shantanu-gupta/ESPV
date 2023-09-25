function [g] = binom_noise_std(c, M)
%BINOM_NOISE_STD
    % For setting noise thresholds, we usually have a multiplicative factor 
    % on top of this
    p = ppd(c);
    g = sqrt((p .* (1-p)) * (1/M));
end
