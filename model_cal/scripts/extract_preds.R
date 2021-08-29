
d.pred <- data.frame()

for(i in 1:length(mods2)) {
    dd <- mods2[[i]]$pred
    dd$par.set <- names(mods2)[i]
    d.pred <- rbind(d.pred, dd)
}

# Add predictions with default ALFAM2 model pars (set 1)
dd <- ALFAM2mod(d2, app.name = 'tan.app', time.name = 'ct', time.incorp = 'time.incorp', 
                group = 'pmid', pars = ALFAM2pars01)
dd$par.set <- '1'
dd$er[dd$er > 1] <- 1
d.pred <- rbind(d.pred, dd)

# ALFAM1 predictions
#da1 <- rbindf(d2, d2cs)
da1 <- d2
da1$meas.tech.mm <- TRUE
dd <- ALFAM1mod(da1, time.name = 'ct', group = 'pmid')
dd$par.set <- 'ALFAM1'
dd$er[da1$app.mthd == 'cs'] <- NA
d.pred <- rbindf(d.pred, dd)

# ALFAM1 predictions but as in EF calcs (trailing hose * reductions)
#da1 <- rbindf(d2, d2cs)
da1 <- d2
da1$meas.tech.mm <- TRUE
da1$app.mthd.bsth <- TRUE
da1$app.mthd.ts <- FALSE 
da1$app.mthd.os <- FALSE 
da1$app.mthd.cs <- FALSE 
da1$app.mthd.pi <- FALSE 

# All predictions for trailing hose
dd <- ALFAM1mod(da1, time.name = 'ct', group = 'pmid')
dd$par.set <- 'EF 2008'

# Multiply by fixed reductions or increases
dd$er[da1$app.mthd == 'bc'] <- 1.7 * dd$er[da1$app.mthd == 'bc']
dd$er[da1$app.mthd == 'os'] <- 0.75 * dd$er[da1$app.mthd == 'os']
# Leave trailing shoe at trailing hose level for fit stats
##dd$er[da1$app.mthd == 'ts'] <- NA
dd$er[da1$app.mthd == 'cs'] <- 0.05 * dd$er[da1$app.mthd == 'cs']
# Pressurized injection should not be present anyway
dd$er[da1$app.mthd == 'pi'] <- NA

d.pred <- rbindf(d.pred, dd)

# Merge with measurements
d.pred <- merge(d2, d.pred, by = c('pmid', 'ct'), suffixes = c('', '.pred'))
#d.pred <- merge(rbindf(d2, d2cs), d.pred, by = c('pmid', 'ct'), suffixes = c('', '.pred'))
d.pred$error.er <- d.pred$er.pred - d.pred$er

# Get fixed times
d.pred.168 <- subset(d.pred, ct == ct.168)
