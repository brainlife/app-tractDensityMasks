function main()
% for app-tractDensityMasks
%
% This function creates a density mask (NIfTI format) for each
% structure labled in a classification structure and saves it to disk
%
% INPUTS
%
%  classification: Either the path to structure or the structure itself.
%  The strucure has a field "names" with (N) names of the tracts classified
%  while the field "indexes" has a j long vector (where  j = the nubmer of
%  streamlines in wbFG (i.e. length(wbFG.fibers)).  This j long vector has
%  a 0 for to indicate a streamline has gone unclassified, or a number 1:N
%  indicatate that the streamline has been classified as a member of tract
%  (N). See https://brainlife.io/datatype/5cc1d64c44947d8aea6b2d8b for more
%  info.
%
% tractogram: also known as a WBFG in other functions.  A composite
% tractogragpy structure which is associated with the input
% classificationstructure.  Contains those streamlines which are labeled by
% the classification structure.
%
% referenceNifti:  The reference NIfTI that is to be used as the reference
% for generating the mask.  Theoretically it may be possible to write a
% function of this sort without using a reference NIfTI
%
% outdir: the out directory in which the output densityMasks/maps are to be
% saved
%
% voxelResize:  the voxel resize parameter.  0 or [] results in no
% resizing.  Input value indicates the desired isometric voxel size of the
% output.  WARNING:  given that the node sampling rate is ~ 1mm, resizing
% of less than 1mm can result in masks with many holes.  Recomend use of
% smoothing to combat this.
%
% threshold:  The minimum number of streamlines (nodes, in practice)
% required in a voxel needed to prevent the value from being thresheld to
% 0.  This is applied AFTER the voxel resize but BEFORE any smoothing is
% applied.
%
% smoothParam: the smoothing kernel (necessarily odd, corresponding to
% diameter +1) to be applied to the mask.  Currently implemented as
% gaussian
%
% normalizeBool:  Whether or not to apply normalization.  This will occur
% at the last step.  Will divide by highest density such that values range
% from 0 to 1.
%
%  OUTPUTS
%
%  densityMask:  A NIfTI mask containing the density mask corresponding to
%  the input tract.
%
% 
% switch getenv('ENV')
%     case 'IUHPC'
%         disp('loading paths (HPC)')
%         addpath(genpath('/N/u/brlife/git/jsonlab'))
%         addpath(genpath('/N/u/brlife/git/vistasoft'))
%         addpath(genpath('/N/u/brlife/git/afq-master'))
%         addpath(genpath('/N/u/kitchell/Karst/Applications/iso2mesh'))
%         addpath(genpath('/N/u/kitchell/Carbonate/wma_tools'))
%         addpath(genpath('/N/u/kitchell/Carbonate/mrtrix3/matlab'))
%     case 'VM'
%         disp('loading paths (VM)')
%         addpath(genpath('/usr/local/jsonlab'))
%         addpath(genpath('/usr/local/iso2mesh'))
%         addpath(genpath('/usr/local/vistasoft'))
%         addpath(genpath('/usr/local/afq-master'))
% end

% load config.json
config = loadjson('config.json');

disp('config dump')
disp(config)

%make output directory
mkdir('masks')

%read in components of config file
referenceNifti = niftiRead(config.t1);
tractogram= fgRead(config.tractogram);
load(config.WMC);
voxelResize=config.voxelResize;
threshold=config.threshold;
smoothParam=config.smoothParam;
normalizeBool=config.normalizeBool;

bsc_densityMapsFromClassification(classification, tractogram, referenceNifti, 'masks', voxelResize, threshold, smoothParam, normalizeBool)

end

