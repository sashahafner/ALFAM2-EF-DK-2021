

x <- table(ds4$country, interaction(ds4$app.mthd, ds4$incorp))
write.csv(x, '../output/counts_ds4_incorp.csv')


x <- table(ds2$country, interaction(ds2$app.mthd, ds2$incorp))
write.csv(x, '../output/counts_ds2_main.csv')
