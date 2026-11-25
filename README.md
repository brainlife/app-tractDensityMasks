<h1 align="center">Track Density Masks</h1>

<p align="center">
  A streamline density map, in NIfTI format, for every tract in a white matter classification, in the space of a reference T1.
</p>

<p align="center">
  <a href="https://github.com/brainlife/abcd-spec"><img src="https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg" alt="ABCD Spec v1.1"></a>
  <a href="https://doi.org/10.25663/brainlife.app.498"><img src="https://img.shields.io/badge/Brainlife-brainlife.app.498-blue.svg" alt="Run on brainlife.io"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-lightgrey.svg" alt="MIT license"></a>
</p>

## At a glance

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

> **Creates a streamline density map (NIfTI) for each tract in a white matter classification, with optional resizing, thresholding, smoothing and normalisation, using wma_tools.**

Runs bsc_densityMapsFromClassification on the tractogram and classification in the T1's space and writes one density image per tract. Use it to turn tracts into volumetric masks or density maps for overlap or ROI analyses.

| | |
|---|---|
| **Inputs** | `neuro/anat/t1w` · `neuro/track/tck` · `neuro/wmc` |
| **Outputs** | `neuro/tractmasks` |
| **Container** | `brainlife/mcr:neurodebian1604-r2017a` |
| **Resources** | 1 CPUs |
| **Run it** | [doi.org/10.25663/brainlife.app.498](https://doi.org/10.25663/brainlife.app.498) |

#### Inputs

| Input | Datatype | Required | Description |
|---|---|---|---|
| `t1` | `neuro/anat/t1w` | yes | A reference T1 from which will provide the reference space that the density mask will be created in. |
| `tractome` | `neuro/track/tck` | yes | The source tractome that the WMC data object is associated with |
| `classification` | `neuro/wmc` | yes | White matter classification (classification.mat) labelling the tracts. Must index the streamlines of the given tractogram. |

#### Outputs

| Output | Datatype | Description |
|---|---|---|
| `masks` | `neuro/tractmasks` | NIfTI density masks for each of the structures listed in the input WMC object. |

<details>
<summary><b>Parameters</b> (4)</summary>

| Parameter | Type | Default | Description |
|---|---|---|---|
| `voxelResize` | number | `1` | the voxel resize parameter. 0 or [] results in no resizing. Input value indicates the desired isometric voxel size of the output. WARNING: given that the node sampling rate is ~ 1mm, resizing of less than 1mm can result in masks with many holes. Recommend use of smoothing to combat this. |
| `threshold` | number | `0` | The minimum number of streamlines (nodes, in practice) required in a voxel needed to prevent the value from being thresheld to 0. This is applied AFTER the voxel resize but BEFORE any smoothing is applied. |
| `smoothParam` | number | `1` | the smoothing kernel (necessarily odd, corresponding to diameter +1) to be applied to the mask. Currently implemented as gaussian. |
| `normalizeBool` | boolean | `false` | Whether or not to apply normalization. This will occur at the last step. Will divide by highest density such that values range from 0 to 1. |

</details>

<!-- brainlife-app:end -->

## How it works

The App runs `bsc_densityMapsFromClassification` from [wma_tools](https://github.com/DanNBullock/wma_tools) (compiled MATLAB) on a tractogram and the [white matter classification (WMC)](https://brainlife.io/datatype/5cc1d64c44947d8aea6b2d8b) that labels its streamlines, and writes one density image per tract on the grid of the reference T1. Use it to turn tracts into volumetric masks or density maps for overlap or ROI analyses.

The classification has a `names` field with the N tract names and an index vector with one entry per streamline of the tractogram: 0 for an unclassified streamline, or 1..N for the tract it belongs to. The tractogram (also called a whole-brain fiber group, WBFG) must be the one the classification was made on.

The steps, in order, are controlled by four parameters:

- `voxelResize`: the isotropic voxel size of the output, in mm; `0` keeps the T1 grid. Because streamline nodes are sampled about every 1 mm, resizing below 1 mm can leave many holes in the masks; use smoothing to fill them.
- `threshold`: the minimum number of streamlines (in practice, nodes) a voxel needs to keep a non-zero value. Applied after resizing and before smoothing.
- `smoothParam`: the size of the Gaussian smoothing kernel (odd, kernel diameter + 1).
- `normalizeBool`: divide by the highest density so values range from 0 to 1. Applied last.

See also MRtrix3 [`tckmap`](https://mrtrix.readthedocs.io/en/latest/reference/commands/tckmap.html).

## Running the App

### On brainlife.io

Open the App at [doi.org/10.25663/brainlife.app.498](https://doi.org/10.25663/brainlife.app.498), choose a reference T1 (`neuro/anat/t1w`), the tractogram (`neuro/track/tck`) and its classification (`neuro/wmc`), set the parameters and press **Execute**. The maps are archived to your project as a `neuro/tractmasks` dataset tagged `density`.

### Locally

You need [Singularity/Apptainer](https://apptainer.org/). The code is compiled MATLAB and `main` runs it in the `brainlife/mcr:neurodebian1604-r2017a` container, so setting the `config.json` entries is enough; MATLAB is not needed.

1. Clone this repository.
2. Create `config.json` with the paths to your inputs and the parameters:

   ```json
   {
       "t1": "/input/t1/t1.nii.gz",
       "tractogram": "/input/track/track.tck",
       "WMC": "/input/wmc/classification.mat",
       "voxelResize": 1,
       "threshold": 0,
       "smoothParam": 1,
       "normalizeBool": false
   }
   ```

3. Run the App:

   ```bash
   ./main
   ```

## Outputs

```text
masks/
└── masks/
    └── *.nii.gz    one density map per tract in the classification
```

## Citing

> [!TIP]
> If you use this App in your work, please cite the App, the software it builds on and brainlife.io (below). GitHub's **Cite this repository** button gives the App citation in APA and BibTeX.

- Track Density Masks. brainlife.io App. [doi:10.25663/brainlife.app.498](https://doi.org/10.25663/brainlife.app.498)
- Avesani P, McPherson B, Hayashi S, et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. Sci Data 6, 69 (2019). [doi:10.1038/s41597-019-0073-y](https://doi.org/10.1038/s41597-019-0073-y)
- Bullock et al. Associative white matter connecting the dorsal and ventral posterior human cortex. *Brain Structure and Function* 224:2631-2660 (2019). [doi:10.1007/s00429-019-01907-8](https://doi.org/10.1007/s00429-019-01907-8)
- Hayashi S, Caron BA, Heinsfeld AS, et al. brainlife.io: a decentralized and open-source cloud platform to support neuroscience research. *Nature Methods* 21:809–813 (2024). [doi:10.1038/s41592-024-02237-2](https://doi.org/10.1038/s41592-024-02237-2)

## Authors

- [Dan Bullock](https://github.com/DanNBullock)

## Funding

[![Wellcome-226486/Z/22/Z](https://img.shields.io/badge/Wellcome-226486%2FZ%2F22%2FZ-purple.svg)](https://wellcome.org/)
[![NIH-NINDS-U24NS140384](https://img.shields.io/badge/NIH_NINDS-U24NS140384-green.svg)](https://reporter.nih.gov/project-details/11261037)
[![NIH-NINDS-UM1NS132207](https://img.shields.io/badge/NIH_NINDS-UM1NS132207-green.svg)](https://reporter.nih.gov/project-details/11411328)
[![NIH-NIBIB-R01EB029272](https://img.shields.io/badge/NIH_NIBIB-R01EB029272-green.svg)](https://reporter.nih.gov/project-details/10262925)
[![NIH-NIBIB-R01EB030896](https://img.shields.io/badge/NIH_NIBIB-R01EB030896-green.svg)](https://reporter.nih.gov/project-details/10428625)
[![NIH-NIMH-R01MH126699](https://img.shields.io/badge/NIH_NIMH-R01MH126699-green.svg)](https://reporter.nih.gov/project-details/10460628)
[![NIH-NIDCD-R01DC020088](https://img.shields.io/badge/NIH_NIDCD-R01DC020088-green.svg)](https://reporter.nih.gov/project-details/11140284)
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-2203524](https://img.shields.io/badge/NSF_BCS-2203524-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2203524)
[![NSF-IIS-1636893](https://img.shields.io/badge/NSF_IIS-1636893-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NSF-OAC-2148729](https://img.shields.io/badge/NSF_OAC-2148729-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148729)
[![NSF-IIS-1912270](https://img.shields.io/badge/NSF_IIS-1912270-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1912270)
[![NSF-IIS-2148700](https://img.shields.io/badge/NSF_IIS-2148700-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148700)
[![NSF-OAC-1916518](https://img.shields.io/badge/NSF_OAC-1916518-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1916518)

<sub>brainlife.io is publicly funded, and acknowledging that support helps keep it running. This App was developed with support from Wellcome, the U.S. National Institutes of Health (including the BRAIN Initiative BRAIN CONNECTS program: The Axonal Projectome EXchange, U24NS140384, and the Center for Mesoscale Connectomics, UM1NS132207) and the U.S. National Science Foundation.</sub>

## License

[MIT](LICENSE). The App also uses [jsonlab](https://github.com/fangq/jsonlab), [wma_tools](https://github.com/DanNBullock/wma_tools), [spm12](https://github.com/spm/spm12), [mba](https://github.com/francopestilli/mba) and [vistasoft](https://github.com/vistalab/vistasoft), each under its own license.
