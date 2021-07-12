# Calibration

# For saving workspace if helpful
#save.image('../R images/cal.RData')

# List for holding output from all models
mods1 <- list()
mods2 <- list()

# Set initial and fixed parameter values ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Set initial guesses for parameters based on earlier calibration (as in paper with minor changes)
p1 <- c(int.f0 = -0.7364889, 
        int.r1 = -1.1785848,
        int.r2 = -0.9543731, 
        int.r3 = -2.9012937, 
        app.mthd.os.f0 = -1.1717859,
        #app.mthd.cs.f0 = -2,
        app.rate.ni.f0 = -0.01,
        app.rate.os.f0 = 0.01,
        man.dm.f0 = 0.407466, 
        #app.mthd.bc.f0 = 0.2, 
        app.mthd.bc.r1 = 0.6283396,
        man.dm.r1 = -0.075822, 
        air.temp.r1 = 0.0492777, 
        wind.2m.r1 = 0.0486651,
        air.temp.r3 = 0.0152419, 
        app.mthd.os.r3 = -0.122883, 
        #app.mthd.cs.r3 = -1,
        app.mthd.bc.r3 = 0.01, 
        rain.rate.r2 = 0.4327281,
        rain.cum.r3 = -0.0300936
)

# Add pig and trailing shoe
p2 <- c(p1, 
        man.source.pig.f0 = -0.3,
        app.mthd.ts.r1 = -0.1)

# Closed slot
p3 <- c(app.mthd.cs.f0 = -1, app.mthd.cs.r3 = -2)

# Add crop height effects
p4 <- c(p2, 
        bsth.grass.hght.r1 = -0.1,
        bsth.cereal.hght.r1 = -0.1,
        ts.grass.hght.r1 = -0.1,
        ts.cereal.hght.r1 = -0.1
)

# Select crop height effects
p5 <- c(p2, ts.cereal.hght.r1 = -0.1)

# Country effects
pc <- c(country.NL.f0 = 0.1, country.CH.f0 = -0.1)

# Fixed parameters for pH based on separate model_cal_pH analysis
fixed <- c(man.ph.r1 = 0.665, 
           man.ph.r3 = 0.238) 

#------------------------------------------------------- 
# Model calibration with relative emission as response
# Always with fixed pH effects from pH calibration (except 1 set for comparison)
# Always with weights (except 1 set at end for comparison)
#------------------------------------------------------- 

#------------------------------------------------------- 
# ~~~~~~~~~~~~~~~~~~~~~~~~
# Calibration settings
# a a a a a a a a a
# Use p2 with pig and trailing shoe
# Include country and crop height effects
i <- 'a'
parset <- c(p4, pc)
datset <- d2
# ~~~~~~~~~~~~~~~~~~~~~~~~

# Echo pars
print(parset)
print(fixed)

# Echo dataset info
pvars <- gsub('\\.[rf][0-4]$', '', names(parset))
pvars <- pvars[pvars != 'int']
dfsumm(datset[, pvars])

# Look for problem observations before running
pr <- ALFAM2mod(datset, app.name = 'tan.app', time.name = 'ct', group = 'pmid', pars = parset, parallel = FALSE)
# Should be no NA
print(which(is.na(pr$e)))

# Parameter estimation (timed)
Sys.time()
mods2[[i]] <- list()
mods2[[i]][['mod']] <- m <- optim(par = parset, fn = function(par) 
                                        resCalcOptim(p = par, dat = datset, to = 'er', fixed = fixed, app.name = 'tan.app', group = 'pmid',
                                                method = 'TAE',  weights = datset$weightc, parallel = FALSE), 
                                  method = 'Nelder-Mead')
Sys.time()

# Get pars
mods2[[i]][['coef']] <- pp <- c(m$par, fixed)

# Echo pars and other model info
print(pp)
print(m)

# Export pars
write.csv(pp, paste0('../output/pars_', i, '.csv'))

# Run model for all observations using parameter estimates
mods2[[i]][['pred']] <- pr <- ALFAM2mod(datset, app.name = 'tan.app', time.name = 'ct', time.incorp = 'time.incorp', 
                group = 'pmid', pars = pp, parallel = FALSE)

Sys.time()
#------------------------------------------------------- 


#------------------------------------------------------- 
# ~~~~~~~~~~~~~~~~~~~~~~~~
# Calibration settings
# b b b b b b b 
# Use p5 with pig and trailing shoe
# Include country 
# Crop height effects only for cereal ts
i <- 'b'
parset <- c(p5, pc)
datset <- d2
# ~~~~~~~~~~~~~~~~~~~~~~~~

