# Loads and cleans ALFAM2 data
# S. Hafner

# Read in data
d <- read.csv('../../database/ALFAM2_interval.csv')
ds <- read.csv('../../database/ALFAM2_plot.csv')
pmid.cal1 <- read.csv('../../model_cal/output/pmid_cal1.csv')
pmid.cal2 <- read.csv('../../model_cal/output/pmid_cal2.csv')
pmid.cal2cs <- read.csv('../../model_cal/output/pmid_cal2cs.csv')
pmid.cal3 <- read.csv('../../model_cal/output/pmid_cal3.csv')
pmid.cal4 <- read.csv('../../model_cal/output/pmid_cal4.csv')
pmid.cal1 <- pmid.cal1$x
pmid.cal2 <- pmid.cal2$x
pmid.cal2cs <- pmid.cal2cs$x
pmid.cal3 <- pmid.cal3$x
pmid.cal4 <- pmid.cal4$x
