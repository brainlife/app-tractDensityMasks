[![Abcdspec-compliant](https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg)](https://github.com/brain-life/abcd-spec)
[![Run on Brainlife.io](https://img.shields.io/badge/Brainlife-bl.app.498-blue.svg)](https://doi.org/10.25663/bl.app.498)

# app-tractDensityMasks

 This app creates a streamline density mask (NIfTI format) for each
 structure labled in a classification structure and saves it to disk.

##  Code provenance

### Author
- [Dan Bullock](dnbulloc@iu.edu)

### Contributors
- [Dan Bullock](dnbulloc@iu.edu)

#### Copyright (c) 2020 

### Funding Acknowledgement
brainlife.io is publicly funded and for the sustainability of the project it is helpful to Acknowledge the use of the platform. We kindly ask that you acknowledge the funding below in your code and publications. Copy and past the following lines into your repository when using this code.

[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-1636893](https://img.shields.io/badge/NSF_BCS-1636893-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NSF-ACI-1916518](https://img.shields.io/badge/NSF_ACI-1916518-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1916518)
[![NSF-IIS-1912270](https://img.shields.io/badge/NSF_IIS-1912270-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1912270)
[![NIH-NIBIB-R01EB029272](https://img.shields.io/badge/NIH_NIBIB-R01EB029272-green.svg)](https://grantome.com/grant/NIH/R01-EB029272-01)

### Citations
We ask that you the following articles when publishing papers that used data, code or other resources created by the brainlife.io community.

1. Avesani, P., McPherson, B., Hayashi, S. et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. Sci Data 6, 69 (2019). [https://doi.org/10.1038/s41597-019-0073-y](https://doi.org/10.1038/s41597-019-0073-y)

#### See also

[mrtrix3 tckmap](https://mrtrix.readthedocs.io/en/latest/reference/commands/tckmap.html)


## App / Code usage

### Code interaction

#### INPUTS

  - classification: Either the path to structure or the structure itself.
  The strucure has a field "names" with (N) names of the tracts classified
  while the field "indexes" has a j long vector (where  j = the nubmer of
  streamlines in wbFG (i.e. length(wbFG.fibers)).  This j long vector has
  a 0 for to indicate a streamline has gone unclassified, or a number 1:N
  indicatate that the streamline has been classified as a member of tract
  (N). See https://brainlife.io/datatype/5cc1d64c44947d8aea6b2d8b for more
  info.

 - tractogram: also known as a WBFG in other functions.  A composite
 tractogragpy structure which is associated with the input
 classificationstructure.  Contains those streamlines which are labeled by
 the classification structure.

 - referenceNifti:  The reference NIfTI that is to be used as the reference
 for generating the mask.  Theoretically it may be possible to write a
 function of this sort without using a reference NIfTI

 - outdir: the out directory in which the output densityMasks/maps are to be
 saved

 - voxelResize:  the voxel resize parameter.  0 or [] results in no
 resizing.  Input value indicates the desired isometric voxel size of the
 output.  WARNING:  given that the node sampling rate is ~ 1mm, resizing
 of less than 1mm can result in masks with many holes.  Recomend use of
 smoothing to combat this.

 - threshold:  The minimum number of streamlines (nodes, in practice)
 required in a voxel needed to prevent the value from being thresheld to
 0 This is applied AFTER the voxel resize but BEFORE any smoothing is
 applied.

 - smoothParam: the smoothing kernel (necessarily odd, corresponding to
 diameter +1) to be applied to the mask.  Currently implemented as
 gaussian

 - normalizeBool:  Whether or not to apply normalization.  This will occur
 at the last step.  Will divide by highest density such that values range
 from 0 to 1.

#### OUTPUTS

 - densityMask:  A NIfTI mask containing the density mask corresponding to
  the input tract.

### Local usage for the App:
Given that this is compiled code, setting the config.json entries to the appropriate paths and values should be sufficient to permit running locally

### Usage of the App on brainlife.io
When an App is requested to run on brainlife.io, the platform will do the following:

A. Stage the code inside this git repo on a computing resource.

B. Stage the input data requested to run the App on.

C. Created a config.json in the same working directory of the App and Data in the computing resource.

The config.json file contains the parameters and the path to the input data needed for the App to run. The App paramters are set by the brainlife.io users interface when the App is called and saved inside the config.json. The input data (a T1w nifti file in this case) is selected by the user during the process of requesting the App on brainlife.io 

Running the App on brainlife.io really means "execute this main.m script on a computing resource." 

You can submit this App online at [https://doi.org/10.25663/bl.app.498](https://doi.org/10.25663/bl.app.498) via the "Execute" tab.

### Modules used

- [jsonlab](https://github.com/fangq/jsonlab)
- [wma_tools](https://github.com/DanNBullock/wma_tools)
- [spm12](https://github.com/spm/spm12)
- [mba](https://github.com/francopestilli/mba)
- [vistasoft](https://github.com/vistalab/vistasoft)
