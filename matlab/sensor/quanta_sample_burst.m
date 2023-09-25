function [y] = quanta_sample_burst(x, sz, M, sigma_read)
%QUANTA_SAMPLE_BURST
    if nargin < 2 || isempty(sz)
        sz = size(x);
    end
    if nargin < 3 || isempty(M)
        M = 1;
    end
    if nargin < 4 || isempty(sigma_read)
        sigma_read = 0;
    end

    y = zeros(sz, 'like', x);
    if isgpuarray(x)
        y = gpuArray(y);
    end

    if M == 1
        x1 = x;
    else
        x1 = x/M;
    end
    for m = 1:M
        y = y + quanta_sample_direct(x1, sz, 1, sigma_read);
    end
end

