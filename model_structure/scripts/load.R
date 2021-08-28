# Loads and cleans ALFAM2 data
# S. Hafner

# Read in data
d <- read.csv('../../database/ALFAM2_interval.csv', stringsAsFactors = TRUE)
ds <- read.csv('../../database/ALFAM2_plot.csv', stringsAsFactors = TRUE)
pmid.cal1 <- read.csv('../../model_cal/output/pmid_cal1.csv', stringsAsFactors = TRUE)
pmid.cal1 <- pmid.cal1$x
