
dd <- subset(ds, app.method == 'bsth' & man.source %in% c('cat', 'pig'))
dd$man.source <- factor(dd$man.source, labels = c('Cattle', 'Pig'))
dd$inst <- factor(dd$inst)
ggplot(dd, aes(man.ph, e.rel.24, colour = inst, shape = acid)) +
  geom_point() +
  facet_wrap(~ man.source, nrow = 2) +
  geom_smooth(method = lm, se = FALSE) +
  labs(x = 'Manure pH', y = '24 hour relative emission (frac. applied TAN)', colour = 'Institution', shape = 'Acidified?') +
  scale_shape_manual(values = c(1, 19)) +
  theme(legend.position = 'top') +
  guides(shape = FALSE) +
  ylim(0, 0.41)
ggsave('../plots/pH_resp.png', height = 5, width = 6)

