# Pulls out predictions (and parameters maybe)

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
