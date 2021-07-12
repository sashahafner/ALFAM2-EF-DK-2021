# Plots

# Fix level names for plots
d.pred.168$app.mthd.nm <- factor(d.pred.168$app.mthd, levels = c('bc', 'bsth', 'ts', 'os', 'cs'), 
                              labels = c('Broadcast', 'Trailing hose', 'Trailing shoe', 'Open slot \ninjection', 'Closed slot \ninjection'))
d.pred.168$man.source.nm <- factor(d.pred.168$man.source, levels = c('cat', 'pig'), labels = c('Cattle', 'Pig'))

d.pred.168$digestate <- grepl('[Aa]naerobic digestion', paste(d.pred.168$man.trt1, d.pred.168$man.trt2))

# Model error
ggplot(d.pred.168, aes(country, 100 * error.er, fill = set)) + 
  geom_hline(yintercept = 0, lty = 2, colour = 'gray45') +
  geom_boxplot() +
  facet_wrap(~ app.mthd.nm, scale = 'fixed', ncol = 2) +
  theme(legend.position = 'top') +
  labs(x = 'Country', y = 'Model error in 168 h cum. emission (% applied TAN)',
       fill = '') 
ggsave('../plots/error_box_set.png', height = 6, width = 6)

ggplot(d.pred.168, aes(er.pred, er, colour = country, shape = set)) +
  geom_abline(intercept = 0, slope = 1, col = 'gray45') +
  geom_point(bg = 'gray45') +
  #geom_line(stat = 'smooth', method = 'lm', se = FALSE, alpha = 0.6) +
  scale_shape_manual(values = c(1, 2, 20)) +
  facet_grid(man.source.nm ~ app.mthd.nm) +
  labs(x = 'Calculated', 
       y = 'Measured',
       colour = '', shape = '') +
  theme(legend.position = 'top') +
  xlim(0, 0.9) +
  guides(colour = guide_legend(nrow = 1))
ggsave('../plots/e168_comp_set.png', height = 4.5, width = 7)

dd <- subset(d.pred.168, app.mthd %in% c('bc', 'bsth'))
ggplot(dd, aes(er.pred, er, colour = digestate, shape = digestate)) +
  geom_abline(intercept = 0, slope = 1, col = 'gray45') +
  geom_point(bg = 'black', alpha = 0.7) +
  scale_shape_manual(values = c(1, 19)) +
  facet_grid(man.source.nm ~ app.mthd.nm) +
  labs(x = 'Calculated', 
       y = 'Measured',
       colour = 'Digestate:', shape = 'Digestate:') +
  theme(legend.position = 'top') +
  xlim(0, 0.9) +
  guides(colour = guide_legend(nrow = 1))
ggsave('../plots/e168_comp_dig.png', height = 4.5, width = 4)

ggplot(d.pred.168.incorp, aes(er.pred, er, colour = country, shape = set)) +
  geom_abline(intercept = 0, slope = 1, col = 'gray45') +
  geom_point(bg = 'gray45') +
  #geom_line(stat = 'smooth', method = 'lm', se = FALSE, alpha = 0.6) +
  scale_shape_manual(values = c(1, 20)) +
  facet_wrap(~ app.mthd) +
  labs(x = 'Calculated', 
       y = 'Measured',
       colour = '', shape = '') +
  theme(legend.position = 'top') +
  xlim(0, 0.9) +
  guides(colour = guide_legend(nrow = 1))
ggsave('../plots/e168incorp_comp_set.png', height = 4.5, width = 7)

ggplot(d.pred.incorp, aes(ct, er, colour = incorp, group = pmid)) +
  geom_vline(aes(xintercept = time.incorp, colour = incorp), lty = 3) +
  geom_line(aes(ct, er.pred), lty = 2) +
  geom_line() +
  facet_wrap(~ interaction(country, inst, exper), scale = 'free') +
  labs(x = 'Time (h)', 
       y = 'Emission (frac. applied TAN)',
       colour = 'Incorporation') +
  theme(legend.position = 'top') +
  guides(colour = guide_legend(nrow = 1))
ggsave('../plots/emis_incorp.png', height = 7, width = 12)
