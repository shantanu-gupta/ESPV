function [y] = quanta_sample_direct(x, sz, M, sigma_read, eta, dcr, tau)
%QUANTA_SAMPLE_DIRECT
%   M:              full well capacity
%   sigma_read:     read noise stdev
%   eta:            quantum efficiency
%   dcr:            dark count rate (can be image), in counts per _exposure time_
%   tau:            "exposure time" (actually a multiplier, not absolute)
%
%   if x is on CPU, y is on CPU. if on GPU, then GPU.
%   default parameter values are for an ideal binary sensor
    if nargin < 2 || isempty(sz)
        sz = size(x);
    end
    if nargin < 3 || isempty(M)
        M = 1;
    end
    if nargin < 4 || isempty(sigma_read)
        sigma_read = 0;
    end
    if nargin < 5 || isempty(eta)
        eta = 1;
    end
    if nargin < 6 || isempty(dcr)
        dcr = 0;
    end
    if nargin < 7 || isempty(tau)
        tau = 1;
    end

    xin = (eta * x + dcr) * tau;
    y = poissrnd(xin, sz);
    if sigma_read > 0
        read_noise = sigma_read * randn(sz, 'like', x);
        y = max(0, round(y + read_noise));
    end
    if M < Inf
        y(y > M) = M;
    end
end

