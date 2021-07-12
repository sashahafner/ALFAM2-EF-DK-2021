acid.pars
acid.pars$man.source <- factor(acid.pars$man.source)
acid.pars$man.source <- factor(acid.pars$man.source, levels = c('cat', 'pig', 'other'), labels = c('Cattle', 'Pig', 'Other'))
acid.pars$man.source[is.na(acid.pars$man.source)] <- 'Other'

ggplot(acid.pars, aes(man.source, man.ph.r1, colour = country, shape = country)) +
  geom_jitter(height = 0, width = 0.1) +
  geom_hline(yintercept = 0.6, col = 'gray45', lty = 2) +
  theme(legend.position = 'top') +
  labs(x = 'Manure type', y = 'Parameter value', colour = 'Country', shape = 'Country')
ggsave('../plots/acid_pars.png', height = 3, width = 4)

ggplot(d3, aes(ct, e.rel, colour = man.ph, group = pmid)) +
  facet_wrap(~ uexper) +
  geom_line() +
  geom_line(aes(ct, er.pred), colour = 'gray55')
ggsave('../plots/curves.png', height = 6, width = 7)


ggplot(d3, aes(e.rel, er.pred, colour = man.ph, group = pmid)) +
  facet_wrap(~ uexper) +
  geom_abline(intercept = 0, slope = 1, colour = 'gray65') +
  geom_line() +
ggsave('../plots/bivar.png', height = 6, width = 7)

ggplot(acid.pars, aes(int.r1 + int.r3, fill = uexper)) +
  geom_histogram() +
  facet_wrap(~ country)

ggplot(acid.pars, aes(int.r1, int.r3, colour = man.source)) +
  geom_point() +
  facet_wrap(~ country)


