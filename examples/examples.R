# Example calculation of emission factors

# Package
library(ALFAM2)
packageVersion('ALFAM2')

source('../functions/rounddf.R')

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
dat <- data.frame(id = c('039-2010', '003-2010', '024-2010', '111-2010', '169-2010'),
                  ct = 168,
                  man.source.pig = c(TRUE, FALSE, FALSE, FALSE, TRUE),
                  app.rate.ni = c(0, 0, 30, 30, 30),
                  man.dm = c(3.9, 6.5, 6.5, 5.1, 3.9),
                  man.ph = c(7.2, 7.0, 7.0, 7.9, 6.0),
                  app.mthd.cs = c(TRUE, FALSE, FALSE, FALSE, FALSE),
                  app.mthd.os = c(FALSE, TRUE, FALSE, FALSE, FALSE),
                  app.mthd.bc = c(FALSE, FALSE, FALSE, TRUE, FALSE),
                  incorp.deep = c(FALSE, FALSE, TRUE, FALSE, FALSE),
                  t.incorp = c(NA, NA, 4, NA, NA),
                  air.temp = c(4.9, 8.5, 16.9, 16.6, 14.6),
                  wind.2m = c(4.02, 3.91, 3.18, 3.22, 3.45),
                  rain.rate = 0.09,
                  tan.app = 100)


preds <- ALFAM2mod(dat, pars = pars, app.name = 'tan.app', time.name = 'ct', 
                   time.incorp = 't.incorp', group = 'id', warn = TRUE)

preds

write.csv(preds, 'example_EF_output.csv', row.names = FALSE)
write.csv(rounddf(preds, 2, func = signif), 'example_EF_output_rounded.csv', row.names = FALSE)
