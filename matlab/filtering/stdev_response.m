function [std_R] = stdev_response(flux_noise_std, filter_energy)
%STDEV_RESPONSE
    % for 1 component (real/imag) we want the 0.5 factor
    std_R = max(eps('single'), flux_noise_std .* sqrt(0.5 * filter_energy));
end