# Echo pars
print(parset)
print(fixed)

# Echo dataset info
pvars <- gsub('\\.[rf][0-4]$', '', names(parset))
pvars <- pvars[pvars != 'int']
dfsumm(datset[, pvars])

# Look for problem observations before running
pr <- ALFAM2mod(datset, app.name = 'tan.app', time.name = 'ct', group = 'pmid', pars = parset, parallel = FALSE)
# Should be no NA
print(which(is.na(pr$e)))

# Parameter estimation (timed)
Sys.time()
mods2[[i]] <- list()
mods2[[i]][['mod']] <- m <- optim(par = parset, fn = function(par) 
                                        resCalcOptim(p = par, dat = datset, to = 'er', fixed = fixed, app.name = 'tan.app', group = 'pmid',
                                                method = 'TAE',  weights = datset$weightc, parallel = FALSE), 
                                  method = 'Nelder-Mead')
Sys.time()

# Get pars
mods2[[i]][['coef']] <- pp <- c(m$par, fixed)

# Echo pars and other model info
print(pp)
print(m)

# Export pars
write.csv(pp, paste0('../output/pars_', i, '.csv'))

# Run model for all observations using parameter estimates
mods2[[i]][['pred']] <- pr <- ALFAM2mod(datset, app.name = 'tan.app', time.name = 'ct', time.incorp = 'time.incorp', 
                group = 'pmid', pars = pp, parallel = FALSE)

Sys.time()
#------------------------------------------------------- 


#------------------------------------------------------- 
# ~~~~~~~~~~~~~~~~~~~~~~~~
# Calibration settings
# c c c c c c c 
# As in b but drop pH for comparison
i <- 'c'
parset <- c(p5, pc)
datset <- d2
# ~~~~~~~~~~~~~~~~~~~~~~~~

# Echo pars
print(parset)

# Echo dataset info
pvars <- gsub('\\.[rf][0-4]$', '', names(parset))
pvars <- pvars[pvars != 'int']
dfsumm(datset[, pvars])

# Look for problem observations before running
pr <- ALFAM2mod(datset, app.name = 'tan.app', time.name = 'ct', group = 'pmid', pars = parset, parallel = FALSE)
# Should be no NA
print(which(is.na(pr$e)))

# Parameter estimation (timed)
Sys.time()
mods2[[i]] <- list()
mods2[[i]][['mod']] <- m <- optim(par = parset, fn = function(par) 
                                        resCalcOptim(p = par, dat = datset, to = 'er', app.name = 'tan.app', group = 'pmid',
                                                method = 'TAE',  weights = datset$weightc, parallel = FALSE), 
                                  method = 'Nelder-Mead')
Sys.time()

# Get pars
mods2[[i]][['coef']] <- pp <- m$par

# Echo pars and other model info
print(pp)
print(m)

# Export pars
write.csv(pp, paste0('../output/pars_', i, '.csv'))

# Run model for all observations using parameter estimates
mods2[[i]][['pred']] <- pr <- ALFAM2mod(datset, app.name = 'tan.app', time.name = 'ct', time.incorp = 'time.incorp', 
                group = 'pmid', pars = pp, parallel = FALSE)

Sys.time()
#------------------------------------------------------- 

#------------------------------------------------------- 
# ~~~~~~~~~~~~~~~~~~~~~~~~
# Calibration settings
# d d d d d d d 
# As with b but drop weighting
i <- 'd'
parset <- c(p5, pc)
datset <- d2
# ~~~~~~~~~~~~~~~~~~~~~~~~

# Echo pars
print(parset)
print(fixed)

# Echo dataset info
pvars <- gsub('\\.[rf][0-4]$', '', names(parset))
pvars <- pvars[pvars != 'int']
dfsumm(datset[, pvars])

# Look for problem observations before running
pr <- ALFAM2mod(datset, app.name = 'tan.app', time.name = 'ct', group = 'pmid', pars = parset, parallel = FALSE)
# Should be no NA
print(which(is.na(pr$e)))

# Parameter estimation (timed)
Sys.time()
mods2[[i]] <- list()
mods2[[i]][['mod']] <- m <- optim(par = parset, fn = function(par) 
                                        resCalcOptim(p = par, dat = datset, to = 'er', fixed = fixed, app.name = 'tan.app', group = 'pmid',
                                                method = 'TAE',  weights = 1, parallel = FALSE), 
                                  method = 'Nelder-Mead')
Sys.time()

# Get pars
mods2[[i]][['coef']] <- pp <- c(m$par, fixed)

# Echo pars and other model info
print(pp)
print(m)

