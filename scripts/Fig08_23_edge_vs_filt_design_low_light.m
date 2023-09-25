init;

DATA_FILE = fullfile(DATA_BASEDIR, 'fig08_vision_0604-ball-3');

filts.velocities = [1 -1 0.3 -0.3 0];
filts.orientations = [0 30 60 90 120 150];
filts.min_wavelength = 6.3;
filts.num_scales = 3;

TPC_NOISE_THRESH_ZMIN = 2;

OUTPUT_NAME = 'Fig08_23';

% For crop from paper
OUT_IMIN = 1;
OUT_IMAX = 256;
OUT_JMIN = 94;
OUT_JMAX = OUT_JMIN + 256 - 1;

run_base;
