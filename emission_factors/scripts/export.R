# Export results

# Complete EF data frame
write.csv(dat, '../output/EF.csv', row.names = FALSE)

# EF results for report Appendix 1
efd <- dat[, c('id', 'decade', 'app.timing', 'app.mthd', 'crop', 'crop.hght', 'incorp.descrip', 'man.source', 'man.dm', 'man.ph', 'man.trt', 'air.temp', 'wind.2m', 'rain.rate', 'EFp')]
efd <- rounddf(efd, 3, func = signif)
efd <- efd[order(-efd$decade, efd$app.timing, efd$app.mthd, efd$man.source, dat$incorp, -dat$t.incorp), ]

# Split into untreated, field acidified, barn acidified
efd <- rename(efd, ID = id, Decade = decade, `Application period` = app.timing,
              `Application method` = app.mthd, Crop = crop, `Crop height (cm)` = crop.hght, 
              `Incorporation` = incorp.descrip, `Manure source` = man.source, 
              `Manure DM (%)` = man.dm, `Manure pH` = man.ph, 
              `Manure treatment` = man.trt, `Air temperature (deg. C)` = air.temp,
              `Wind speed (m/s)` = wind.2m, `Rainfall rate (mm/h)` = rain.rate, 
              `Emission factor (% of applied TAN)` = EFp)
efdu <- subset(efd, `Manure treatment` == 'None')
efdb <- subset(efd, `Manure treatment` == 'Barn acidified')
efdf <- subset(efd, `Manure treatment` == 'Field acidified')
write.csv(efd, '../output/Appendix_01.csv', row.names = FALSE)
write.csv(efdu, '../output/Appendix_01_untreated.csv', row.names = FALSE)
write.csv(efdb, '../output/Appendix_01_barn.csv', row.names = FALSE)
write.csv(efdf, '../output/Appendix_01_field.csv', row.names = FALSE)

# EF tables
t5 <- subset(dat, crop %in% c('None') & app.mthd %in% c('Closed slot injection') &
             man.source %in% c('Cattle', 'Pig') &
              decade == 2010 &  man.trt == 'None' & app.timing %in% c('March', 'April', 'Summer, before winter rapeseed'))
t5 <- t5[, c('man.source', 'app.timing', 'EF.2008', 'EFp')]
write.csv(t5, '../output/table5.csv', row.names = FALSE)

t6 <- subset(dat, crop != 'None' & app.mthd %in% c('Open slot injection') &
             man.source %in% c('Cattle', 'Pig') &
              decade %in% c(2000, 2010) &  man.trt == 'None' & app.timing %in% c('March', 'April', 'Summer, grass', 'Autumn'))
t6 <- t6[, c('decade', 'man.source', 'app.timing', 'EF.2008', 'EFp')]
write.csv(t6, '../output/table6.csv', row.names = FALSE)

t7 <- subset(dat, app.mthd %in% c('Trailing hose') & man.source %in% c('Cattle', 'Pig') & incorp.timing %in% c('None', '4.0') & 
              decade %in% c(2000, 2010) &  man.trt == 'None' & app.timing %in% c('March', 'April', 'May', 'Summer', 'Autumn'))
t7 <- t7[, c('decade', 'man.source', 'app.timing', 'incorp.descrip', 'EF.2008', 'EFp')]
t7 <- t7[order(t7$decade, -as.integer(t7$man.source), t7$incorp.descrip, t7$app.timing), ]
write.csv(t7, '../output/table7.csv', row.names = FALSE)


t8 <- subset(dat, ((crop %in% c('Grass') & app.mthd %in% c('Trailing hose', 'Open slot injection')) | (app.mthd == 'Closed slot injection')) &
              decade == 2010 &  man.trt == 'None' & app.timing %in% c('Summer', 'Autumn', 'Summer, grass', 'March', 'April'))
t8 <- dcast(t8, app.timing ~ app.mthd + man.source, value.var = 'EFp')
write.csv(t8, '../output/table8.csv', row.names = FALSE)

t9 <- subset(dat, crop != 'None' & 
             decade == 2010 &
             app.mthd == 'Trailing hose' &
             man.source %in% c('Cattle', 'Pig') &
             incorp == 'None')
t9 <- dcast(t9, app.timing + crop + crop.hght ~ man.source + man.trt.nm, value.var = 'EFp')
write.csv(t9, '../output/table9.csv', row.names = FALSE)

# Comparisons
# Manure types and digestion
dd <- subset(dat, man.trt == 'None' & decade == 2010)
comp.dig <- dcast(dd, decade + app.timing + app.mthd + crop.status + incorp + incorp.timing ~ man.source, value.var = 'EFp')
comp.dig$rrc <- signif(100* (comp.dig$Digestate / comp.dig$Cattle - 1), 3)
comp.dig$rrp <- signif(100* (comp.dig$Digestate / comp.dig$Pig - 1), 3)
write.csv(comp.dig, '../output/dig_comp.csv', row.names = FALSE)

# Acidification
dd <- subset(dat, decade == 2010)
comp.acid <- dcast(dd, decade + app.timing + app.mthd + crop.status + incorp + incorp.timing + man.source ~ man.trt, value.var = 'EFp')
comp.acid$rr6.4 <- signif(100* (1 - comp.acid$`Field acidified` / comp.acid$None), 3)
comp.acid$rr6.0 <- signif(100* (1 - comp.acid$`Barn acidified` / comp.acid$None), 3)
write.csv(comp.acid, '../output/acid_comp.csv', row.names = FALSE)
write.csv(c(mean(comp.acid$rr6.4, na.rm = TRUE), mean(comp.acid$rr6.0, na.rm = TRUE)), '../output/acid_effect_mean.csv')

# Incoporation
# Difficult to get observations to compare, note that crop has to be dropped here because there is not both incorp/no incorp for -/+ crop
dd <- subset(dat, decade == 2010 & app.mthd == 'Trailing hose' & man.trt == 'None')
dd <- dd[!duplicated(dd[, c('incorp.timing', 'EFp')]), ]
comp.incorp <- dcast(dd, decade + app.timing + app.mthd + man.source + man.trt ~ incorp + incorp.timing, value.var = 'EFp')
comp.incorp$rr4d <- signif(100* (1 - comp.incorp$Deep_4.0 / comp.incorp$None_None), 3)
comp.incorp$rr24d <- signif(100* (1 - comp.incorp$Deep_24.0 / comp.incorp$None_None), 3)
comp.incorp$rr4s <- signif(100* (1 - comp.incorp$Shallow_4.0 / comp.incorp$None_None), 3)
comp.incorp$rr24s <- signif(100* (1 - comp.incorp$Shallow_24.0 / comp.incorp$None_None), 3)
write.csv(comp.incorp, '../output/incorp_comp.csv', row.names = FALSE)

# Comparison to select 2008 EFs based on extraction by Rikke
dd <- subset(dat, !is.na(EF.2008) & decade %in% c('2000', '2010'))
dd <- dd[, c('id', 'decade', 'app.timing.d', 'crop.status', 'app.mthd.d', 'incorp.timing', 'man.descrip.d', 'man.source.d', 'EF.2008', 'EFp', 'EF.2008.source')]
names(dd)[names(dd) == 'EFp'] <- 'EF.current'
write.csv(dd, '../output/2008_comp.csv', row.names = FALSE)






