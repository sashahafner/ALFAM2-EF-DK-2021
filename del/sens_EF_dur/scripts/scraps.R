## Calculate relative effects
## Reference conditions
#dr <- dat[1:4, ]
#dat2 <- merge(dat, dr, by = c('man.source.pig', 'month'), suffixes = c('', '.ref'))
#dat2$red <- 1 - dat2$er/dat2$er.ref
#
#dat2 <- dat2[order(dat2$id), ]
#
#head(dat)

#preds <- ALFAM2mod(dat, pars = pars.j, app.name = 'tan.app', time.name = 'ct', time.incorp = 't.incorp', group = 'id', warn = TRUE, add.incorp.rows = TRUE)
#x <- subset(preds, id %in% paste0(paste0('00', 11:15), '-', '1980'))
#args(ALFAM2mod)
#preds$id
#x
#
#d <- data.frame(dat[dat$id == '0012-1980', ], ct2 = 1:72)
#d$ct <- d$ct2
#preds1 <- ALFAM2mod(d, pars = pars.j, app.name = 'tan.app', time.name = 'ct', time.incorp = 't.incorp', group = 'id', warn = TRUE, add.incorp.rows = TRUE)
#preds2 <- ALFAM2mod(d, pars = pars.j, app.name = 'tan.app', time.name = 'ct', group = 'id', warn = TRUE)
#plot(er ~ ct, data = preds1, type = 'l', ylim = c(0, 0.15))
#lines(er ~ ct, data = preds2, type = 'l', col = 'red')
#pars.j
#preds
#
#d$ct <- 1:12 * 6


