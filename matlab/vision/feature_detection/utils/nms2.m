function [I_thin] = nms2(I, ori, radius, min_branch_length)
%NMS2 NON-MAXIMUM SUPPRESSION in 2D
%   Adapts Kovesi's implementation mainly, and allows using gpuArray
    if nargin < 2 || isempty(ori)
        oriented = false;
    else
        oriented = true;
    end
    if nargin < 3 || isempty(radius)
        radius = 1.3;
    end
    if nargin < 4 || isempty(min_branch_length)
        min_branch_length = 0;
    end

    if oriented
        use_gpuArray = false;
        if isgpuarray(I)
            assert(isgpuarray(ori));
            use_gpuArray = true;
        end
    
        thetavals = deg2rad(0:180); % is 1 x K
        if use_gpuArray
            thetavals = gpuArray(thetavals);
        end
    
        xoff = radius * cos(thetavals);
        yoff = radius * sin(thetavals);
    
        [rows, cols, frames] = size(I, [1 2 3]);
        xv = 1:cols; yv = 1:rows;
        if use_gpuArray
            xv = gpuArray(xv); yv = gpuArray(yv);
        end
        [xx, yy] = meshgrid(xv, yv);
    
        I_thin = zeros(size(I), 'like', I);
        for n = 1:frames
            frame_n = I(:,:,n); ori_n = ori(:,:,n);
            ind_theta = 1 + max(0, min(180, round(ori_n)));
            xx1 = reshape(max(1, min(cols, xx + xoff(ind_theta))), size(xx));
            yy1 = reshape(max(1, min(rows, yy + yoff(ind_theta))), size(yy));
            xx2 = reshape(max(1, min(cols, xx - xoff(ind_theta))), size(xx));
            yy2 = reshape(max(1, min(rows, yy - yoff(ind_theta))), size(yy));
            I1 = interp2(frame_n, xx1, yy1, 'cubic');
            I2 = interp2(frame_n, xx2, yy2, 'cubic');
            isnonmax = or(frame_n < I1, frame_n < I2);
            if min_branch_length > 0
                isnonmax = ~bwskel(~isnonmax, 'MinBranchLength', min_branch_length);
            end
            frame_n(isnonmax) = 0;
            I_thin(:,:,n) = frame_n;
        end
    else
        I_thin = I;
        radius_int = ceil(radius);
        for n = 1:size(I, 3)
            In = I(:,:,n);
            I_localmax = ordfilt2(In, radius_int^2, ones([radius_int radius_int]));
            lose = (In ~= I_localmax);
            In(lose) = 0;
            I_thin(:,:,n) = In;
        end
    end
end

