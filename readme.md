# ALFAM2-EF-DK-2021
This repository contains all the files needed to calculate emission factors for NH3 loss from field-applied animal manure for Denmark.
The work in this repository is described in detail in a [report available online](<add URL when available>).

# Directory information
This repository includes the following directories.
Tables or appendices referred to below are in the report.

* database
ALFAM2 data used for model calibration and other tasks based on emission measurements.

* emission_factors
Self-contained calculation of emission factors.
Model parameters read from model_cal directory.
Emission factors in emission_factors/output.
Results presented throughout 

* functions
Definition of some functions used elsewhere.

* model_cal
Calibration of ALFAM2 model.

* model_cal_pH
Calibration of ALFAM2 model with respect to pH only.
Resulting median parameters are included with others manually in model_cal.

* model_fit
Evaluation of model fit.

* model_structure
Exploration of importance of r3 parameter.
Results presented in Appendix 2.

* pH_effects
Exploration of apparent pH effects to determine if pH should be included in model.
Results presented in Appendix 5.

* sens_inputs
Quantification of model sensitivity to value of predictor variables.
Results presented in Appendix 4.

* slurry_composition
Calculation of mean slurry composition based on data from various sources.
Results presented in Table 3.
See slurry_composition/data/original for original data.

* weather
Calculation mean climate based on DMI weather.
Resulting means in output/weather_means.csv are given in Table 4.

* weather_high_res
Evaluation of effect of weather resolution (fixed means vs. 3 hour means) on calculated emission.
Results presented in Appendix 6.

# Running scripts
To calculate emission factors, run emission_factors/main.R using [R](https://www.r-project.org/). 
For the complete calculation of emission factors and all supporting analyses can be repeated by running the main.R script withing the scripts subdirectory within each of the directories listed above (except database and functions). 
Results are written to files in the output and plots subdirectories.
See the logs subdirectory where relevant for ALFAM2 package version, or pars.txt to check parameter values.
Other required packages are listed in the packages.R scripts.

# More information
For more information on the ALFAM2 model and project see [www.alfam.dk](www.alfam.dk).
