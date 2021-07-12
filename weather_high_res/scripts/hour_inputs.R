# Sort out inputs

# NTS: Need to decide if e.g., 9.00 has means for following or preceding hour

# Create starting dates
# All possible dates in April, always at app.time time (settings.R)
ddat <- expand.grid(d = 1:(30 - dur), y = 2014:2020)
start.date.time <- mdy_hm(paste('4', ddat$d, ddat$y, app.time))

# Create separate data frame for each starting date
# All combined in dath (h = hourly, really 3 hourly)
dath <- data.frame()

for (i in 1:length(start.date.time)) {

  # Get times in dat3
  ddt <- difftime(dat3$date.time, start.date.time[i], units = 'days')
  dd <- dat3[ddt > 0 & ddt <= dur, ]

  # Time and rain
  dd$ct <- 1:nrow(dd) * 3
  dd$rain.cum <- cumsum(dd$rain.rate * 1) - dd$rain.rate * 1 / 2

  dd$sim <- i
  dath <- rbind(dath, dd)
}

# Repeat for night application
start.date.time <- mdy_hm(paste('4', ddat$d, ddat$y, app.time.night))

dathn <- data.frame()

for (i in 1:length(start.date.time)) {

  # Get times in dat3
  ddt <- difftime(dat3$date.time, start.date.time[i], units = 'days')
  dd <- dat3[ddt > 0 & ddt <= dur, ]

  # Time and rain
  dd$ct <- 1:nrow(dd) * 3
  dd$rain.cum <- cumsum(dd$rain.rate * 1) - dd$rain.rate * 1 / 2

  dd$sim <- i
  dathn <- rbind(dathn, dd)
}

# Add other variables
dath$man.dm <- man.dm
dath$man.ph <- man.ph
dath$app.rate.ni <- app.rate.ni
dath$tan.app <- tan.app

dathn$man.dm <- man.dm
dathn$man.ph <- man.ph
dathn$app.rate.ni <- app.rate.ni
dathn$tan.app <- tan.app

# Create version without rain for comparison
dathnr <- dath
dathnr$rain.rate <- dathnr$rain.cum <- 0
