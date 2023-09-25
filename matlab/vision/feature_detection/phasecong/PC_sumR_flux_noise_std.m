function [noise_std] = PC_sumR_flux_noise_std(flux_noise_std, filtEs)
%PC_SUMR_FLUX_NOISE_STD
    % for 1 component (real/imag) we want the 0.5 factor    
    noise_std = max(eps('single'), ...
                    flux_noise_std * sqrt(0.5 * (sum(sqrt(filtEs), 'all')^2)));
end

