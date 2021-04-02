% brainlife.io App Template for MatLab code
%
% This file is a template for a matlab-based brainlife.io App 
%
% As example the App simply does the following:
% (1) loads a T1w NIfTI-1 file, 
% (2) sets a new resolution to resampole the file to
% (3) resamples it a 1mm isotropic resolution, and 
% (4) saves the new NIfTI file down to disk in the current directory
% 
% **Local usage for the App:**
% You can run this App locally by copying a NIfTI file of a T1w file inside
% the directory of the file you are reading (the file should be named t1.nii) 
% After that you can invoke this file (main.m) in a matlab prompt and the code 
% will resample the input T1w NIfTI you provided to 1 mm.
% 
% If you want to change the resolution of the file generated you can edit
% the appropriate filed inside the config.json.example provide with the
% github repository you downloaded. The input/output file names of the T1w 
% files can also be changed inside the config.json.example file.
%  
% To set up this App to run locally you will need to have done the following:
% A. Download the code for this App from https://github.com/francopestilli/app-template-matlab. 
%    Save it inside a directory accessible to MatLab, for examople, /mycomputerpath/myResearch/thisTestApp
% B. Copy a T1w NIfTI-1 file inside the same folder: /mycomputerpath/myResearch/thisTestApp
% C. Create a config.json of your own an example file is provided with this repository. The fields inside the config.json my be set as required
%
% **Usage of the App on brainlife.io**
% When an App is requested to run on brainlife.io, the platform will do the following:
% A. Stage the code inside this git repo on a computing resource.
% B. Stage the input data requested to run the App on.
% C. Created a config.json in the same working directory of the App and Data in the computing resource.
%
% The config.json file contains the parameters and the path to the input data needed for the App to run. 
% The App paramters are set by the brainlife.io users interface when the App is called and saved inside the config.json
% The input data (a T1w nifti file in this case) is selected by the user during the process of requesting the App on brainlife.io 
% 
% Running the App on brainlife.io really means "execute this main.m script on a computing resource."
% 
%
% Author: Franco Pestilli
%
% Copyright (c) 2020 brainlife.io 
%
% The University of Texas at Austin

% add submodules (libraries necessary to run some of the code below.
% submodules added to the GitHub repository for this App will be 
% automatically downloaded with the App but will need to be explctily 
% added to the MatLab path. 
addpath(genpath(pwd))

% We load the inputs from an example config.json (actually called
% config.json.example)
% 
% The example config.json,example files contains three fields:
% - the inout file name
% - a parameter specifiying the resolution of the output NIfTI file
% - the file name of the output NIfTI that will be writtn to disk
%
% Note. This command requires the submodule that allows reading JSON files in
% MatLab
config = loadjson('config.json.example');

% We now pass the inputs and outputs read in from the config.json file into
% the function that will load the T1w file, reslice it and write out the new
% resliced file at 1 mm resolution.
%
% This will save out in the current directoryh a file called "T1w_resliced1mm.nii"
% because that is the file name stored in config.outname
reslice_nii(config.t1, ...
            config.outname, ...
            config.outres, ...
            true, true, 2)
        
% reslice usage:
% reslice_nii(old_fn, ...
%             new_fn, ...
%             [voxel_size], ...
%             [verbose], .... 
%             [bg], ...
%             [method], [img_idx], [preferredForm]);


	
