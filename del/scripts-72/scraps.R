




pdf('../plots/long_error.pdf', height = 11, width = 8.5)
  par(mfrow = c(6, 4), mar = c(3, 3, 1, 0))
  for (i in unique(dlong$pmid)) {

    dd <- subset(dlong, pmid == i)
    plot(c(er.pred.d, e.rel) ~ c(ct, ct), data = dd, type = 'n', 
         col = 'gray45', xlab = 'Time (h)', ylab = 'Rel. emission', 
         main = i)
    points(e.rel ~ ct, data = dd, col = 'gray45')
    lines(er.pred.d ~ ct, data = dd, col = 'gray45')

  }
dev.off()



ggplot(d1, aes(ct, e.rel)) +
  geom_point(pch = 1, colour = 'gray45') +
  geom_line(aes(ct, er.pred1), colour = 'gray45') +
  geom_line(aes(ct, er.pred0), colour = 'black') +
  geom_line(aes(ct, er.pred.d), colour = 'blue') +
  facet_wrap(~ pmid, scale = 'free', ncol = 12)
ggsave('../plots/emis.pdf', height = 8, width = 16)

x <- subset(d1, is.na(er.pred1))
head(x)

dd <- subset(d1, abs(err0) < 0.1)
ggplot(dd, aes(ct, err1)) +
  geom_point(colour = 'gray45') +
  geom_smooth(se = FALSE, colour = 'red') +
  geom_point(aes(ct, err0), colour = 'black', pch = 1) +
  geom_smooth(aes(ct, err0), se = FALSE, colour = 'blue')
ggsave('../plots/error.pdf', height = 4, width = 4)

dlong <- subset(d0, pmid %in% pmid.long)
pdf('../plots/emis_def_200.pdf', height = 11, width = 8.5)
  par(mfrow = c(6, 4), mar = c(3, 3, 1, 0))
  for (i in unique(dlong$pmid)) {

    dd <- subset(dlong, pmid == i)
    plot(c(er.pred.d, e.rel) ~ c(ct, ct), data = dd, type = 'n', 
         col = 'gray45', xlab = 'Time (h)', ylab = 'Rel. emission', 
         main = i)
    points(e.rel ~ ct, data = dd, col = 'gray45')
    lines(er.pred.d ~ ct, data = dd, col = 'gray45')

  }
dev.off()


