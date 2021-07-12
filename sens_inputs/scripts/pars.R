
# Main pars (fixed pH pars included)
pars <- read.csv('../../model_cal/output/pars.csv', row.names = 1)
ipars <- read.csv('../../model_cal/output/pars_incorp_med.csv', row.names = 1)

# Get rid of intercepts for incorp pars
ipn <- rownames(ipars)
ipars <- ipars[, 1]
names(ipars) <- ipn
ipars <- ipars[grepl('^incorp', names(ipars))]

# Pick out results from i = parameter set 2 (with weighting)
p <- as.vector(pars[, 'i'])
names(p) <- rownames(pars)
p <- p[!is.na(p)]
p <- c(p, ipars)
pars.w <- p

# Pars from j = parameter set 3 (without weighting)
p <- as.vector(pars[, 'j'])
names(p) <- rownames(pars)
p <- p[!is.na(p)]
p <- c(p, ipars)
pars.u <- p

