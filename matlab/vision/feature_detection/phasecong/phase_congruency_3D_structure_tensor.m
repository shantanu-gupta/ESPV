function [PC_x2, PC_y2, PC_t2, PC_xy, PC_yt, PC_xt, PC_per_dir] ...
                    = phase_congruency_3D_structure_tensor(R, dirs, prm)
%PHASE_CONGRUENCY_3D_STRUCTURE_TENSOR
    arguments
        R cell
        dirs (:,3)
        prm.flux_noise_std (:,:,:)
        prm.filter_energies (:,:)
        prm.noise_thresh_zmin single = 2
        prm.input_size uint32 = []
    end

    num_dirs = size(dirs, 1);
    assert(size(R, 1) == num_dirs);

    noise_std_est = {};
    if isfield(prm, 'flux_noise_std') && isfield(prm, 'filter_energies')
        noise_std_est = cell(num_dirs, 1);
        for n = 1:num_dirs
            noise_std_est{n} = PC_sumR_flux_noise_std(prm.flux_noise_std, ...
                                                    prm.filter_energies(n,:));
        end
    end

    PC_x2 = zeros(size(R{1,1}, [1 2 3]), 'like', real(R{1,1}));
    PC_y2 = zeros(size(PC_x2), 'like', PC_x2);
    PC_t2 = zeros(size(PC_x2), 'like', PC_x2);
    PC_xy = zeros(size(PC_x2), 'like', PC_x2);
    PC_yt = zeros(size(PC_x2), 'like', PC_x2);
    PC_xt = zeros(size(PC_x2), 'like', PC_x2);

    if nargout >= 7
        PC_per_dir = cell(num_dirs, 1);
    else
        PC_per_dir = {};
    end

    nonempty_check = @(x) ~isempty(x);
    valid_dirs = [];

    for ind_dir = 1:num_dirs
        R_n = R(ind_dir, :);
        dir_n = dirs(ind_dir, :);
        if sum(cellfun(nonempty_check, R_n), 'all') >= 2
            valid_dirs = [valid_dirs ind_dir]; %#ok<AGROW> 

            R_n = R_n(cellfun(nonempty_check, R_n));
            for s = 1:numel(R_n)
                if ~isempty(prm.input_size) && any(size(R_n{s}) ~= prm.input_size)
                    R_n{s} = imresize3(R_n{s}, prm.input_size, 'lanczos3');
                end
            end

            prm_n = prm;
            if ~isempty(noise_std_est)
                noise_n = noise_std_est{ind_dir};
                if any(size(noise_n) ~= size(R_n{1}))
                    noise_n = imresize3(noise_n, size(R_n{1}), 'nearest');
                end
                prm_n.noise_std_est = noise_n;
            end

            PC = phase_congruency_1D(R_n, prm_n);
            if ~isempty(PC_per_dir)
                PC_per_dir{ind_dir} = PC;
            end

            ex = dir_n(1); ey = dir_n(2); et = dir_n(3);
            PC2 = PC.^2;
            PC_x2 = PC_x2 + (PC2 .* (ex^2));
            PC_y2 = PC_y2 + (PC2 .* (ey^2));
            PC_t2 = PC_t2 + (PC2 .* (et^2));
            PC_xy = PC_xy + (PC2 .* (ex*ey));
            PC_yt = PC_yt + (PC2 .* (ey*et));
            PC_xt = PC_xt + (PC2 .* (ex*et));
        else
            fprintf(2, 'Not enough responses for direction #%d = [%s].\n', ...
                        ind_dir, num2str(dir_n));
        end
    end

    dirs_valid = dirs(valid_dirs, :);
    norm_factor = 3.0 ./ sum(dirs_valid.^2, 'all');
    PC_x2 = norm_factor * PC_x2;
    PC_y2 = norm_factor * PC_y2;
    PC_t2 = norm_factor * PC_t2;
    PC_xy = norm_factor * PC_xy;
    PC_yt = norm_factor * PC_yt;
    PC_xt = norm_factor * PC_xt;
end
