# Calibration of ALFAM2 model to individual plots

# List for holding output from all models
mods0 <- mods1 <- list()

# Set initial guesses for parameters based on earlier calibration (as in paper with minor changes)
p0 <- c(int.f0 = -0.7364889, 
        int.r1 = -1.1785848,
        int.r2 = -0.9543731) 

p1 <- c(int.f0 = -0.7364889, 
        int.r1 = -1.1785848,
        int.r2 = -0.9543731, 
        int.r3 = -2.9012937)

fixed <- c(int.r3 = -10)

#------------------------------------------------------- 

d1$pmid <- as.character(d1$pmid)

for (i in sort(unique(d1$pmid))) {

  cat('\n')
  cat(i, '\n')
  cat('\n')

  dd <- subset(d1, pmid == i)

  # Look for problem observations before running
  pr <- ALFAM2mod(dd, app.name = 'tan.app', time.name = 'ct', group = 'pmid', pars = c(p0, fixed))
  # Should be no NA
  which(is.na(pr$e))
  
  # Parameter estimation 1, with r2
  mods1[[i]] <- list()
  mods1[[i]][['mod']] <- m <- optim(par = p1, fn = function(par) 
                                          resCalcOptim(p = par, dat = dd, to = 'er', app.name = 'tan.app', group = 'pmid', method = 'TAE'), 
                                    method = 'Nelder-Mead')
  
  mods1[[i]][['coef']] <- pp <- m$par
  
  # Run model for all observations using parameter estimates
  mods1[[i]][['pred']] <- pr <- ALFAM2mod(dd, app.name = 'tan.app', time.name = 'ct', group = 'pmid', pars = pp)

  # Parameter estimation 0, without r3
  mods0[[i]] <- list()
  mods0[[i]][['mod']] <- m <- optim(par = p0, fn = function(par) 
                                          resCalcOptim(p = par, dat = dd, to = 'er', fixed = fixed, app.name = 'tan.app', group = 'pmid', method = 'TAE'), 
                                    method = 'Nelder-Mead')
  
  mods0[[i]][['coef']] <- pp <- m$par
  pp <- c(fixed, pp)
  
  # Run model for all observations using parameter estimates
  mods0[[i]][['pred']] <- pr <- ALFAM2mod(dd, app.name = 'tan.app', time.name = 'ct', group = 'pmid', pars = pp)

}


cat('\n')
