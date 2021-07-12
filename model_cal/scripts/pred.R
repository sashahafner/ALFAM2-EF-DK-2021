# Make and merge model predictions

# Fixed parameters - exactly as in cal.R for pH, from cal_incorp for incorp
# These values come from cal_acid.R and cal_incorp.R output in ../output
fixed <- c(man.ph.r1 = 0.6, 
           man.ph.r3 = 0.3,
           incorp.deep.r3 = -1.33,
           incorp.shallow.r3 = -0.575,
           incorp.deep.f4 = -3.28,
           incorp.shallow.f4 = -0.755
          ) 

# Hold predictions in long data frame for graphical comparison
dpredl <- data.frame()
dpredw <- dpred

for (i in names(mods2)) {

  p <- c(mods2[[i]]$coef, fixed)

  preds <- ALFAM2mod(dpred, pars = p, app.name = 'tan.app', time.name = 'ct', time.incorp = 'time.incorp', group = 'pmid')

  # First long format
  names(preds)[-1:-3] <- paste0(names(preds)[-1:-3], '.pred')
  dd <- dpred
  dd$mod <- i
  dd <- data.frame(dd, preds)
  dpredl <- rbindf(dpredl, dd)

  # Also wide format
  names(preds)[-1:-3] <- paste0(names(preds)[-1:-3], '.2', i)
  dpredw <- merge(dpredw, preds, by = c('pmid', 'ct', 'dt'), all = TRUE)

}

# Add predictions with default parameter values and ALFAM1 models
dpred$meas.tech.mm <- TRUE
pred2 <- ALFAM2mod(dpred, app.name = 'tan.app', time.name = 'ct', time.incorp = 'time.incorp', group = 'pmid')
pred1 <- ALFAM1mod(dpred, time.name = 'ct', group = 'pmid')

# First long format
names(pred2)[-1:-3] <- paste0(names(pred2)[-1:-3], '.pred')
dd <- dpred
dd$mod <- 'Default'
dd <- data.frame(dd, pred2)
dpredl <- rbindf(dpredl, dd)

names(pred1)[-1:-3] <- paste0(names(pred1)[-1:-3], '.pred')
dd <- dpred
dd$mod <- 'ALFAM'
dd <- data.frame(dd, pred1)
dpredl <- rbindf(dpredl, dd)

# And wide format
names(pred2)[-1:-3] <- paste0(names(pred2)[-1:-3], '.default')
dpredw <- merge(dpredw, pred2, by = c('pmid', 'ct', 'dt'), all = TRUE)

names(pred1)[-1:-3] <- paste0(names(pred1)[-1:-3], '.ALFAM')
dpredw <- merge(dpredw, pred1, by = c('pmid', 'ct'), all = TRUE)

# Calculate residuals for all models
dpredl$resid.er <- dpredl$er - dpredl$er.pred
dpredl$error.er <- dpredl$er.pred - dpredl$er
