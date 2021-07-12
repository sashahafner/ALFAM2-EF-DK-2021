
# Get latest times
x <- subset(dathm, ct == 168)
x$type <- 'hourly'
ds <- x

x <- subset(dathnm, ct == 168)
x$type <- 'hourly night'
ds <- rbind(ds, x)

x <- subset(dathnrm, ct == 168)
x$type <- 'hourly no rain'
ds <- rbind(ds, x)

x <- subset(datm, ct == 168)
x$type <- 'mean'
ds <- rbindf(ds, x)

x <- subset(datmf, ct == 168)
x$type <- 'mean w fudge factors'
ds <- rbindf(ds, x)

ds <- as.data.frame(summarise(group_by(ds, type), er.mn = mean(er), er.sd = sd(er)))

write.csv(ds, '../output/emis_mean.csv', row.names = FALSE)
# Manual trial-and-error used to pick temp and wind adjustments with equal effects
#print(rounddf(ds, digits = 3))

# Get wide data frame for bivariate plot
datw <- merge(dath, dathnr[, c('sim', 'ct', 'er')], by = c('sim', 'ct'), suffixes = c('.r', '.nr'))
datw168 <- subset(datw, ct == 168)

# Export
write.csv(dath, '../output/dath.csv', row.names = FALSE)
