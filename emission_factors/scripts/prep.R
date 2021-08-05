# Merge inputs

# Duplicate conditions df for all decades
dat <- merge(conds, data.frame(decade = c(1980  + 0:3 * 10)), by = NULL)

# Add slurry comp info
comp$man.source.pig <- ifelse(comp$man.source == 'Pig', 1, 0)
dat <- merge(dat, comp, by = c('man.trt', 'man.source', 'decade', 'man.descrip.d', 'man.source.d'), all = TRUE)

# Add incorporation
dat <- merge(dat, incorp, by = 'incorp.timing', all = TRUE)
dat$incorp[is.na(dat$incorp)] <- 'None'
dat$incorp.deep <- !is.na(dat$incorp) & dat$incorp == 'Deep'
dat$incorp.shallow <- !is.na(dat$incorp) & dat$incorp == 'Shallow'

# Add description for tables
dat$incorp.descrip <- paste(dat$incorp, dat$incorp.timing)
dat$incorp.descrip[dat$app.mthd %in% c('Closed slot injection', 'Open slot injection')] <- 'Not relevant'
dat$incorp.descrip[grepl('^None', dat$incorp.descrip)] <- 'None'
dat$incorp.descrip <- gsub('\\.0$', ' hr', dat$incorp.descrip)
dat$incorp.descrip <- gsub('hours', ' hr', dat$incorp.descrip)
dat$incorp.descrip <- factor(dat$incorp.descrip, levels = c('None', 
                                                            'Shallow 24 hr', 'Shallow > 12 hr', 'Shallow 12 hr', 'Shallow < 12 hr', 
                                                            'Shallow 6 hr', 'Shallow 4 hr',
                                                            'Deep 24 hr', 'Deep > 12 hr', 'Deep 12 hr', 'Deep < 12 hr', 
                                                            'Deep 6 hr', 'Deep 4 hr'))
table(dat$incorp.descrip)

# Add crop and application data
dat <- merge(dat, crops, by = c('app.mthd', 'crop.status', 'app.timing', 'app.mthd.d', 'app.timing.d'), all = TRUE)
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
dat <- merge(dat, dates, by = c('decade', 'app.timing', 'app.timing.d'), all = TRUE)

# Adjust weather, apply fudge factors
dat$wind.2m <- 1.15 * dat$wind.2m
dat$air.temp <- dat$air.temp + 0.9

# Add rainfall rate (mm/h)
dat$rain.rate <- 0.09 # From 750 mm/yr for Jutland from Tavs

# Add application method info
dat$app.mthd.bc <- ifelse(dat$app.mthd == 'Broadcast', 1, 0)
dat$app.mthd.os <- ifelse(dat$app.mthd == 'Open slot injection', 1, 0)
dat$app.mthd.cs <- ifelse(dat$app.mthd == 'Closed slot injection', 1, 0)
# Check for data entry errors in injection only
if (any(dat$app.mthd == 'cs' & dat$crop.status == '+')) stop('Problem with data entry, B8163')
if (any(dat$app.mthd == 'os' & dat$crop.status == '-')) stop('Problem with data entry, B8164')

# Set fixed application rate
dat$app.rate <- 30
dat$tan.app <- dat$man.tan * dat$app.rate
dat$app.rate.ni <- dat$app.rate * ! (dat$app.mthd.os | dat$app.mthd.cs)

# Add reference conditions for test of ALFAM2 calculations
ref <- data.frame(ct = 168, t.incorp = NA,
                  tan.app = 100,
                  app.mthd.os = 0, app.rate.ni = 40, man.dm = 6, man.source.pig = 0,
                  app.mthd.cs = 0, app.mthd.bc = 0, app.mthd.ts = 0,
                  air.temp = 13, wind.2m = 2.7, 
                  ts.cereal.hght = 0, 
                  man.ph = 7.5, rain.rate = 0)

# Add fixed time
dat$ct <- 168

# Add detailed key and sort
dat$id1 <- dat$id
dat$id <- sprintf('%03d', dat$id)
dat$id <- paste0(dat$id, '-', dat$decade)
dat <- dat[order(dat$decade, dat$id), ]
