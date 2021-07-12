# Clean data

# Date and time
dat$date.time <- dmy_hm(paste(dat$date, dat$time, ':00'))
dat$date <- dmy(dat$date)
dat$yr <- year(dat$date.time)

# Add wind at 2 m
# This should exactly match code in /home/sasha/GitHub_repos/ALFAM2-emis-factors/weather/scripts/clean.R
dat$wind.2m <- dat$meanwv * log(2/0.01) / log(10/0.01)

# Rain rate (cumulative depends on start time)
dat$rain.rate <- dat$prec / 1

# Air temperature
dat$air.temp <- dat$metp

# Calculate 3 h averages
# Note that new time column is meant to be ct = end of 3 hour period over which emission should be predicted
# Because weather data has time = 0, it must be for *following* hour, which is why I have added + 1 below
dat$h3grp <- dat$time %/% 3
dat3 <- as.data.frame(summarise(group_by(dat, yr, date, h3grp), time = max(time) + 1, wind.2m = mean(wind.2m), 
                                rain.rate = mean(rain.rate), air.temp = mean(air.temp)))
dat3$date.time <- ymd_hm(paste(dat3$date, dat3$time, ':00'))
