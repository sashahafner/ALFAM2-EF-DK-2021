# Determination of pH parameters
# S. Hafner

rm(list = ls())

source('packages.R')
source('functions.R')
source('load.R')
source('clean.R')
sink('../logs/subset.txt')
  source('subset.R', echo = TRUE, max.deparse.length = Inf)
sink()
sink('../logs/calibration.txt')
  source('cal_acid.R', echo = TRUE)
  warnings()
sink()
render('boot.Rmd', output_dir = '../reports')
source('plots.R')
