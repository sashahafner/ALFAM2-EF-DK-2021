# Calibration for incorporation effects with incorp experiment subset

# List for holding output from all models
mods.incorp <- list()

dfsumm(ds4[, c('country', 'app.mthd', 'incorp', 'e.rel.72', 'e.rel.final')])
table(ds4$meas.tech)

# Set initial guesses for parameters based on earlier calibration (as in paper)
p1 <- c(int.f0 = -0.7364889, 
        int.r1 = -1.1785848,
        int.r2 = -0.9543731, 
        int.r3 = -2.9012937, 
        incorp.deep.f4 = -3.6477259,
        incorp.shallow.f4 = -0.4121023, 
        incorp.deep.r3 = -0.3838862,
        incorp.shallow.r3 = -0.1)

# Separate sets for shallow only or deep only
ps <- c(int.f0 = -0.7364889, 
        int.r1 = -1.1785848,
        int.r2 = -0.9543731, 
        int.r3 = -2.9012937, 
        incorp.shallow.f4 = -0.4121023, 
        incorp.shallow.r3 = -0.1)

pd <- c(int.f0 = -0.7364889, 
        int.r1 = -1.1785848,
        int.r2 = -0.9543731, 
        int.r3 = -2.9012937, 
        incorp.deep.f4 = -3.6477259,
        incorp.deep.r3 = -0.3838862)

# Parameter estimation
#------------------------------------------------------- 
for (i in unique(d4$exper.code)) {
  dd <- subset(d4, exper.code == i)

  cat('\nExperiment ', i, '\n')
  print(unique(as.character(dd$incorp)))

  ilevels <- sort(unique(as.character(dd$incorp)))
  if (identical(ilevels, c('deep', 'none', 'shallow'))) {
    pars <- p1
  } else if (identical(ilevels, c('deep', 'none')))  {
    pars <- pd
  } else if (identical(ilevels, c('none', 'shallow')))  {
    pars <- ps
  } else {
    stop('problem bh712')
  }

  # Look for problem observations before running
  pr <- ALFAM2mod(dd, app.name = 'tan.app', time.name = 'ct',
                  group = 'pmid', pars = pars, parallel = FALSE, add.incorp.rows = TRUE)

  # Should be no NA
  which(is.na(pr$e))

  mods.incorp[[i]] <- list()
  mods.incorp[[i]][['mod']] <- m <- optim(par = pars, fn = function(par) 
                                          resCalcOptim(p = par, dat = dd, to = 'e.int', app.name = 'tan.app', 
                                                  group = 'pmid', time.incorp = 'time.incorp', 
                                                  method = 'TAE', parallel = FALSE, prog = FALSE), 
                                    method = 'Nelder-Mead')
  
  mods.incorp[[i]][['coef']] <- pp <- m$par
  print(pp)
  
  write.csv(pp, paste0('../output/pars_incorp_', i, '.csv'))
  
  # Run model for all observations using parameter estimates
  mods.incorp[[i]][['pred']] <- pr <- ALFAM2mod(d4, app.name = 'tan.app', time.name = 'ct',
                                          group = 'pmid', pars = pp, parallel = FALSE)
}

# Get all parameter estimates
pnm <- names(p1)
pnm <- pnm[order(substr(pnm, nchar(pnm), nchar(pnm)))]

#incorp.pars <- data.frame(row.names = pnm)
incorp.pars <- data.frame()

for(i in 1:length(mods.incorp)) {
  pp <- as.data.frame(t(mods.incorp[[i]]$coef))
  pp$country <- mods.incorp[[i]]$country
  pp$exper <- mods.incorp[[i]]$exper
  pp$man.source <- mods.incorp[[i]]$man.source
  incorp.pars <- rbindf(incorp.pars, pp)
}

pars.incorp.mn <- apply(incorp.pars, 2, mean, na.rm = TRUE)
pars.incorp.md <- apply(incorp.pars, 2, median, na.rm = TRUE)

write.csv(incorp.pars, '../output/pars_incorp.csv')
write.csv(pars.incorp.mn, '../output/pars_incorp_mean.csv')
write.csv(pars.incorp.md, '../output/pars_incorp_med.csv')
