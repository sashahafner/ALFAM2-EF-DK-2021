# Sort out scenario variables

t.max <- 168
dt <- 1 
nt <- ceiling(t.max/dt)

app.mthds <- c('bc', 'bsth', 'ts', 'os', 'cs')
n.app.mthds <- length(app.mthds)
dat <- inputs[rep(seq(nrow(inputs)), each = nt*n.app.mthds), ]
dat$app.mthd <- rep(app.mthds, each = nt)

dat$dt <- dt
dat <- as.data.frame(mutate(group_by(dat, sid, app.mthd), ct = cumsum(dt)))

# Rain only falls during first 3 h
dat$rain.rate[dat$ct > 3] <- 0

dat <- as.data.frame(mutate(group_by(dat, sid, app.mthd), ct = cumsum(dt), rain.cum = cumsum(rain.rate)))

# Adjust temperature for heating and cooling simulations
# Set amplitude 
amp <- 20
dat[dat$descrip == 'cooling', 'air.temp'] <- dat[dat$descrip == 'cooling', 'air.temp'] -  
  (dat[dat$descrip == 'cooling', 'ct'] - mean(dat[dat$descrip == 'cooling', 'ct']))*amp/168
dat[dat$descrip == 'warming', 'air.temp'] <- dat[dat$descrip == 'warming', 'air.temp'] + 
  (dat[dat$descrip == 'warming', 'ct'] - mean(dat[dat$descrip == 'warming', 'ct']))*amp/168

# Add some factor levels for dummy vars
dat$app.mthd <- factor(dat$app.mthd, levels = c('bc', 'bsth', 'ts', 'os', 'cs'))
dat$incorp <- factor(dat$incorp, levels = c('none', 'shallow', 'deep'))
dat$man.source <- factor(dat$man.source, levels = c('cat', 'pig'))

# Dummy variables
dat$app.mthd.bc <- dat$app.mthd == 'bc'
dat$app.mthd.os <- dat$app.mthd == 'os'
dat$app.mthd.cs <- dat$app.mthd == 'cs'
dat$app.mthd.ts <- dat$app.mthd == 'ts'
dat$man.source.pig <- dat$man.source == 'pig'
dat$incorp.deep <- dat$incorp == 'deep'
dat$incorp.shallow <- dat$incorp == 'shallow'
dat$ts.cereal.hght <- (dat$app.mthd == 'ts') * dat$cereal.hght
dat$app.rate.ni <- (!dat$app.mthd %in% c('os', 'cs')) * dat$app.rate

# Sim ID plus application method for unique value for each sim
dat$sida <- paste0(dat$sid, dat$app.mthd)
