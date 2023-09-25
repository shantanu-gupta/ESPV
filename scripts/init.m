addpath(genpath('matlab'));

clearvars;
[scriptdir, scriptname, ~] = fileparts(mfilename('fullpath'));

DATA_BASEDIR = fullfile(scriptdir, 'data');
OUTPUT_BASEDIR = fullfile(scriptdir, 'output');
OUTPUT_NAME = 'temp';

filts = logGabor_bank_3D_sep_t();

TPC_NOISE_THRESH_ZMIN = 4;
FJ_SOLVE_2D_PXWISE_K = 1e-1;

% avoid periodicity assumption artifacts
N_SKIP_OUTPUT = 15;

OUT_IMIN = 1;
OUT_IMAX = 256;
OUT_JMIN = 1;
OUT_JMAX = 512;

ESTR_VIS_PRCTILE_THRESH = [75 97];
MAX_FLO = 1;    % for both visualization and for reliability estimation
FLO1_VIS_THICKEN = 3;
FLO2_REL_THRESH = 0.5;