function [xv] = range_zero_centered(N)
%RANGE_ZERO_CENTERED
    if mod(N,2)
        xv = -(N-1)/2:(N-1)/2;
    else
        xv = -N/2:(N/2-1); 
    end
end

