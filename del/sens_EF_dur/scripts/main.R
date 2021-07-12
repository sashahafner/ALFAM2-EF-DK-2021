# Sensitivity of emission factors to duration using ALFAM2 model
# S. Hafner
# 2020

rm(list = ls())

source('packages.R')
source('functions.R')
source('load.R')
source('pars.R')
source('merge.R')
render('predict.Rmd', output_dir = '../logs')
source('clean.R')
source('export.R')
source('plots.R')
