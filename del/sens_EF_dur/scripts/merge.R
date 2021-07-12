# Merge inputs

# Duplicate conditions df for all decades
dat <- merge(conds, data.frame(decade = c(1980  + 0:3 * 10)), by = NULL)

# Add slurry comp info
comp$man.source.pig <- ifelse(comp$man.source == 'Pig', 1, 0)
dat <- merge(dat, comp, by = c('man.trt', 'man.source', 'decade'), all = TRUE)

# Add incorporation
dat <- merge(dat, incorp, by = 'incorp.timing', all = TRUE)
dat$incorp[is.na(dat$incorp)] <- 'None'
dat$incorp.deep <- !is.na(dat$incorp) & dat$incorp == 'Deep'
dat$incorp.shallow <- !is.na(dat$incorp) & dat$incorp == 'Shallow'

# Add crop and application data
dat <- merge(dat, crops, by = c('app.mthd', 'crop.status', 'app.timing'), all = TRUE)
dat$cereal.hght[is.na(dat$cereal.hght)] <- 0
dat$bsth.cereal.hght <- (dat$app.mthd == 'Trailing hose') * dat$cereal.hght

# Duplicate dates for all decades
c1 <- data.frame(dates, decade = 1980)
c2 <- data.frame(dates, decade = 1990)
c3 <- data.frame(dates, decade = 2000)
c4 <- data.frame(dates, decade = 2010)
dates <- rbind(c1, c2, c3, c4)

# Add weather means to dates df
# All month data in dates are inclusive (see >= or <= in loop below)
dates$wind.2m <- dates$air.temp <- NA
for (i in 1:nrow(dates)) {
  dec <- dates$decade[i]
  lwr <- dates$month.start[i]
  upr <- dates$month.end[i]
  if (lwr <= upr) { 
    ww <- weather[weather$decade == dec & weather$month >= lwr & weather$month <= upr, ]
  } else {
    ww <- weather[weather$decade == dec & weather$month <= lwr & weather$month >= upr, ]
  }
  dates[i, 'wind.2m'] <- mean(ww$wind.2m)
  dates[i, 'air.temp'] <- mean(ww$air.temp)
}

# Add weather (in dates) to dat
dat <- merge(dat, dates, by = c('decade', 'app.timing'), all = TRUE)

# Add application method info
dat$app.mthd.bc <- ifelse(dat$app.mthd == 'Broadcast', 1, 0)
dat$app.mthd.os <- ifelse(dat$app.mthd == 'Open slot injection', 1, 0)

# Set fixed application rate
dat$app.rate <- 30
dat$tan.app <- dat$man.tan * dat$app.rate
dat$app.rate.nos <- dat$app.rate * !dat$app.mthd.os

# Add fixed rainfall rate and 6 hour intervals
dat <- dat[rep(1:nrow(dat), 40), ]
dat$ct <- rep(seq(6, 240, by = 6), each = nrow(dat)/40)
######
#####
### WIP, need actual rate!
dat$rain.rate <- 0.074
dat$rain.cum <- dat$rain.rate * (dat$ct - 3)

# Add detailed key and sort
dat$id1 <- dat$id
dat$id <- sprintf('%04d', dat$id)
dat$id <- paste0(dat$id, '-', dat$decade)
dat <- dat[order(dat$decade, dat$id, dat$ct), ]
