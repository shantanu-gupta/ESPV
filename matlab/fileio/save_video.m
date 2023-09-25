function [] = save_video(burst, filepath, fps)
%SAVE_BURST_VIDEO 
%   burst: H x W x N or H x W x 3 x N
    if nargin < 3 || isempty(fps)
        fps = 20;
    end
    writer = VideoWriter(filepath, 'Archival');
    writer.FrameRate = fps;
    assert((ndims(burst) == 3) || (ndims(burst) == 4));
    N = size(burst, ndims(burst));
    open(writer);
    for n = 1:N
        if ndims(burst) == 3
            frame = burst(:,:,n);
        elseif ndims(burst) == 4
            frame = burst(:,:,:,n);
        end
        if ~isa(frame, 'uint8')
            writeVideo(writer, im2uint8(frame));
        else
            writeVideo(writer, frame);
        end
    end
    close(writer);
end

