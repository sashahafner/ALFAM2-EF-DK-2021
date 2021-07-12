# Loads and cleans ALFAM2 data
# S. Hafner

# Read in data
d <- read.csv('../../database/ALFAM2_interval.csv')
ds <- read.csv('../../database/ALFAM2_plot.csv')

pmid1 <- read.csv('../data/pmid_cal1.csv')$x
pmid2 <- read.csv('../data/pmid_cal2.csv')$x
pmid3 <- read.csv('../data/pmid_cal3.csv')$x
