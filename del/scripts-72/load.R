# Loads and cleans ALFAM2 data
# S. Hafner

# Read in data
d <- read.csv('../../database/ALFAM2_interval.csv')
ds <- read.csv('../../database/ALFAM2_plot.csv')
pmid.cal1 <- read.csv('../../model_cal/output/pmid_cal1.csv')
pmid.cal2 <- read.csv('../../model_cal/output/pmid_cal2.csv')
pmid.cal1 <- pmid.cal1$x
pmid.cal2 <- pmid.cal2$x
