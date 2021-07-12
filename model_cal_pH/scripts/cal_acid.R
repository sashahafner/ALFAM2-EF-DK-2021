# Calibration for pH effect with acidification experiment subset

# List for holding output from all models
mods.acid <- list()

dfsumm(ds3)
dfsumm(ds3[, c('country', 'app.mthd', 'incorp')])
table(ds3$meas.tech)

# Set initial guesses for parameters based on earlier calibration 
p1 <- c(int.f0 = -0.7364889, 
        int.r1 = -1.1785848,
        int.r2 = -0.9543731, 
        int.r3 = -2.9012937, 
        man.ph.r1 = 0.5, 
        man.ph.r3 = 0.3,
        man.source.pig.f0 = -0.3)

d3$uexper <- paste(d3$inst, d3$exper)

#------------------------------------------------------- 
for (i in unique(d3$uexper)) {
  dd <- subset(d3, uexper == i)

  cat('\nExperiment ', i, '\n')

  for (j in unique(dd$man.source)) {

    cid <- paste(dd$country[1], i, j)
    mods.acid[[cid]] <- list()

    ddd <- subset(dd, man.source == j)

    pars <- p1

    cat('\nManure source ', j, '\n')

    # Get country, uexperiment, and manure type
    mods.acid[[cid]][['country']] <- dd$country[1]
    mods.acid[[cid]][['uexper']] <- i
    mods.acid[[cid]][['man.source']] <- j

    # Look for problem observations before running
    pr <- ALFAM2mod(ddd, app.name = 'tan.app', time.name = 'ct',
                    group = 'pmid', pars = pars, parallel = FALSE)

    # Should be no NA
    which(is.na(pr$e))

    mods.acid[[cid]][['mod']] <- m <- optim(par = pars, fn = function(par) 
                                            resCalcOptim(p = par, dat = ddd, to = 'e.int', app.name = 'tan.app', 
                                                    group = 'pmid', 
                                                    method = 'TAE', parallel = FALSE, prog = FALSE), 
                                      method = 'Nelder-Mead')
    
    mods.acid[[cid]][['coef']] <- pp <- m$par
    print(pp)
    
    write.csv(pp, paste0('../output/pars_acid_', i, '.csv'))
    
    # Run model for all observations using parameter estimates
    mods.acid[[cid]][['pred']] <- pr <- ALFAM2mod(d3, app.name = 'tan.app', time.name = 'ct',
                                            group = 'pmid', pars = pp, parallel = FALSE)
  }
}

# Get all parameter estimates
#pnm <- unique(names(c(p1, p2)))
#pnm <- pnm[order(substr(pnm, nchar(pnm), nchar(pnm)))]
#acid.pars <- data.frame(row.names = pnm)

acid.pars <- data.frame()

for(i in 1:length(mods.acid)) {
  pp <- as.data.frame(t(mods.acid[[i]]$coef))
  pp$country <- mods.acid[[i]]$country
  pp$uexper <- mods.acid[[i]]$uexper
  pp$man.source <- mods.acid[[i]]$man.source
  acid.pars <- rbind(acid.pars, pp)
}

# Get predictions
acid.preds <- data.frame()

for(i in 1:length(mods.acid)) {
  pp <- mods.acid[[i]]$pred
  pp$country <- mods.acid[[i]]$country
  pp$uexper <- mods.acid[[i]]$uexper
  pp$man.source <- mods.acid[[i]]$man.source
  acid.preds <- rbind(acid.preds, pp)
}

names(acid.preds)[!names(acid.preds) %in% c('pmid', 'country', 'uexper', 'man.source', 'ct')] <- 
 paste0(names(acid.preds)[!names(acid.preds) %in% c('pmid', 'country', 'uexper', 'man.source', 'ct')], '.pred')

d3 <- merge(d3, acid.preds, by = c('pmid', 'country', 'uexper', 'man.source', 'ct'))


par.mn <- apply(acid.pars[, c('man.ph.r1', 'man.ph.r3')], 2, mean, na.rm = TRUE)
par.md <- apply(acid.pars[, c('man.ph.r1', 'man.ph.r3')], 2, median, na.rm = TRUE)

write.csv(acid.pars, '../output/pars_acid.csv')
write.csv(par.mn, '../output/pars_acid_mean.csv')
write.csv(par.md, '../output/pars_acid_med.csv')
