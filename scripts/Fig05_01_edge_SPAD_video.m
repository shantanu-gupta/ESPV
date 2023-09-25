init;

DATA_FILE = fullfile(DATA_BASEDIR, 'fig05_vision_0815-warf-1');

filts.velocities = [1 -1 0.3 -0.3 0];
filts.orientations = [0 60 120];
filts.min_wavelength = 5;
filts.num_scales = 3;

TPC_NOISE_THRESH_ZMIN = 2;

% ESTR_VIS_PRCTILE_THRESH = [93 97];
% FLO1_VIS_THICKEN = 1;

OUTPUT_NAME = 'Fig05_01';

% For crop from paper
% OUT_IMIN = 1;
% OUT_IMAX = 256;
% OUT_JMIN = 277;
% OUT_JMAX = 512;

run_base;
