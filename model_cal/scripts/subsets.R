# Make subsets for modeling fitting

# Original counts
dim(d)
dim(ds)

# Drop plots with first dt > 24
longdt <- ds[ds$dt1 > 24, ]
d <- d[!d$pmid %in% longdt$pmid, ]
ds <- ds[!ds$pmid %in% longdt$pmid, ]
dim(d)
dim(ds)

# Find earliest time beyond 168 hr (but not longer than 200 hr) for each pmid
d <- as.data.frame(mutate(group_by(d, pmid), 
			  ct.168 = sort(ct[ct >= 168 & ct < 200])[1],
			  ct.72 = sort(ct[ct >= 72 & ct < 78])[1],
			  ct.48 = sort(ct[ct >= 48 & ct < 72])[1],
			  ct.24 = sort(ct[ct >= 24 & ct < 48])[1],
			  ct.0 =  sort(ct[ct > 0 & ct < 24])[1],
			  ct.max.200 = max(ct[ct < 200])[1],
			  ct.max = max(ct))
)

# Set missing values (no ct > 72) to max ct below 78 hr
mean(is.na(d$ct.168))
d$ct.168[is.na(d$ct.168)] <- d$ct.max.200[is.na(d$ct.168)]
mean(is.na(d$ct.168))
mean(d$ct.168)
median(d$ct.168)
quantile(d$ct.168)

#-------------------------------------------------------------------------------------------------
# Subset 1
# Select pmid with data for all necessary variables
# Micromet only
# No acidification, no incorporation
# Manure pH not required
ds1 <- ds[!is.na(ds$e.24) &
          !is.na(ds$app.mthd) &
          !is.na(ds$man.dm) &
          !is.na(ds$man.source) & 
          !is.na(ds$air.temp.24) & 
          !is.na(ds$wind.2m.24) & 
          !is.na(ds$till) & 
          !is.na(ds$incorp) & 
          !is.na(ds$crop) & 
          !ds$acid &
          ds$incorp == 'none' &
          ds$e.24 > 0 & 
          ds$e.rel.24 < 1.0 &
          ds$man.source %in% c('cat', 'pig') &
          ds$man.dm <= 15 &
          ds$app.mthd != 'pi' &
          #ds$app.mthd != 'cs' &
          ds$app.mthd != 'bss' &
          ds$meas.tech2 == 'micro met' &
          !ds$inst %in% c(102, 107, 108) & # Exclude AUN, old Swiss (IUL/FAT), and JTI
          ds$pmid != 1526 & # See rows 1703 and 1728 and others in MU data. Check with Marco
          ds$pmid != 1183 & # Closed slot negative emission
          !grepl('Exclude data from analysis', ds$notes)
          , ]

# These pmid will be retained (more trimming below)
pmid.keep <- ds1$pmid

# Drop obs with high 168 h emis (thinking of 1184 e.rel.72 1.10 for bsth!)
# More than 105% at 168 hr is too much
pmid.keep <- pmid.keep[!pmid.keep %in% unique(d[d$e.rel > 1.05 & d$ct == d$ct.168, 'pmid'])]

# Keep only those with > 10 plots
table(ds1$country)
pmid.keep <- pmid.keep[pmid.keep %in% ds[ds$country %in% c('CH', 'DK', 'FR', 'IE', 'NL', 'UK'), 'pmid']]

# Main subset (trimmed below also)
d1 <- droplevels(d[d$pmid %in% pmid.keep & d$ct <= d$ct.168 & d$ct > 0, ])
ds1 <- droplevels(ds[ds$pmid %in% pmid.keep, ])
quantile(d1$ct.168, na.rm = TRUE)
range(d1$ct.168, na.rm = TRUE)

# How many dropped?
dim(d)
dim(d1)

dim(ds)
dim(ds1)

