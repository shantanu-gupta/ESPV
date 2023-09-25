init;

DATA_FILE = fullfile(DATA_BASEDIR, 'fig05_vision_0604-jump-1');

filts.velocities = [1 -1 0.3 -0.3 0];
filts.orientations = [0 60 120];
filts.min_wavelength = 4;
filts.num_scales = 3;

TPC_NOISE_THRESH_ZMIN = 2;

% ESTR_VIS_PRCTILE_THRESH = [93 97];
% FLO1_VIS_THICKEN = 1;

OUTPUT_NAME = 'Fig05_02';

% For crop from paper
OUT_IMIN = 1;
OUT_IMAX = 256;
OUT_JMIN = 128;
OUT_JMAX = OUT_JMIN + 256 - 1;

run_base;
