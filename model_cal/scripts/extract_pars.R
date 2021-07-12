
# Get all parameter estimates
pnm <- unique(names(c(p1, p2, p3, p4, p5, pc, fixed)))
pnm <- pnm[order(substr(pnm, nchar(pnm), nchar(pnm)))]

d.pars <- data.frame(row.names = pnm)

for(i in 1:length(mods2)) {
    pp <- mods2[[i]]$coef
    d.pars[, i] <- pp[rownames(d.pars)]
    names(d.pars)[i] <- names(mods2)[i]
}

pars.set2 <- d.pars[, 'i', drop = FALSE]
pars.set2 <- na.omit(pars.set2)
pars.incorp.set2 <- pars.incorp.md[grepl('^incorp', names(pars.incorp.md))]
pars.set2 <- rbind(pars.set2, data.frame(i = pars.incorp.set2))

write.csv(d.pars, '../output/pars.csv')
write.csv(pars.set2, '../output/pars_set2.csv')
write.csv(rounddf(d.pars, 3, signif), '../output/pars_rounded.csv')
write.csv(rounddf(pars.set2, 3, signif), '../output/pars_set2_rounded.csv')
