# Load data

ff <- list.files('../data', full.names = TRUE)

dat <- data.frame()

for (i in ff) {
  dat <- rbind(dat, read.csv(i))
}
