function [I_thin] = nms3(I, ori, phi, radius)
%NMS3 NON-MAXIMUM SUPPRESSION in 3D
%   Adapts Kovesi's implementation mainly, and allows using gpuArray
    if nargin < 3 || isempty(phi)
        assert(nargin < 2 || isempty(ori));
        oriented = false;
    else
        oriented = true;
    end
    if nargin < 4 || isempty(radius)
        radius = 1.7;
    end

    if oriented
        use_gpuArray = false;
        if isgpuarray(I)
            assert(isgpuarray(ori));
            assert(isgpuarray(phi));
            use_gpuArray = true;
        end
    
        thetavals = deg2rad(0:360); % is 1 x K
        phivals = deg2rad(0:90)';  % is K x 1
    
        if use_gpuArray
            thetavals = gpuArray(thetavals);
            phivals = gpuArray(phivals);
        end
    
        toff = radius * cos(phivals);
        xoff = radius * (sin(phivals) .* cos(thetavals));
        yoff = radius * (sin(phivals) .* sin(thetavals));

        [rows, cols, frames] = size(I);
        xv = 1:cols; yv = 1:rows; tv = 1:frames;
        if use_gpuArray
            xv = gpuArray(xv); yv = gpuArray(yv); tv = gpuArray(tv);
        end
        [xx, yy, tt] = meshgrid(xv, yv, tv);
    
        % assume phi is rounded and in range (0, 90)
        ind_toff = 1 + phi(:);
        % assume ori is rounded and in range (0, 360)
        ind_spoff0 = 1 + ori;
        ind_spoff = sub2ind(size(xoff), ind_toff(:), ind_spoff0(:));
    
        tt1 = reshape(max(1, min(frames, tt(:) + toff(ind_toff))), size(tt));
        xx1 = reshape(max(1, min(cols, xx(:) + xoff(ind_spoff))), size(xx));
        yy1 = reshape(max(1, min(rows, yy(:) + yoff(ind_spoff))), size(yy));
    
        tt2 = reshape(max(1, min(frames, tt(:) - toff(ind_toff))), size(tt));    
        xx2 = reshape(max(1, min(cols, xx(:) - xoff(ind_spoff))), size(xx));
        yy2 = reshape(max(1, min(rows, yy(:) - yoff(ind_spoff))), size(yy));

        method = 'cubic';
        if isgpuarray(I)
            method = 'linear';
        end
        I1 = interp3(I, xx1, yy1, tt1, method);
        I2 = interp3(I, xx2, yy2, tt2, method);

        isnonmax = or(I < I1, I < I2);
        I_thin = I;
        I_thin(isnonmax) = 0;
    else
        I_thin = I;
        fprintf(2, '3D NMS not implemented yet because ordfilt3 is not in-built.\n');
        % radius_int = ceil(radius);
        % I_localmax = ordfilt2(I, radius_int^2, ones([radius_int radius_int]));
        % lose = (I ~= I_localmax);
        % I_thin(lose) = 0;
    end
end

