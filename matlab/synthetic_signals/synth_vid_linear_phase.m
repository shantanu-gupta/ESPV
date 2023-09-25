function [P] = synth_vid_linear_phase(sz, freqs)
%LINEAR_PHASE_VIDEO
    H_I = sz(1); W_I = sz(2); N_I = sz(3);
    x_I = cast(1:W_I, 'single');
    y_I = cast(1:H_I, 'single');
    t_I = cast(1:N_I, 'single');
    % -1 to make in range (0, L-1), which hopefully complies with fft
    % conventions without needing to center
    x_I = reshape(x_I-1, 1, []);
    y_I = reshape(y_I-1, [], 1);
    t_I = reshape(t_I-1, 1, 1, []);

    nfilt = size(freqs, 2);
    P = zeros([H_I W_I N_I nfilt], 'single');
    for i1 = 1:nfilt
        kx = freqs(i1,1);
        ky = freqs(i1,2);
        omega = freqs(i1,3);
        P(:,:,:,i1) = angle(exp(1i * (kx*x_I + ky*y_I + omega*t_I)));        
    end
end

