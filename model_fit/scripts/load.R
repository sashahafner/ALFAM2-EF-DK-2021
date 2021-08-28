# Loads and cleans ALFAM2 data
# S. Hafner

# Read in data
d <- read.csv('../../database/ALFAM2_interval.csv', stringsAsFactors = TRUE)
ds <- read.csv('../../database/ALFAM2_plot.csv', stringsAsFactors = TRUE)

pmid.cal1 <- read.csv('../../model_cal/output/pmid_cal1.csv', stringsAsFactors = TRUE)
# 2 main
pmid.cal2 <- read.csv('../../model_cal/output/pmid_cal2.csv', stringsAsFactors = TRUE)
# 2 closed slot
pmid.cal2cs <- read.csv('../../model_cal/output/pmid_cal2cs.csv', stringsAsFactors = TRUE)
# 3 pH (separate cal)
pmid.cal3 <- read.csv('../../model_cal_pH/output/pmid_cal3.csv', stringsAsFactors = TRUE)
# 4 incorporation
pmid.cal4 <- read.csv('../../model_cal/output/pmid_cal4.csv', stringsAsFactors = TRUE)

pmid.cal1 <- pmid.cal1$x
pmid.cal2 <- pmid.cal2$x
pmid.cal2cs <- pmid.cal2cs$x
pmid.cal3 <- pmid.cal3$x
pmid.cal4 <- pmid.cal4$x
