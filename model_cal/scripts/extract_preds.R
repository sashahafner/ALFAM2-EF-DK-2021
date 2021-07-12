
d.pred <- data.frame()

for(i in 1:length(mods2)) {
    dd <- mods2[[i]]$pred
    dd$par.set <- names(mods2)[i]
    d.pred <- rbind(d.pred, dd)
}

# Add predictions with default ALFAM2 model pars (set 1)
dd <- ALFAM2mod(d2, app.name = 'tan.app', time.name = 'ct', time.incorp = 'time.incorp', 
                group = 'pmid')
dd$par.set <- '1'
dd$er[dd$er > 1] <- 1
d.pred <- rbind(d.pred, dd)

# ALFAM1 predictions
dpred$meas.tech.mm <- TRUE
dd <- ALFAM1mod(dpred, time.name = 'ct', group = 'pmid')
dd$par.set <- 'ALFAM1'
d.pred <- rbindf(d.pred, dd)

# Merge with measurements
#d.pred <- merge(d2, d.pred, by = c('pmid', 'ct', 'dt'), suffixes = c('', '.pred'))
d.pred <- merge(rbindf(d2, d2cs), d.pred, by = c('pmid', 'ct'), suffixes = c('', '.pred'))
d.pred$error.er <- d.pred$er.pred - d.pred$er

# Get fixed times
d.pred.168 <- subset(d.pred, ct == ct.168)
