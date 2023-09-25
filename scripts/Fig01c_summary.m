init;

DATA_FILE = fullfile(DATA_BASEDIR, 'fig01c1_qbp_0115-ball-blocks-f4-tworow');

filts.min_wavelength = 6;
filts.orientations = [0 60 120];

ESTR_VIS_PRCTILE_THRESH = [93 97];
FLO1_VIS_THICKEN = 1;

OUT_IMIN = 41;
OUT_IMAX = OUT_IMIN + 180 - 1;
OUT_JMIN = 170;
OUT_JMAX = OUT_JMIN + 180 - 1;

OUTPUT_NAME = 'Fig01c';

run_base;
