# Example calculation of emission factors

# Package
library(ALFAM2)
library(readxl)

packageVersion('ALFAM2')

source('../../functions/rounddf.R')

## Load parameters
#pars <- read.csv('../model_cal/output/pars_set2.csv', row.names = 1)
#pars <- as.matrix(pars)[, 1]

# Enter parameter values manually for clarity
pars <- c(int.f0 = -0.605683377135473,
          app.mthd.os.f0 = -1.74351499199106,
          app.rate.ni.f0 = -0.0111490009460872,
          man.dm.f0 = 0.399670699937794,
          man.source.pig.f0 = -0.592028581423498,
          app.mthd.cs.f0 = -7.63373787323506,
          int.r1 = -0.939215157554942,
          app.mthd.bc.r1 = 0.793524800080501,
          man.dm.r1 = -0.139881887708132,
          air.temp.r1 = 0.0735426766754151,
          wind.2m.r1 = 0.150267203970342,
          app.mthd.ts.r1 = -0.459071351818907,
          ts.cereal.hght.r1 = -0.244712378321887,
          man.ph.r1 = 0.665,
          int.r2 = -1.79918545831297,
          rain.rate.r2 = 0.394021556916743,
          int.r3 = -3.22841225187594,
          app.mthd.bc.r3 = 0.561539558429444,
          app.mthd.cs.r3 = -0.666474172842208,
          man.ph.r3 = 0.238,
          incorp.shallow.f4 = -0.964966548279922,
          incorp.shallow.r3 = -0.580526893811793,
          incorp.deep.f4 = -3.6949495394145,
          incorp.deep.r3 = -1.2656956200405)

# Create data frame with inputs
dat <- as.data.frame(read_xlsx('../inputs/inputs.xlsx', sheet = 1))
dat$ct <- 168
dat$rain.rate <- 0.09
dat$tan.app <- 100
dat$app.rate.ni <- ifelse(grepl('injection$', dat$app.mthd), 0, 30)
dat$app.mthd.cs <- ifelse(dat$app.mthd == 'Closed slot injection', TRUE, FALSE)
dat$app.mthd.os <- ifelse(dat$app.mthd == 'Open slot injection', TRUE, FALSE)
dat$man.source.pig <- ifelse(dat$man.source == 'Pig', TRUE, FALSE)
dat$incorp.deep <- ifelse(dat$incorp == 'Deep', TRUE, FALSE)

preds <- ALFAM2mod(dat, pars = pars, app.name = 'tan.app', time.name = 'ct', time.incorp = 't.incorp',
                   group = 'id', warn = TRUE)

## Check with default pars (gives identical results)
#preds <- ALFAM2mod(dat, app.name = 'tan.app', time.name = 'ct', time.incorp = 't.incorp',
#                   group = 'id', warn = TRUE)


dat$EF <- signif(100 * preds$er, 2)
dat$flag <- ifelse(dat$EF.report != dat$EF, 'Check', '')

write.csv(preds, '../output/preds.csv', row.names = FALSE)
write.csv(dat, '../output/DCE_EFs.csv', row.names = FALSE)