# Check number of plots per country
table(ds$country)
table(ds1$country)
table(ds1$country, ds1$app.mthd)
table(ds1$inst, ds1$app.mthd)
table(ds1$country, ds1$man.source)

### NTS!!!
### For weighting, decide we need at least 5 obs per application mthd per country
### Drop those that are too low
##length(pmid.keep)
##pmid.keep <- pmid.keep[!pmid.keep %in% d[(d$country == 'CH' & d$app.mthd == 'os') |
##                                         (d$country == 'FR' & d$app.mthd == 'ts') |
##                                         (d$country == 'NL' & d$app.mthd == 'bsth')
##                                         , 'pmid']]
##length(pmid.keep)
### Lost 5 plots

# Look for missing values
dfsumm(d1[, c('e.int', 'app.mthd', 'man.dm', 'man.source', 'air.temp', 
              'wind.2m', 'lwind', 'rain.rate', 'rain.cum', 'till', 'incorp', 'crop')])

# None missing

# And drop all pmids that have one or more missing e.int
pmid.keep <- pmid.keep[!pmid.keep %in% d1[is.na(d1$e.int), 'pmid']]
length(pmid.keep)
dim(d1)
d1 <- d1[d1$pmid %in% pmid.keep, ]
ds1 <- ds1[ds1$pmid %in% pmid.keep, ]
# How many dropped?
dim(d)
dim(d1)
dim(ds)
dim(ds1)

# Save pmid for plotting subsets
pmid.cal1 <- pmid.keep
write.csv(pmid.cal1, '../output/pmid_cal1.csv', row.names = FALSE)

#-------------------------------------------------------------------------------------------------
# Subset 2
# No acidification 
# No incorporation
# Manure pH required
ds2 <- ds[!is.na(ds$e.24) &
          !is.na(ds$app.mthd) &
          !is.na(ds$man.dm) &
          !is.na(ds$man.source) & 
          !is.na(ds$air.temp.24) & 
          !is.na(ds$wind.2m.24) & 
          !is.na(ds$till) & 
          !is.na(ds$incorp) & 
          !is.na(ds$crop) & 
          !is.na(ds$man.ph) & 
          !ds$acid &
          ds$incorp == 'none' &
          ds$e.24 > 0 & 
          ds$e.rel.24 < 1.0 &
          ds$man.source %in% c('cat', 'pig') &
          ds$man.dm <= 15 &
          ds$app.mthd != 'pi' &
          ds$app.mthd != 'cs' &
          ds$app.mthd != 'bss' &
          ds$meas.tech2 == 'micro met' &
          !ds$inst %in% c(102, 107, 108) & # Exclude AUN, old Swiss (IUL/FAT), and JTI
          ds$pmid != 1526 & # See rows 1703 and 1728 and others in MU data. Check with Marco
          ds$pmid != 1183 & # Closed slot negative emission
          !grepl('Exclude data from analysis', ds$notes)
          , ]

# These pmid will be retained (more trimming below)
pmid.keep <- ds2$pmid

# Drop obs with high 168 h emis (thinking of 1184 e.rel.72 1.10 for bsth!)
# More than 105% at 168 hr is too much
pmid.keep <- pmid.keep[!pmid.keep %in% unique(d[d$e.rel > 1.05 & d$ct == d$ct.168, 'pmid'])]

# Keep only those with > 10 plots (drop CA, DE, IT)
table(ds2$country)
pmid.keep <- pmid.keep[pmid.keep %in% ds[ds$country %in% c('CH', 'DK', 'FR', 'IE', 'NL', 'UK'), 'pmid']]

# Main subset (trimmed below also)
d$pmid.d2 <- d$pmid %in% pmid.keep
d2 <- droplevels(d[d$pmid %in% pmid.keep & d$ct <= d$ct.168 & d$ct > 0, ])
ds2 <- droplevels(ds[ds$pmid %in% pmid.keep, ])
quantile(d2$ct.168, na.rm = TRUE)
range(d2$ct.168, na.rm = TRUE)

