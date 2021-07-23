# Example calculation of emission factors

# Package
library(ALFAM2)
packageVersion('ALFAM2')

source('../functions/rounddf.R')

# Load parameters
pars <- read.csv('../model_cal/output/pars_set2.csv', row.names = 1)
pars <- as.matrix(pars)[, 1]

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
