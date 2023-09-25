init;

DATA_FILE = fullfile(DATA_BASEDIR, 'fig09_vision_0505-bicycle-2');

filts.velocities = [1 -1 0.3 -0.3 0];
filts.orientations = [0 60 120];
filts.min_wavelength = 5;
filts.num_scales = 3;

TPC_NOISE_THRESH_ZMIN = 2;

FLO1_VIS_THICKEN = 1;

OUTPUT_NAME = 'Fig09_02';

run_base;
