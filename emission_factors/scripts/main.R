# Calculates emission factors using ALFAM2 model

rm(list = ls())

source('packages.R')
source('functions.R')
source('load.R')
source('pars.R')
source('prep.R')
render('predict.Rmd', output_dir = '../logs')
source('clean.R')
source('export.R')
source('plots.R')
