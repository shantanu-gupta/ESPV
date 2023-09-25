function [X] = ippd(P)
%IPPD Inverse (of) Probability of Photon Detection
	X = -log(1 - P);
end

