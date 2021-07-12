

# Main
d2 <- subset(d, pmid %in% pmid.cal2)
d2cs <- subset(d, pmid %in% pmid.cal2cs)

# Acidification (although additional data used for pH pars)
d3 <- subset(d, pmid %in% pmid.cal3)

# Incorporation
d4 <- subset(d, pmid %in% pmid.cal4)

d234 <- subset(d, pmid %in% unique(c(pmid.cal2, pmid.cal2cs, pmid.cal3, pmid.cal4)))
d234$set <- ifelse(d234$incorp != 'none', 'Incorporation', ifelse(d234$acid, 'Acidification', 'Neither'))