# How many dropped?
dim(d)
dim(d2)

dim(ds)
dim(ds2)

# Check number of plots per country
table(ds$country)
table(ds2$country)
table(ds2$country, ds2$app.mthd)
length(pmid.keep)

# Look for missing values
dfsumm(d2[, c('e.int', 'app.mthd', 'man.dm', 'man.source', 'air.temp', 
              'wind.2m', 'lwind', 'rain.rate', 'rain.cum', 'till', 'incorp', 'crop')])

# None missing

# And drop all pmids that have one or more missing e.int
pmid.keep <- pmid.keep[!pmid.keep %in% d2[is.na(d2$e.int), 'pmid']]
length(pmid.keep)
dim(d2)
d2 <- d2[d2$pmid %in% pmid.keep, ]
ds2 <- ds2[ds2$pmid %in% pmid.keep, ]
# How many dropped?
dim(d)
dim(d2)
dim(ds)
dim(ds2)

# Save pmid for plotting subsets
pmid.cal2 <- pmid.keep
write.csv(pmid.cal2, '../output/pmid_cal2.csv', row.names = FALSE)

#-------------------------------------------------------------------------------------------------
# Subset 2cs
# As with 2 but for closed slot *only*
# No acidification 
# No incorporation
# Manure pH required
# Drop "Unter" experiment closed slot results (see discussion on this in 21 May 2021 minutes)
ds2cs <- ds[!is.na(ds$e.24) &
            !is.na(ds$app.mthd) &
            !is.na(ds$man.dm) &
            !is.na(ds$man.source) & 
            !is.na(ds$air.temp.24) & 
            !is.na(ds$wind.2m.24) & 
            !is.na(ds$till) & 
            !is.na(ds$incorp) & 
            !is.na(ds$crop) & 
            !is.na(ds$man.ph) & 
            !ds$acid &
            ds$incorp == 'none' &
            ds$e.24 > 0 & 
            ds$e.rel.24 < 1.0 &
            ds$man.source %in% c('cat', 'pig') &
            ds$man.dm <= 15 &
            ds$app.mthd == 'cs' &
            ds$meas.tech2 == 'micro met' &
            !ds$inst %in% c(102, 107, 108) & # Exclude AUN, old Swiss (IUL/FAT), and JTI
            ds$pmid != 1526 & # See rows 1703 and 1728 and others in MU data. Check with Marco
            ds$pmid != 1183 & # Closed slot negative emission
            !(grepl('^Unter', ds$exper) & ds$app.mthd == 'cs') &
            !grepl('Exclude data from analysis', ds$notes)
            , ]

# Add in SDU DTM results 
cspart <- ds[ds$inst == 211 & ds$app.mthd == 'cs', ]
ds2cs <- rbind(ds2cs, cspart)

# These pmid will be retained (more trimming below)
pmid.keep <- ds2cs$pmid

# Drop obs with high 168 h emis (thinking of 1184 e.rel.72 1.10 for bsth!)
# More than 105% at 168 hr is too much
pmid.keep <- pmid.keep[!pmid.keep %in% unique(d[d$e.rel > 1.05 & d$ct == d$ct.168, 'pmid'])]

# Main subset (trimmed below also)
d$pmid.d2cs <- d$pmid %in% pmid.keep
d2cs <- droplevels(d[d$pmid %in% pmid.keep & d$ct <= d$ct.168 & d$ct > 0, ])
ds2cs <- droplevels(ds[ds$pmid %in% pmid.keep, ])
quantile(d2cs$ct.168, na.rm = TRUE)
range(d2cs$ct.168, na.rm = TRUE)

# How many dropped?
dim(d)
dim(d2cs)

dim(ds)
dim(ds2cs)

# Check number of plots per country
table(ds$country)
table(ds2cs$country)
table(ds2cs$country, ds2cs$app.mthd)
length(pmid.keep)

