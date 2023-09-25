function [f] = fft_freqs(N)
%FFT_FREQS
    f = (1/N) * range_zero_centered(N);
end

