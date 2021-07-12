# Export results

dat168 <- subset(dat, ct == 168)

# Complete EF data frame
write.csv(dat168, '../output/EF.csv', row.names = FALSE)

# EF results for report Appendix 1
efd <- dat168[, c('id', 'decade', 'app.timing', 'app.mthd', 'crop', 'crop.hght', 'incorp.timing', 'man.source', 'man.trt', 'air.temp', 'wind.2m', 'EFp')]
efd <- rounddf(efd, 3, func = signif)
efd <- efd[order(efd$id), ]
efd <- rename(efd, ID = id, Decade = decade, `Application period` = app.timing,
              `Application method` = app.mthd, Crop = crop, `Crop height (cm)` = crop.hght, 
              `Incorporation time (h)` = incorp.timing, `Manure source` = man.source, 
              `Manure treatment` = man.trt, `Air temperature (deg. C)` = air.temp,
              `Wind speed (m/s)` = wind.2m, `Emission factor (% of applied TAN)` = EFp)
write.csv(efd, '../output/Appendix1.csv', row.names = FALSE)

# EF tables
t8 <- subset(dat168, crop == 'None' & 
             decade == 2010 &
             ((app.mthd == 'Trailing hose' & t.incorp == 4) | app.mthd == 'Open slot injection' | (app.mthd == 'Trailing hose' & crop == 'Grass')) &
             man.trt == 'None')

write.csv(t8, '../output/table8.csv', row.names = FALSE)

t9 <- subset(dat168, crop != 'None' & 
             decade == 2010 &
             app.mthd == 'Trailing hose' &
             man.source %in% c('Cattle', 'Pig') &
             incorp == 'None')

write.csv(t9, '../output/table9.csv', row.names = FALSE)

# Comparisons
# Manure types and digestion
dd <- subset(dat168, man.trt == 'None' & decade == 2010)
comp.dig <- dcast(dd, decade + app.timing + app.mthd + crop.status + incorp + incorp.timing ~ man.source, value.var = 'EFp')
comp.dig$rrc <- signif(100* (comp.dig$Digestate / comp.dig$Cattle - 1), 3)
comp.dig$rrp <- signif(100* (comp.dig$Digestate / comp.dig$Pig - 1), 3)
write.csv(comp.dig, '../output/dig_comp.csv', row.names = FALSE)

# Acidification
dd <- subset(dat168, decade == 2010)
comp.acid <- dcast(dd, decade + app.timing + app.mthd + crop.status + incorp + incorp.timing + man.source ~ man.trt, value.var = 'EFp')
comp.acid$rr6.4 <- signif(100* (1 - comp.acid$`Field acidified` / comp.acid$None), 3)
comp.acid$rr6.0 <- signif(100* (1 - comp.acid$`Barn acidified` / comp.acid$None), 3)
write.csv(comp.acid, '../output/acid_comp.csv', row.names = FALSE)