# Look for missing values
dfsumm(d2cs[, c('e.int', 'app.mthd', 'man.dm', 'man.source', 'air.temp', 
              'wind.2m', 'lwind', 'rain.rate', 'rain.cum', 'till', 'incorp', 'crop')])

# None missing

# And drop all pmids that have one or more missing e.int
pmid.keep <- pmid.keep[!pmid.keep %in% d2cs[is.na(d2cs$e.int), 'pmid']]
length(pmid.keep)
dim(d2cs)
d2cs <- d2cs[d2cs$pmid %in% pmid.keep, ]
ds2cs <- ds2cs[ds2cs$pmid %in% pmid.keep, ]
# How many dropped?
dim(d)
dim(d2cs)
dim(ds)
dim(ds2cs)

# Save pmid for plotting subsets
pmid.cal2cs <- pmid.keep
write.csv(pmid.cal2cs, '../output/pmid_cal2cs.csv', row.names = FALSE)


#-------------------------------------------------------------------------------------------------
# 3rd subset, acidification only
# Acidification subset
# Do not need all predictor variables
# Subset based on most above criteria plus within these acid experiments
acid.exper <- unique(ds[ds$acid, c('inst', 'exper', 'exper.code')])
acid.exper.code <- acid.exper$exper.code
ds3 <- ds[!is.na(ds$e.24) & 
          !is.na(ds$app.mthd) & 
          !is.na(ds$incorp) & 
          !is.na(ds$crop) & 
          ds$e.24 > 0 & 
          ds$e.rel.24 < 2 &
          ds$man.dm <= 15 &
          ds$app.mthd != 'pi' &
          ds$app.mthd != 'cs' &
          ds$meas.tech2 != 'chamber' &
          ds$inst != 108 & 
          ds$inst != 102 &
          ds$inst != 211 & # Drop SDU
          ds$pmid != 1526 & # See rows 1703 and 1728 and others in MU data. Check with Marco
          ds$app.mthd != 'os' &
          ds$exper.code %in%  acid.exper.code
         , ]

ds3 <- droplevels(ds3)
pmid.keep <- ds3$pmid

table(ds3$country)
table(ds3$inst)

# Limit to 168 hours
d3 <- d[d$pmid %in% pmid.keep & d$ct <= d$ct.168 & d$ct >= 0, ]

# Look for missing values
dfsumm(d3[, c('e.int', 'app.mthd', 'man.dm', 'man.source', 'air.temp', 
              'wind.2m', 'till', 'incorp', 'crop')])

# Missing air temperature and wind, but does not matter here

table(ds3$exper, ds3$inst)
table(ds3$inst, ds3$date.start)

pmid.cal3 <- pmid.keep
write.csv(pmid.cal3, '../output/pmid_cal3.csv', row.names = FALSE)

#-------------------------------------------------------------------------------------------------
# 4th subset, incorporation experiments
incorp.exper <- unique(ds[ds$incorp != 'none', c('inst', 'exper', 'exper.code')])
incorp.exper.code <- incorp.exper$exper.code
d4 <- d[d$exper.code %in% incorp.exper.code & d$app.mthd != 'cs', ]
# Also drop some with high DM (Hansen's 2004 work)
# Exclude AUN, old Swiss (IUL/FAT), and JTI
ds4 <- droplevels(ds[ds$exper.code %in% incorp.exper.code & ds$app.mthd != 'cs' & ds$man.dm <= 15 & !ds$inst %in% c(102, 107, 108), ])

# Problem with missing app.mthd
ds4 <- ds4[!is.na(ds4$app.mthd), ]
table(ds4$exper.code, ds4$incorp, exclude = NULL)

# Drop some with no comparison to 'none'
incorp.exper.code <- incorp.exper.code[incorp.exper.code %in% unique(ds4[ds4$incorp == 'none', 'exper.code'])]

