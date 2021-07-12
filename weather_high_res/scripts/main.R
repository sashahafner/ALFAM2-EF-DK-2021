# Runs complete weather resolution analysis

rm(list = ls())

source('packages.R')
source('functions.R')
source('settings.R')
source('pars.R')
source('load.R')
source('clean.R')
source('hour_inputs.R')
source('mean_inputs.R')
render('predict.Rmd', output_dir = '../logs')
render('case.Rmd', output_dir = '../logs')
source('export.R')
source('plots.R')