# Export pars
write.csv(pp, paste0('../output/pars_', i, '.csv'))

# Run model for all observations using parameter estimates
mods2[[i]][['pred']] <- pr <- ALFAM2mod(datset, app.name = 'tan.app', time.name = 'ct', time.incorp = 'time.incorp', 
                group = 'pmid', pars = pp, parallel = FALSE)

Sys.time()
#------------------------------------------------------- 


#------------------------------------------------------- 
# ~~~~~~~~~~~~~~~~~~~~~~~~
# Calibration settings
# e e e e e e e 
# As with b but drop useless predictors that are unstable in a-d
i <- 'e'
parset <- c(p5, pc)
parset <- parset[!names(parset) %in% c('app.rate.os.f0', 'rain.cum.r3', 'app.mthd.os.r3')]
datset <- d2
# ~~~~~~~~~~~~~~~~~~~~~~~~

# Echo pars
print(parset)
print(fixed)

# Echo dataset info
pvars <- gsub('\\.[rf][0-4]$', '', names(parset))
pvars <- pvars[pvars != 'int']
dfsumm(datset[, pvars])

# Look for problem observations before running
pr <- ALFAM2mod(datset, app.name = 'tan.app', time.name = 'ct', group = 'pmid', pars = parset, parallel = FALSE)
# Should be no NA
print(which(is.na(pr$e)))

# Parameter estimation (timed)
Sys.time()
mods2[[i]] <- list()
mods2[[i]][['mod']] <- m <- optim(par = parset, fn = function(par) 
                                        resCalcOptim(p = par, dat = datset, to = 'er', fixed = fixed, app.name = 'tan.app', group = 'pmid',
                                                method = 'TAE',  weights = datset$weightc, parallel = FALSE), 
                                  method = 'Nelder-Mead')
Sys.time()

# Get pars
mods2[[i]][['coef']] <- pp <- c(m$par, fixed)

# Echo pars and other model info
print(pp)
print(m)

# Export pars
write.csv(pp, paste0('../output/pars_', i, '.csv'))

# Run model for all observations using parameter estimates
mods2[[i]][['pred']] <- pr <- ALFAM2mod(datset, app.name = 'tan.app', time.name = 'ct', time.incorp = 'time.incorp', 
                group = 'pmid', pars = pp, parallel = FALSE)

Sys.time()
#------------------------------------------------------- 



#------------------------------------------------------- 
# ~~~~~~~~~~~~~~~~~~~~~~~~
# Calibration settings
# f f f f f f f 
# As with e but drop country predictors because CH par value makes no sense
i <- 'f' 
parset <- mods2[['e']][['coef']]
parset <- parset[!names(parset) %in% c('country.NL.f0', 'country.CH.f0', names(fixed))]
datset <- d2
# ~~~~~~~~~~~~~~~~~~~~~~~~

# Echo pars
print(parset)
print(fixed)

# Echo dataset info
pvars <- gsub('\\.[rf][0-4]$', '', names(parset))
pvars <- pvars[pvars != 'int']
dfsumm(datset[, pvars])

# Look for problem observations before running
pr <- ALFAM2mod(datset, app.name = 'tan.app', time.name = 'ct', group = 'pmid', pars = parset, parallel = FALSE)
# Should be no NA
print(which(is.na(pr$e)))

# Parameter estimation (timed)
Sys.time()
mods2[[i]] <- list()
mods2[[i]][['mod']] <- m <- optim(par = parset, fn = function(par) 
                                        resCalcOptim(p = par, dat = datset, to = 'er', fixed = fixed, app.name = 'tan.app', group = 'pmid',
                                                method = 'TAE',  weights = datset$weightc, parallel = FALSE), 
                                  method = 'Nelder-Mead')
Sys.time()

# Get pars
mods2[[i]][['coef']] <- pp <- c(m$par, fixed)

# Echo pars and other model info
print(pp)
print(m)

# Export pars
write.csv(pp, paste0('../output/pars_', i, '.csv'))

# Run model for all observations using parameter estimates
mods2[[i]][['pred']] <- pr <- ALFAM2mod(datset, app.name = 'tan.app', time.name = 'ct', time.incorp = 'time.incorp', 
                group = 'pmid', pars = pp, parallel = FALSE)

Sys.time()
#------------------------------------------------------- 


#------------------------------------------------------- 
# ~~~~~~~~~~~~~~~~~~~~~~~~
# Calibration settings
#  g g g g g g g
# As with f but without weighting, for comparison
i <- 'g' 
parset <- mods2[['f']][['coef']]
parset <- parset[!names(parset) %in% names(fixed)]
datset <- d2
# ~~~~~~~~~~~~~~~~~~~~~~~~

