# Create plots

ggplot(datw, aes(EF72, EF168, colour = incorp.nm, shape = man.trt.nm)) +
  geom_point() +
  facet_grid(app.mthd ~ man.source) +
  geom_abline(intercept = 0, slope = 1, col = 'gray45') +
  geom_abline(intercept = 0, slope = 1.25, col = 'gray45', lty = 2) +
  geom_abline(intercept = 0, slope = 1.5, col = 'gray45', lty = 2) +
  geom_abline(intercept = 0, slope = 2, col = 'gray45', lty = 2)
ggsave('../plots/EF_comp.pdf', height = 8.5, width = 11)

ggplot(datw, aes(EF168, EF240, colour = incorp.nm, shape = man.trt.nm)) +
  geom_point() +
  facet_grid(app.mthd ~ man.source) +
  geom_abline(intercept = 0, slope = 1, col = 'gray45') +
  geom_abline(intercept = 0, slope = 1.25, col = 'gray45', lty = 2) +
  geom_abline(intercept = 0, slope = 1.5, col = 'gray45', lty = 2) +
  geom_abline(intercept = 0, slope = 2, col = 'gray45', lty = 2)
ggsave('../plots/EF_comp_long.pdf', height = 8.5, width = 11)

# Add some 0,0
t0 <- unique(dat[, c('id', 'incorp.nm', 'man.trt.nm', 'app.mthd', 'man.source')])
t0$ct <- 0
t0$EF <- 0
dd <- rbindf(t0, dat)
ggplot(dd, aes(ct, EF, colour = incorp.nm, shape = man.trt.nm, group = id)) +
  geom_line(alpha = 0.3) +
  labs(x = 'Time (h)', y = 'Cumulative emission (frac. applied TAN)') +
  facet_grid(app.mthd ~ man.source)
ggsave('../plots/emis_curves.pdf', height = 8.5, width = 11)
