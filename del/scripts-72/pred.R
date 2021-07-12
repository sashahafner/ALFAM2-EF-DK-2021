# Make predictions with default par set 1 pars

#pr2 <- ALFAM2mod(d0, pars = pp, app.name = 'tan.app', time.name = 'ct', group = 'pmid')
pr2 <- ALFAM2mod(d0, pars = pp, app.name = 'tan.app', time.name = 'ct', group = 'pmid')
names(pr2)[-1:-3] <- paste0(names(pr2)[-1:-3], '.pred')
d0 <- cbind(d0, pr2[-1:-3])

d0$eerr <- d0$er.pred - d0$e.rel
d0$ererr <- d0$eerr / d0$e.rel
d0$leerr <- log10(d0$er.pred / d0$e.rel)
d0$jerr <- d0$j.pred - d0$j.NH3
d0$jrerr <- d0$jerr / d0$j.NH3
d0$ljerr <- log10(d0$j.pred / d0$j.NH3)

# Max duration for subsets
d0 <- as.data.frame(mutate(group_by(d0, pmid), ct.max = max(ct)))
dend <- subset(d0, ct == ct.max)
