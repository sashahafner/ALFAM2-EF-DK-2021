# Clean data

# Switch to newer names
names(d) <- gsub('method', 'mthd', names(d))
names(ds) <- gsub('method', 'mthd', names(ds))

# Fill in missing weather with means by plot
d$missingwind <- d$missingair.temp <- FALSE

for(i in unique(d$pmid)) {
  
  dd <- d[d$pmid == i, ] 
  
  if(any(is.na(dd$wind.2m))) {
    d[d$pmid == i & is.na(d$wind.2m), 'missingwind'] <- TRUE
    d[d$pmid == i & is.na(d$wind.2m), 'wind.2m'] <- mean(na.omit(d[d$pmid == i, 'wind.2m']))
  }
    
  if(any(is.na(dd$air.temp))) {
    d[d$pmid == i & is.na(d$air.temp), 'missingair.temp'] <- TRUE
    d[d$pmid == i & is.na(d$air.temp), 'air.temp'] <- mean(na.omit(d[d$pmid == i, 'air.temp']))
  }
  
}

# 
d$er <- d$e.rel

# Log10 wind speed
d$lwind <- log10(d$wind.2m)

# App rate
d$lapp.rate <- log10(d$app.rate)
d$lman.tan <- log10(d$man.tan)

# Add dummy variables
d <- addDummyVars(d)

# And another dummy variables for any crop x application mthd
d$crop.app.mthd.bc <- d$crop != 'bare soil' & d$app.mthd == 'bc'
d$crop.app.mthd.bsth <- d$crop != 'bare soil' & d$app.mthd == 'bsth'
d$crop.app.mthd.ts <- d$crop != 'bare soil' & d$app.mthd == 'ts'

# Crop height interactions
d$crop[is.na(d$crop)] <- 'bare soil'
d$crop.z[is.na(d$crop.z)] <- 0
d$grass.hght <- (d$crop == 'grass') * d$crop.z
d$cereal.hght <- (d$crop == 'cereal') * d$crop.z
d$bsth.grass.hght <- (d$app.mthd == 'bsth') * d$grass.hght
d$bsth.cereal.hght <- (d$app.mthd == 'bsth') * d$cereal.hght
d$ts.grass.hght <- (d$app.mthd == 'ts') * d$grass.hght
d$ts.cereal.hght <- (d$app.mthd == 'ts') * d$cereal.hght
d$bc.grass.hght <- (d$app.mthd == 'bc') * d$grass.hght
d$bc.cereal.hght <- (d$app.mthd == 'bc') * d$cereal.hght

# Application rate x open slot
d$app.rate.os <- d$app.rate * (d$app.mthd == 'os')
d$app.rate.nos <- d$app.rate * (d$app.mthd != 'os')

# Country dummy variables
for (i in unique(d$country)) {
  d[, paste0('country.', i)] <- d$country == i
}

# Order factors
ds$app.mthd <- factor(ds$app.mthd, levels = c('bsth', 'bc', 'ts', 'os', 'bss', 'cs', 'pi')) 
ds$meas.tech2 <- factor(ds$meas.tech2, levels = c('micro met', 'wt', 'chamber', 'cps'))
ds$incorp <- factor(ds$incorp, levels = c('none', 'shallow', 'deep'))

# Set NA in time.incorp or model code assumes incorporation (NTS: really?). 
d$time.incorp[d$incorp == 'none'] <- NA
ds$time.incorp[ds$incorp == 'none'] <- NA

# Convert till to integer for easier time in model (NTS: really?)
d$till <- as.integer(d$till) - 1

# Set missing rain to 0 with flag
d$flag <- as.character(d$flag)
d$flag[is.na(d$rain)] <- 'r'
d$rain[is.na(d$rain)] <- 0
d$rain.rate[is.na(d$rain.rate)] <- 0

# Re-calculate cumulative rain as average value
d <- d[order(d$pmid, d$ct), ]
d$rain.cum.tot <- d$rain.cum
d <- as.data.frame(mutate(group_by(d, pmid), rain.cum = cumsum(rain) - 0.5*dt*rain.rate))

# Make unique experiment codes for acid subset
ds$exper.code <- paste(ds$inst, ds$exper)
d$exper.code <- paste(d$inst, d$exper)
