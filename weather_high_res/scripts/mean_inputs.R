# Calculate means of weather data for use of mean model

datm <- as.data.frame(summarise(group_by(dat, yr),
                  wind.2m = mean(wind.2m),
                  rain.rate = mean(rain.rate),
                  air.temp = mean(air.temp)))

# Also run dur days, hourly, to see progression
datm <- datm[rep(1:nrow(datm), each = dur * 24), ]
datm <- as.data.frame(mutate(group_by(datm, yr), 
                             ct = 1:length(yr),
                             rain.cum = cumsum(rain.rate * 1) - rain.rate * 1 / 2
                             ))
datm$sim <- datm$yr

# Add other variables
datm$man.dm <- man.dm
datm$man.ph <- man.ph
datm$app.rate.ni <- app.rate.ni
datm$tan.app <- tan.app

# Add fudge factors to means
datmf <- datm
datmf$air.temp <- ff.air + datmf$air.temp
datmf$wind.2m <- ff.wind * datmf$wind.2m
