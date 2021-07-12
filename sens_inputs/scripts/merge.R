# Merge in predictions

datw <- merge(dat, prw, by = c('sida', 'ct'))
dat168w <- datw[datw$ct == 168, ]

summ168w <- dcast(dat168w, sid + descrip ~ app.mthd, value.var = 'er')
summ168w$bc.red <- 100*(1 - summ168w$bc/summ168w$bc[1])
summ168w$bsth.red <- 100*(1 - summ168w$bsth/summ168w$bsth[1])
summ168w$ts.red <- 100*(1 - summ168w$ts/summ168w$ts[1])
summ168w$os.red <- 100*(1 - summ168w$os/summ168w$os[1])
summ168w$cs.red <- 100*(1 - summ168w$cs/summ168w$cs[1])
summ168w$bsth.bc.red <- 100*(1 - summ168w$bsth/summ168w$bc)
summ168w$ts.bc.red <- 100*(1 - summ168w$ts/summ168w$bc)
summ168w$os.bc.red <- 100*(1 - summ168w$os/summ168w$bc)
summ168w$cs.bc.red <- 100*(1 - summ168w$cs/summ168w$bc)
summ168w$ts.bsth.red <- 100*(1 - summ168w$ts/summ168w$bsth)
summ168w$os.bsth.red <- 100*(1 - summ168w$os/summ168w$bsth)
summ168w$cs.bsth.red <- 100*(1 - summ168w$cs/summ168w$bsth)
summ168w <- rounddf(summ168w, 2, signif)

# Repeat for un-weighted par set
datu <- merge(dat, pru, by = c('sida', 'ct'))
dat168u <- datu[datu$ct == 168, ]

summ168u <- dcast(dat168u, sid + descrip ~ app.mthd, value.var = 'er')
summ168u$bc.red <- 100*(1 - summ168u$bc/summ168u$bc[1])
summ168u$bsth.red <- 100*(1 - summ168u$bsth/summ168u$bsth[1])
summ168u$ts.red <- 100*(1 - summ168u$ts/summ168u$ts[1])
summ168u$os.red <- 100*(1 - summ168u$os/summ168u$os[1])
summ168u$cs.red <- 100*(1 - summ168u$cs/summ168u$cs[1])
summ168u$bsth.bc.red <- 100*(1 - summ168u$bsth/summ168u$bc)
summ168u$ts.bc.red <- 100*(1 - summ168u$ts/summ168u$bc)
summ168u$os.bc.red <- 100*(1 - summ168u$os/summ168u$bc)
summ168u$cs.bc.red <- 100*(1 - summ168u$cs/summ168u$bc)
summ168u$ts.bsth.red <- 100*(1 - summ168u$ts/summ168u$bsth)
summ168u$os.bsth.red <- 100*(1 - summ168u$os/summ168u$bsth)
summ168u$cs.bsth.red <- 100*(1 - summ168u$cs/summ168u$bsth)
summ168u <- rounddf(summ168u, 2, signif)

# Repeat for original par set 1
dat1 <- merge(dat, pr1, by = c('sida', 'ct'))
dat1681 <- dat1[dat1$ct == 168, ]

summ1681 <- dcast(dat1681, sid + descrip ~ app.mthd, value.var = 'er')
summ1681$bc.red <- 100*(1 - summ1681$bc/summ1681$bc[1])
summ1681$bsth.red <- 100*(1 - summ1681$bsth/summ1681$bsth[1])
summ1681$ts.red <- 100*(1 - summ1681$ts/summ1681$ts[1])
summ1681$os.red <- 100*(1 - summ1681$os/summ1681$os[1])
summ1681$cs.red <- 100*(1 - summ1681$cs/summ1681$cs[1])
summ1681$bsth.bc.red <- 100*(1 - summ1681$bsth/summ1681$bc)
summ1681$ts.bc.red <- 100*(1 - summ1681$ts/summ1681$bc)
summ1681$os.bc.red <- 100*(1 - summ1681$os/summ1681$bc)
summ1681$cs.bc.red <- 100*(1 - summ1681$cs/summ1681$bc)
summ1681$ts.bsth.red <- 100*(1 - summ1681$ts/summ1681$bsth)
summ1681$os.bsth.red <- 100*(1 - summ1681$os/summ1681$bsth)
summ1681$cs.bsth.red <- 100*(1 - summ1681$cs/summ1681$bsth)
summ1681 <- rounddf(summ1681, 2, signif)
