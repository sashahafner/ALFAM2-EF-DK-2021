# 168 hr subset
d.pred.168 <- subset(d.pred, ct == ct.168)

# Fix level names for plots
d.pred.168$app.mthd.nm <- factor(d.pred.168$app.mthd, levels = c('bc', 'bsth', 'ts', 'os', 'cs'), 
                              labels = c('Broadcast', 'Trailing hose', 'Trailing shoe', 'Open slot \ninjection', 'Closed slot \ninjection'))
d.pred.168$man.source[!d.pred.168$man.source %in% c('cat', 'pig')] <- 'other'
d.pred.168$man.source.nm <- factor(d.pred.168$man.source, levels = c('cat', 'pig', 'other'), labels = c('Cattle', 'Pig', 'Other'))

d.pred.168$digestate <- grepl('[Aa]naerobic digestion', paste(d.pred.168$man.trt1, d.pred.168$man.trt2))

# Focus on incorporation experiments
d.pred.168.incorp <- subset(d.pred.168, pmid %in% pmid.cal4)
d.pred.incorp <- subset(d.pred, pmid %in% pmid.cal4 & man.dm <= 15 & inst != 107)

# Other subsets
d.pred2.168 <- subset(d.pred.168, ct == ct.168 & pmid %in% pmid.cal2)
d.pred3.168 <- subset(d.pred.168, ct == ct.168 & pmid %in% pmid.cal3)
dim(d.pred.168)
d.pred.168 <- subset(d.pred.168, !is.na(er.pred) & !is.na(er))
dim(d.pred.168)