# Echo pars
print(parset)
print(fixed)

# Echo dataset info
pvars <- gsub('\\.[rf][0-4]$', '', names(parset))
pvars <- pvars[pvars != 'int']
dfsumm(datset[, pvars])

# Look for problem observations before running
pr <- ALFAM2mod(datset, app.name = 'tan.app', time.name = 'ct', group = 'pmid', pars = parset, parallel = FALSE)
# Should be no NA
print(which(is.na(pr$e)))

# Parameter estimation (timed)
Sys.time()
mods2[[i]] <- list()
mods2[[i]][['mod']] <- m <- optim(par = parset, fn = function(par) 
                                        resCalcOptim(p = par, dat = datset, to = 'er', fixed = fixed, app.name = 'tan.app', group = 'pmid',
                                                method = 'TAE',  weights = 1, parallel = FALSE), 
                                  method = 'Nelder-Mead')
Sys.time()

# Get pars
mods2[[i]][['coef']] <- pp <- c(m$par, fixed)

# Echo pars and other model info
print(pp)
print(m)

# Export pars
write.csv(pp, paste0('../output/pars_', i, '.csv'))

# Run model for all observations using parameter estimates
mods2[[i]][['pred']] <- pr <- ALFAM2mod(datset, app.name = 'tan.app', time.name = 'ct', time.incorp = 'time.incorp', 
                group = 'pmid', pars = pp, parallel = FALSE)

Sys.time()
#------------------------------------------------------- 

#------------------------------------------------------- 
# ~~~~~~~~~~~~~~~~~~~~~~~~
# Calibration settings
# h h h h h h h 
# As with f but drop air.temp.r3 because its sign is not stable
i <- 'h' 
parset <- mods2[['f']][['coef']]
parset <- parset[!names(parset) %in% c('air.temp.r3', names(fixed))]
datset <- d2
# ~~~~~~~~~~~~~~~~~~~~~~~~

# Echo pars
print(parset)
print(fixed)

# Echo dataset info
pvars <- gsub('\\.[rf][0-4]$', '', names(parset))
pvars <- pvars[pvars != 'int']
dfsumm(datset[, pvars])

# Look for problem observations before running
pr <- ALFAM2mod(datset, app.name = 'tan.app', time.name = 'ct', group = 'pmid', pars = parset, parallel = FALSE)
# Should be no NA
print(which(is.na(pr$e)))

# Parameter estimation (timed)
Sys.time()
mods2[[i]] <- list()
mods2[[i]][['mod']] <- m <- optim(par = parset, fn = function(par) 
                                        resCalcOptim(p = par, dat = datset, to = 'er', fixed = fixed, app.name = 'tan.app', group = 'pmid',
                                                method = 'TAE',  weights = datset$weightc, parallel = FALSE), 
                                  method = 'Nelder-Mead')
Sys.time()

# Get pars
mods2[[i]][['coef']] <- pp <- c(m$par, fixed)

# Echo pars and other model info
print(pp)
print(m)

# Export pars
write.csv(pp, paste0('../output/pars_', i, '.csv'))

# Run model for all observations using parameter estimates
mods2[[i]][['pred']] <- pr <- ALFAM2mod(datset, app.name = 'tan.app', time.name = 'ct', time.incorp = 'time.incorp', 
                group = 'pmid', pars = pp, parallel = FALSE)

Sys.time()
#------------------------------------------------------- 

#------------------------------------------------------- 
# ~~~~~~~~~~~~~~~~~~~~~~~~
# Calibration settings
# i i i i i i i  
# For cs only
# Note that par set h pars are used as fixed pars!
# Set i is the set used for EFS = "parameter set 2"
i <- 'i' 
parset <- p3
datset <- d2cs
# ~~~~~~~~~~~~~~~~~~~~~~~~

# Echo pars
print(parset)

# Echo dataset info
pvars <- unique(gsub('\\.[rf][0-4]$', '', names(parset)))
pvars <- pvars[pvars != 'int']
dfsumm(datset[, pvars, drop = FALSE])

# Look for problem observations before running
pr <- ALFAM2mod(datset, app.name = 'tan.app', time.name = 'ct', group = 'pmid', pars = parset, parallel = FALSE)
# Should be no NA
print(which(is.na(pr$e)))

