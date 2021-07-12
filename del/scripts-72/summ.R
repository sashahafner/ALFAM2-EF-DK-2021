# Look at rate of loss at later times


dsr <- data.frame()

for (i in unique(d$pmid)) {

  dd <- subset(d, pmid == i)

  if (sum(dd$ct > 168) > 2 & sum(is.na(dd$e.rel)) == 0) {

    m <- lm(e.rel ~ ct, data = dd, subset = ct > 72)
    r72 <- 24 * as.vector(coef(m)[2])

    m <- lm(log10(e.rel) ~ ct, data = dd, subset = ct > 72)
    rr72 <- 24 * (10^as.vector(coef(m)[2]) - 1)

    m <- lm(e.rel ~ ct, data = dd, subset = ct > 168)
    r168 <- 24 * as.vector(coef(m)[2])

    m <- lm(log10(e.rel) ~ ct, data = dd, subset = ct > 168)
    rr168 <- 24 * (10^as.vector(coef(m)[2]) - 1)

    dsr <- rbind(dsr, data.frame(pmid = i, r72 = r72, rr72 = rr72, r168 = r168, rr168 = rr168))

  }

}
