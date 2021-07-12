# Pulls out predictions

preds0 <- preds1 <- data.frame()

for (i in mods0) {
  preds0 <- rbind(preds0, i$pred)
}

for (i in mods1) {
  preds1 <- rbind(preds1, i$pred)
}

names(preds1)[-1:-3] <- paste0(names(preds1)[-1:-3], '.pred1')
names(preds0)[-1:-3] <- paste0(names(preds0)[-1:-3], '.pred0')

# Merge in
d1 <- merge(d1, preds0, by = c('pmid', 'ct'))
d1 <- merge(d1, preds1, by = c('pmid', 'ct'))

d1$err0 <- d1$er.pred0 - d1$er
d1$err1 <- d1$er.pred1 - d1$er

# Get final duration
d1 <- as.data.frame(mutate(group_by(d1, pmid), ct.max = max(ct)))
dmx <- subset(d1, ct == ct.max)
dl <- melt(dmx, id.vars = 'pmid', measure.vars = c('err0', 'err1'))
dl$variable <- factor(dl$variable, levels = c('err0', 'err1'), labels = c('No slow emission', 'With slow emission'))
