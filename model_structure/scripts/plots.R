# Plots

# Emission curve comparison
set.seed(123)
x <- sample(unique(d1$pmid), 6)
dd <- subset(d1, pmid %in% x)
ggplot(dd, aes(ct, e.rel)) +
  geom_point(pch = 1, colour = 'gray45') +
  geom_line(aes(ct, er.pred1), colour = 'red') +
  geom_line(aes(ct, er.pred0), colour = 'blue') +
  labs(x = 'Time (hr)', y = 'Emission (frac. applied TAN)') +
  facet_wrap(~ pmid, scale = 'free')
ggsave('../plots/emis_r3.png', height = 4, width = 6)

# Error over time
dd <- subset(d1, abs(err0) < 0.1)
ggplot(dd, aes(ct, err1)) +
  geom_point(colour = 'red') +
  geom_smooth(se = FALSE, colour = 'red') +
  geom_point(aes(ct, err0), colour = 'blue', pch = 1) +
  geom_smooth(aes(ct, err0), se = FALSE, colour = 'blue')
ggsave('../plots/error_t_r3.png', height = 4, width = 4)

# Compare final error
ggplot(dl, aes(variable, value, fill = variable)) +
  geom_boxplot() +
  labs(x = '', y = 'Latest model error (frac. applied TAN)') +
  theme(legend.position = 'none')
ggsave('../plots/error_r3.png', height = 4, width = 4)
