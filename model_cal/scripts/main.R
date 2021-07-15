# Runs complete calibration of ALFAM2 model and evaluation of results
# S. Hafner

rm(list = ls())

# Load previous calibration results if needed
#load('../R images/cal.RData')

# Packages and functions
source('packages.R')
source('functions.R')
source('load.R')
source('clean.R')

sink('../logs/subsets.txt')
  source('subsets.R', echo = TRUE, max.deparse.length = Inf)
sink()

source('count_tables.R')
render('explore.Rmd', output_dir = '../reports')

sink('../logs/calibration.txt')
  source('cal_incorp.R', echo = TRUE, verbose = TRUE, max.deparse.length = 300)
  source('cal.R', echo = TRUE, verbose = TRUE, max.deparse.length = 300)
  warnings()
sink()

source('extract_pars.R')
source('extract_preds.R')
source('fit_summ.R')
source('plots.R')

save.image('../R_images/cal.RData')
