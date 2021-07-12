# Focus on incorporation experiments

d.pred.168.incorp <- subset(d.pred.168, pmid %in% pmid.cal4)
d.pred.incorp <- subset(d.pred, pmid %in% pmid.cal4 & man.dm <= 15 & inst != 107)

