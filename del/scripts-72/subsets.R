# Select plots for calibration

# All obs in cal 2
d0 <- subset(d, pmid %in% pmid.cal2)

## Which pmid used for calibration have long runs?
#wl <- unique(subset(ds, ct.max > 96)$pmid)
#pmid.long <- wl[wl %in% pmid.cal1]
#
#set.seed(42)
#s1 <- sample(pmid.long, 84)
#
#d1 <- subset(d, pmid %in% s1)
#
#d1$er <- d1$e.rel

#d0 <- subset(d, pmid %in% pmid.cal1)
#
#wl <- unique(subset(ds, ct.max > 240)$pmid)
#d0 <- subset(d, pmid %in% wl)
