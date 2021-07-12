fp <- '../data/EF inputs.xlsx'

conds <- as.data.frame(read_xlsx(fp, sheet = 1, skip = 1))
incorp <- as.data.frame(read_xlsx(fp, sheet = 2, skip = 1))
crops <- as.data.frame(read_xlsx(fp, sheet = 3, skip = 1))
dates <- as.data.frame(read_xlsx(fp, sheet = 4, skip = 1))
comp <- as.data.frame(read_xlsx(fp, sheet = 5, skip = 1))
weather <- as.data.frame(read_xlsx(fp, sheet = 6, skip = 1))
