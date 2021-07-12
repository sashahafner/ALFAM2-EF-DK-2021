# Read in data

d <- read.csv('../../database/ALFAM2_interval.csv')
ds <- read.csv('../../database/ALFAM2_plot.csv')

# Johanna's wind tunnel data
dsj <- data.frame(read_xlsx('../data/200109_A to SH.xlsx', sheet = 1, skip = 1))
dj <- data.frame(read_xlsx('../data/200109_A to SH.xlsx', sheet = 2, skip = 1))

dj$ct <- as.numeric(dj$ct) # Excel crap
dsj$acid <- TRUE
dsj$pmid <- 1899 + as.integer(factor(paste(dsj$exper, dsj$pid)))
dsj$app.method <- 'bsth'
dsj$meas.tech2 <- 'wt'
dsj$inst <- 300
dsj$incorp <- 'none'
dsj$country <- 'DK'

# Merge in plot level info
dj <- merge(dsj, dj, by = c('exper', 'pid'))

# Calculate emission (check Johanna's emission column)
dj <- dj[order(dj$pmid, dj$ct), ]
dj <- as.data.frame(mutate(group_by(dj, pmid), dt = c(0, diff(ct)), e.int = j.NH3 * dt, e.cum2 = cumsum(e.int), e.rel = e.cum / tan.app))

# Combine with the ALFAM2 data
ds <- rbindf(ds, dsj)
d <- rbindf(d, dj)
