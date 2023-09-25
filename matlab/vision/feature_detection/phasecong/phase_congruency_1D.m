function [PC] = phase_congruency_1D(R, prm)
%PHASE_CONGRUENCY_1D
    % TODO: use 'arguments' syntax
    if nargin < 2 || isempty(prm)
        prm = struct;
    end

    if ~isfield(prm, 'weight_g')
        prm.weight_g = 10;
    end
    if ~isfield(prm, 'cut_off')
        prm.cut_off = 0.5;
    end
    if ~isfield(prm, 'noise_std_est')
        prm.noise_std_est = [];
    end
    if ~isfield(prm, 'noise_thresh_zmin')
        prm.noise_thresh_zmin = 2;
    end
    if ~isfield(prm, 'deviation_gain')
        prm.deviation_gain = 1.5;
    end
    
    sum_R = zeros(size(R{1}), 'like', R{1});
    sum_MagR = zeros(size(sum_R), 'like', real(R{1}));
    max_MagR = [];

    num_scales = numel(R);
    for s = 1:num_scales
        sum_R = sum_R + R{s};
        MagR = abs(R{s}); % Amplitude of even & odd filter response.
        sum_MagR = sum_MagR + MagR;  % Sum of amplitude responses.
        if isempty(max_MagR)
            max_MagR = MagR;
        else
            % Record maximum amplitude of components across scales.  This is needed
            % to determine the frequency spread weighting.
            max_MagR = max(max_MagR,MagR);   
        end
    end

    % Form weighting that penalizes frequency distributions that are
    % particularly narrow.  Calculate fractional 'width' of the frequencies
    % present by taking the sum of the filter response amplitudes and dividing
    % by the maximum amplitude at each point on the video.   If
    % there is only one non-zero component width takes on a value of 0, if
    % all components are equal width is 1.
    width = ((sum_MagR./max(eps('single'), max_MagR)) - 1) / (num_scales - 1);
    % Now calculate the sigmoidal weighting function for this orientation.
    weight = 1.0 ./ (1 + exp((prm.cut_off - width) * prm.weight_g)); 

    % Get energy of sum of responses
    XEnergy = abs(sum_R);

    % check for weirdness
    tol = 1e-4;
    if any((XEnergy - sum_MagR) > tol, "all")
        fprintf(2, 'phase_congruency_1D: XEnergy > sum_MagR!\n');
    end

    XEnergy = min(XEnergy, sum_MagR);

    % Apply noise threshold
    if isempty(prm.noise_std_est)
        % TODO: copy over Kovesi's noise estimate
        fprintf(2, 'phase_congruency_1D: noise_std_est not supplied.\n');
    else
        % calculate z-scores
        % for 1 component (real/imag) we want the 0.5 factor
        z_XEnergy = XEnergy ./ prm.noise_std_est;
        w_noise = 1 - exp(-max(0, z_XEnergy - prm.noise_thresh_zmin));
        weight = weight .* w_noise;
    end

    % Apply weighting to energy and then calculate phase congruency
    PC = weight .* max(0, 1 - prm.deviation_gain * acos(XEnergy ...
                                                        ./ max(sum_MagR, eps('single'))));
end

