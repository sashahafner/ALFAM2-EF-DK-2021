# Make subsets for modeling fitting

# Find earliest time beyond 72 hr (but not longer than 78 hr) for each pmid
d <- as.data.frame(mutate(group_by(d, pmid), 
			  ct.72 = sort(ct[ct >= 72 & ct < 78])[1],
			  ct.48 = sort(ct[ct >= 48 & ct < 72])[1],
			  ct.24 = sort(ct[ct >= 24 & ct < 48])[1],
			  ct.0 =  sort(ct[ct > 0 & ct < 24])[1],
			  ct.max.78 = max(ct[ct < 78])[1],
			  ct.max = max(ct))
)

# Set missing values (no ct > 72) to max ct below 78 hr
mean(is.na(d$ct.72))
d$ct.72[is.na(d$ct.72)] <- d$ct.max.78[is.na(d$ct.72)]

#-------------------------------------------------------------------------------------------------
# Acidification only
# Barn acidification excluded (some unclear, but should be NL, field probably)
acid.exper <- unique(ds[ds$acid, c('inst', 'exper', 'exper.code')])
acid.exper.code <- acid.exper$exper.code
ds3 <- ds[!is.na(ds$incorp) & 
          ds$man.dm <= 15 &
          ds$app.mthd != 'pi' &
          ds$app.mthd != 'cs' &
          ds$app.mthd != 'os' &
          ds$meas.tech2 != 'chamber' &
          ds$inst != 108 & 
          ds$inst != 102 &
          ###ds$inst != 211 & # Drop SDU
          ds$exper.code %in%  acid.exper.code &
          ds$man.trt1 != 'Barn acidification'
         , ]

ds3 <- droplevels(ds3)
pmid.keep <- ds3$pmid

table(ds3$country)
table(ds3$inst)

# NTS: Do not limit duration
### Limit to 72 hours (<= 73 hr)
##d3 <- d[d$pmid %in% pmid.keep & d$ct <= 73 & d$ct >= 0, ]
d3 <- d[d$pmid %in% pmid.keep & d$ct >= 0, ]

# Look for missing values
dfsumm(d3[, c('e.int', 'app.mthd', 'man.dm', 'man.source', 'air.temp', 
              'wind.2m', 'till', 'incorp', 'crop')])

# Looks fine for these pars

table(ds3$exper, ds3$inst)
table(ds3$inst, ds3$date.start)

pmid.cal3 <- pmid.keep
write.csv(pmid.cal3, '../output/pmid_cal3.csv', row.names = FALSE)

