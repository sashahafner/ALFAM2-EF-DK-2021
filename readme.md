# ALFAM2-EF-DK-2021
This repository contains all the files used to calculate emission factors for NH3 loss from field-applied animal manure for Denmark.
The work in this repository is described in detail in a [report available online](<add URL when available>).

# Contents
This repository includes 13 directories, all but one (`database`) containing R scripts for carrying out the analyses described below.
Each of these remaining 12 includes a script named `main.R` in the `scripts` subdirectory.
This scripts calls the other R scripts within each directory, and should be used to repeat calculations and produce output.
Output is usually placed in an `output` subdirectory, and plots can be found in `plots`.

Tables or appendices referred to below are those in [the report](add URL).

* database
ALFAM2 data used for model calibration and other tasks based on emission measurements.
These data came directly from the [ALFAM2-data repository](https://github.com/sashahafner/ALFAM2-data) (v1.4).

* `emission_factors`
Calculation of emission factors, i.e., the primary product of this work.
Model parameters are read from `model_cal` directory.
Emission factors are in `emission_factors/output`.
Results presented in Section 4.2 of the report.
Files in `output` generally have names that match objects in the report.

* functions
Definition of some functions used in other directories.

* `model_cal`
Calibration of ALFAM2 model.
Includes calculation of all parameter values except for pH based on optimizing fit to measured emission.
Several alternatives are explored.
Incorporation parameter values are calculated here using a subset of experiments.
Parameters used for calculation of emission factors are in `output/pars_set2.csv`.
May take hours to run.
Model performance statistics in `output/fit_summ2.csv` are given in Table A9.1.

* `model_cal_pH`
Calibration of ALFAM2 model with respect to pH only.
Resulting median parameters from `output/pars_acid_med.csv` are included with others *manually* in `model_cal/scripts/cal.R`.
Emission data used here include some not yet in ALFAM2 database (see `model_cal_pH/data` and Appendix 3 in the report).

* `model_fit`
Evaluation of model fit based on all calibration data.
Both graphical (see `plots`) and numeric (see `output`).
Table A9.2 in report is from `output/fit_summ.csv`.

* `model_structure`
Exploration of importance of r3 parameter.
Results presented in Appendix 2 in report.

* `pH_effects`
Exploration of apparent pH effects to determine if pH should be included in model.
Results presented in Appendix 5.

* `sens_inputs`
Quantification of model sensitivity to value of predictor variables.
Results presented in Appendix 4.

* `slurry_composition`
Calculation of mean slurry composition based on data from various sources.
Results presented in Table 3.
See `slurry_composition/data/original` for original data.

* weather
Calculation mean climate based on DMI weather.
Resulting means in `output/weather_means.csv` are given in Table 4.

* `weather_high_res`
Evaluation of effect of weather resolution (fixed means vs. 3 hour means) on calculated emission.
Results presented in Appendix 6.

* `examples`
Example calculations as described in Appendix 11 in the report.

* `software_versions`
See the file `software_versions.txt` for a record of the package and R versions used for calculations.
Run `main.R` to create a new version (although this generally won't make sense to do).

# Running scripts
To calculate emission factors, run `emission_factors/main.R` using [R](https://www.r-project.org/). 
For the complete calculation of emission factors and all supporting analyses can be repeated by running the main.R script withing the scripts subdirectory within each of the directories listed above (except database and functions). 
Results are written to files in the output and plots subdirectories.
See the logs subdirectory where relevant for ALFAM2 package version, or pars.txt to check parameter values.
Other required packages are listed in the packages.R scripts.
Unfortunately, it is possible that these scripts will not work (or will work differently) with future versions of R or the add-on packages used here.
All calculations were originally carried out using R version 3.6.3 and ALFAM2 version 0.3.2, but scripts were later updated to work with R v4.1.1 (change in default for `stringsAsFactors` argument in `read.csv()` was addressed) and ALFAM2 v0.5.0 (change in default parameter values was addressed).
If necessary, see `software_versions/software_versions.txt`.


# More information
For more information on the ALFAM2 model and project see [www.alfam.dk](www.alfam.dk).
