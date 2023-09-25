function [P] = ppd(X)
%PPD Probability of Photon Detection
	P = 1 - exp(-X);
end

