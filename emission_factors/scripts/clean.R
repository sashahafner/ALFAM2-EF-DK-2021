# Clean up output for plots

# Sort factor levels
dat$app.timing.d <- factor(dat$app.timing.d, levels = c('Marts', 'April', 'Maj', 'Forår-sommer', 
                                                    'Sommer', 'Sommer, før vinterraps', 
                                                    'Sommer, græsnedfældning', 'Sensommer-efterår', 
                                                    'Efterår', 'Vinter-forår'))

dat$app.timing <- factor(dat$app.timing, levels = c('March', 'April', 'May', 'Spring-summer',
                                                    'Summer', 'Summer, before winter rapeseed',
                                                    'Summer, grass', 'Late summer-autumn', 
                                                    'Autumn', 'Winter-spring'))

dat$app.mthd <- factor(dat$app.mthd, levels = c('Broadcast', 'Trailing hose', 'Open slot injection', 'Closed slot injection'))

dat$man.source <- factor(dat$man.source, levels = c('Cattle', 'Pig', 'Digestate'))

dat$man.trt <- factor(dat$man.trt, levels = c('None', 'Barn acidified', 'Field acidified'))

dat$man.trt.nm <- factor(dat$man.trt, levels = c('None', 'Barn acidified', 'Field acidified'),
                         labels = c('No treatment', 'Barn acidified', 'Field acidified'))

dat$incorp.nm <- factor(dat$incorp, levels = c('None', 'Shallow', 'Deep'), 
                     labels = c('No incorp.', 'Shallow incorp.', 'Deep incorp.'))

# Relative changes over time
dat <- as.data.frame(mutate(group_by(dat, man.trt, man.source, app.mthd, crop.status, app.timing, incorp.timing, incorp),
                            EF.rel = 100 * EF/EF[decade == 1980] - 100))

# Express emission factor as a percentage
dat$EFp <- 100 * dat$EF

# Fill in some blanks with more logical names
dat$crop[is.na(dat$crop)] <- 'None'
dat$crop.hght[is.na(dat$crop.hght)] <- 0
dat$incorp.timing[is.na(dat$incorp.timing)] <- 'None'