# Parameter estimation (timed)
Sys.time()
mods2[[i]] <- list()
# Note unusual fixed argument!
mods2[[i]][['mod']] <- m <- optim(par = parset, fn = function(par) 
                                        resCalcOptim(p = par, dat = datset, to = 'er', fixed = mods2[['h']][['coef']], 
                                                     app.name = 'tan.app', group = 'pmid',
                                                method = 'TAE',  weights = 1, parallel = FALSE), 
                                  method = 'Nelder-Mead')
Sys.time()

# Get pars
mods2[[i]][['coef']] <- pp <- c(m$par, fixed2)

# Echo pars and other model info
print(pp)
print(m)

# Export pars
write.csv(pp, paste0('../output/pars_', i, '.csv'))

# Run model for all observations using parameter estimates
mods2[[i]][['pred']] <- pr <- ALFAM2mod(rbindf(d2, d2cs), app.name = 'tan.app', time.name = 'ct', time.incorp = 'time.incorp', 
                group = 'pmid', pars = pp, parallel = FALSE)

Sys.time()
#------------------------------------------------------- 



#------------------------------------------------------- 
# ~~~~~~~~~~~~~~~~~~~~~~~~
# Calibration settings
# j j j j j j j 
# As with h but drop weighting, for comparison
# Parameter set 3
i <- 'j' 
parset <- mods2[['h']][['coef']]
parset <- parset[!names(parset) %in% names(fixed)]
datset <- d2
# ~~~~~~~~~~~~~~~~~~~~~~~~

# Echo pars
print(parset)
print(fixed)

# Echo dataset info
pvars <- gsub('\\.[rf][0-4]$', '', names(parset))
pvars <- pvars[pvars != 'int']
dfsumm(datset[, pvars])

# Look for problem observations before running
pr <- ALFAM2mod(datset, app.name = 'tan.app', time.name = 'ct', group = 'pmid', pars = parset, parallel = FALSE)
# Should be no NA
print(which(is.na(pr$e)))

# Parameter estimation (timed)
Sys.time()
mods2[[i]] <- list()
mods2[[i]][['mod']] <- m <- optim(par = parset, fn = function(par) 
                                        resCalcOptim(p = par, dat = datset, to = 'er', fixed = fixed, app.name = 'tan.app', group = 'pmid',
                                                method = 'TAE',  weights = 1, parallel = FALSE), 
                                  method = 'Nelder-Mead')
Sys.time()

# Get pars
mods2[[i]][['coef']] <- pp <- c(m$par, fixed)

# Echo pars and other model info
print(pp)
print(m)

# Export pars
write.csv(pp, paste0('../output/pars_', i, '.csv'))

# Run model for all observations using parameter estimates
mods2[[i]][['pred']] <- pr <- ALFAM2mod(datset, app.name = 'tan.app', time.name = 'ct', time.incorp = 'time.incorp', 
                group = 'pmid', pars = pp, parallel = FALSE)

Sys.time()
#------------------------------------------------------- 


#------------------------------------------------------- 
# ~~~~~~~~~~~~~~~~~~~~~~~~
# Calibration settings
# k k k k k k k 
# As with h but drop fixed pH pars for comparison
i <- 'k' 
parset <- mods2[['h']][['coef']]
parset <- parset[!names(parset) %in% names(fixed)]
datset <- d2
# ~~~~~~~~~~~~~~~~~~~~~~~~

# Echo pars
print(parset)

# Echo dataset info
pvars <- gsub('\\.[rf][0-4]$', '', names(parset))
pvars <- pvars[pvars != 'int']
dfsumm(datset[, pvars])

# Look for problem observations before running
pr <- ALFAM2mod(datset, app.name = 'tan.app', time.name = 'ct', group = 'pmid', pars = parset, parallel = FALSE)
# Should be no NA
print(which(is.na(pr$e)))

# Parameter estimation (timed)
Sys.time()
mods2[[i]] <- list()
mods2[[i]][['mod']] <- m <- optim(par = parset, fn = function(par) 
                                        resCalcOptim(p = par, dat = datset, to = 'er', app.name = 'tan.app', group = 'pmid',
                                                method = 'TAE',  weights = datset$weightc, parallel = FALSE), 
                                  method = 'Nelder-Mead')
Sys.time()

# Get pars
mods2[[i]][['coef']] <- pp <- m$par

# Echo pars and other model info
print(pp)
print(m)

# Export pars
write.csv(pp, paste0('../output/pars_', i, '.csv'))

# Run model for all observations using parameter estimates
mods2[[i]][['pred']] <- pr <- ALFAM2mod(datset, app.name = 'tan.app', time.name = 'ct', time.incorp = 'time.incorp', 
                group = 'pmid', pars = pp, parallel = FALSE)

Sys.time()
#------------------------------------------------------- 


