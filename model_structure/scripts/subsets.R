# Select plots for calibration

set.seed(42)
s1 <- sample(pmid.cal1, 100)

#d1 <- subset(d, pmid %in% s1 & ct < 96)
d1 <- subset(d, pmid %in% s1)

d1$er <- d1$e.rel

ds1 <- subset(ds, pmid %in% pmid.cal1)
