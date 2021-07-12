# Parameters

# Read in all parameters from model calibration
par.tab <- read.csv('../pars/pars.csv', row.names = 1)

# Select single set 2f
pars2f <- par.tab[, 'X2f']
names(pars2f) <- rownames(par.tab)
pars2f <- na.omit(pars2f)

# Drop unused pars
pars2f <- pars2f[!grepl('\\.ts\\.|^ts\\.|\\.CH|\\.NL', names(pars2f))]

# Get incorporation parameters
par.incorp.tab <- read.csv('../pars/pars_incorp_mean.csv', row.names = 1)
parsi <- par.incorp.tab[, 1]
names(parsi) <- rownames(par.incorp.tab)
parsi <- parsi[grepl('^incorp', names(parsi))]

# Combine pars and add fixed pars
pars <- c(pars2f, 
          parsi,  
          man.ph.r1 = 0.6,
          man.ph.r3 = 0.3)

# Save pars in log
sink('../logs/pars.txt')
  print(pars)
sink()

