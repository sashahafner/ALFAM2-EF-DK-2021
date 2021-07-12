
# Finally, summaries
dsl <- as.data.frame(summarise(group_by(dl, loc, variable), n = length(value), val.loc = mean(value)))
dsl <- na.omit(dsl)
ds <- as.data.frame(summarise(group_by(dsl, variable), 
                              n = sum(!is.na(val.loc)), 
                              mn = mean(val.loc), md = median(val.loc), s = sd(val.loc) ))

ds <- rounddf(ds, 1)

write.csv(dsl, '../output/digestate_summ_loc.csv', row.names = FALSE)
write.csv(ds, '../output/digestate_summ.csv', row.names = FALSE)
