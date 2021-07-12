
# Main pars (fixed pH pars included)
pars <- read.csv('../../model_cal/output/pars.csv', row.names = 1)

# Pick out results from h (with weighting)
p <- as.vector(pars[, 'h'])
names(p) <- rownames(pars)
p <- p[!is.na(p)]
pp <- p