d4 <- subset(d4, exper.code %in% incorp.exper.code)
ds4 <- droplevels(subset(ds4, exper.code %in% incorp.exper.code))
table(ds4$exper.code, ds4$incorp)
table(d4$exper.code, d4$incorp)

pmid.cal4 <- unique(ds4$pmid)
write.csv(pmid.cal4, '../output/pmid_cal4.csv', row.names = FALSE)

#-------------------------------------------------------------------------------------------------
# 5th subset, like 3rd acidification only but include SDU chamber results (inst 211)
acid.exper <- unique(ds[ds$acid, c('inst', 'exper', 'exper.code')])
acid.exper.code <- acid.exper$exper.code
ds5 <- ds[!is.na(ds$e.24) & 
          !is.na(ds$app.mthd) & 
          !is.na(ds$incorp) & 
          !is.na(ds$crop) & 
          ds$app.mthd != 'cs' &
          ds$e.24 > 0 & 
          ds$e.rel.24 < 2 &
          ds$man.dm <= 15 &
          ds$app.mthd != 'pi' &
          ds$app.mthd != 'cs' &
          ds$inst != 108 & 
          ds$inst != 102 &
          ds$pmid != 1526 & # See rows 1703 and 1728 and others in MU data. Check with Marco
          ds$app.mthd != 'os' &
          ds$exper.code %in%  acid.exper.code
         , ]

ds5 <- droplevels(ds5)
pmid.keep <- ds5$pmid

table(ds5$country)
table(ds5$inst)

# Limit to 168 hours
d5 <- d[d$pmid %in% pmid.keep & d$ct <= d$ct.168 & d$ct >= 0, ]

# Look for missing values
dfsumm(d5[, c('e.int', 'app.mthd', 'man.dm', 'man.source', 'air.temp', 
              'wind.2m', 'till', 'incorp', 'crop')])

table(ds5$exper, ds5$inst)
table(ds5$inst, ds5$date.start)
pmid.cal5 <- pmid.keep

#-------------------------------------------------------------------------------------------------

# DK subset
ddk <- subset(d2, country == 'DK' & incorp == 'none')
dim(ddk)
dsdk <- subset(ds2, country  == 'DK' & incorp == 'none')

#-------------------------------------------------------------------------------------------------

# Prediction subset, for model evaluation, excludes chamber results
dpred <- subset(d, pmid %in% unique(c(pmid.cal2, pmid.cal3, pmid.cal4)))
dspred <- subset(ds, pmid %in% unique(c(pmid.cal2, pmid.cal3, pmid.cal4)))

# Cal subset includes all plots used for calibration
dcal <- subset(d, pmid %in% unique(c(pmid.cal2, pmid.cal3, pmid.cal5)))
dscal <- subset(ds, pmid %in% unique(c(pmid.cal2, pmid.cal3, pmid.cal5, pmid.cal2cs)))

#-------------------------------------------------------------------------------------------------
# Add weights to all subsets
d1 <- as.data.frame(mutate(group_by(d1, pmid), weightp = 1/sum(!is.na(e.int))))
d1 <- as.data.frame(mutate(group_by(d1, country), weightc = 1/sum(!is.na(e.int))))
d1 <- as.data.frame(mutate(group_by(d1, country, app.mthd), weightca = 1/sum(!is.na(e.int))))
d1 <- as.data.frame(mutate(group_by(d1, country, app.mthd, man.source), weightcas = 1/sum(!is.na(e.int))))
d2 <- as.data.frame(mutate(group_by(d2, pmid), weightp = 1/sum(!is.na(e.int))))
d2 <- as.data.frame(mutate(group_by(d2, country), weightc = 1/sum(!is.na(e.int))))
d2 <- as.data.frame(mutate(group_by(d2, country, app.mthd), weightca = 1/sum(!is.na(e.int))))
d2 <- as.data.frame(mutate(group_by(d2, country, app.mthd, man.source), weightcas = 1/sum(!is.na(e.int))))
