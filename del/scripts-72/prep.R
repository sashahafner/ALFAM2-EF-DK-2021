# Prepare data for model

d$app.mthd.bc <- d$app.method == 'bc'
d$app.mthd.os <- d$app.method == 'os'
d$man.ph[is.na(d$man.ph)] <- 7.5
d$rain.cum[is.na(d$rain.cum)] <- 0
d$rain.rate[is.na(d$rain.rate)] <- 0
d$wind.2m[is.na(d$wind.2m)] <- 2.7
d$man.source.pig <- d$man.source == 'pig'
d$app.mthd.ts <- d$app.method == 'ts'
d$ts.cereal.hght <- (d$app.method == 'ts') * (d$crop == 'cereal') * d$crop.z
d$app.rate.nos <- (d$app.method != 'os') * d$app.rate
