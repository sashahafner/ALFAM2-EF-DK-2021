# Plots

# Fix level names for plots
d.pred$app.mthd.nm <- factor(d.pred$app.mthd, levels = c('bc', 'bsth', 'ts', 'os', 'cs'), 
                             labels = c('Broadcast', 'Trailing hose', 'Trailing shoe', 'Open slot injection', 'Closed slot injection'))
d.pred$man.source.nm <- factor(d.pred$man.source, levels = c('cat', 'pig'), labels = c('Cattle', 'Pig'))

d.pred.168$app.mthd.nm <- factor(d.pred.168$app.mthd, levels = c('bc', 'bsth', 'ts', 'os', 'cs'), 
                              labels = c('Broadcast', 'Trailing hose', 'Trailing shoe', 'Open slot injection', 'Closed slot injection'))
d.pred.168$man.source.nm <- factor(d.pred.168$man.source, levels = c('cat', 'pig'), labels = c('Cattle', 'Pig'))

d.pred.168$par.set.nm <- factor(d.pred.168$par.set, levels = c('ALFAM1', 'EF 2008', '1', 'i', 'j', 'k'), labels = c('ALFAM(1)', 'ALFAM(1)+RR (2008)', 'ALFAM2 set 1', 'ALFAM2 set 2', 'ALFAM2 set 3 (unwght.)', 'ALFAM2 set 4 (no pH)'))

fsumm.ct2$app.mthd.nm <- factor(fsumm.ct2$app.mthd, levels = c('bc', 'bsth', 'ts', 'os', 'cs'), 
                             labels = c('Broadcast', 'Trailing hose', 'Trailing shoe', 'Open slot injection', 'Closed slot injection'))
fsumm.ct2$man.source.nm <- factor(fsumm.ct2$man.source, levels = c('cat', 'pig'), labels = c('Cattle', 'Pig'))

ds2$app.mthd.nm <- factor(ds2$app.mthd, levels = c('bc', 'bsth', 'ts', 'os', 'cs'), 
                          labels = c('Broadcast', 'Trailing hose', 'Trailing shoe', 'Open slot injection', 'Closed slot injection'))
ds2$man.source.nm <- factor(ds2$man.source, levels = c('cat', 'pig'), labels = c('Cattle', 'Pig'))

# d2 final flux for plots
ds2b <- as.data.frame(summarise(group_by(d2, pmid), j.final = j.NH3[ct == max(ct)]))
ds2 <- merge(ds2, ds2b, by = 'pmid')
# Final average flux as percentage of cumulative emission per day
ds2$j.final.rp <- 100 * 24 * ds2$j.final / ds2$e.final

# Model error
dd <- subset(d.pred.168, par.set %in% c('ALFAM1', 'i', '1') & app.mthd != 'ts')
ggplot(dd, aes(country, 100 * error.er, fill = par.set.nm)) + 
  geom_hline(yintercept = 0, lty = 2, colour = 'gray45') +
  geom_boxplot() +
  facet_wrap(~ app.mthd.nm, scale = 'free', ncol = 2) +
  labs(x = 'Country', y = 'Model error in 168 h cum. emission (% applied TAN)',
       fill = 'Model') +
  theme(legend.position = c(0.7, 0.3))
ggsave('../plots/error_box0.png', height = 6, width = 6)

dd <- subset(d.pred.168, par.set %in% c('1', 'i', 'j'))
ggplot(dd, aes(par.set.nm, 100 * error.er, fill = country)) + 
  geom_hline(yintercept = 0, lty = 2, colour = 'gray45') +
  geom_boxplot() +
  facet_wrap(~ app.mthd.nm, scale = 'free') +
  labs(x = 'Model/parameters', y = 'Model error in 168 h cum. emission (% applied TAN)',
       fill = 'Country')
ggsave('../plots/error_box1.png', height = 8, width = 7)

dd <- subset(d.pred.168, par.set %in% c('1', 'i', 'ALFAM1'))
ggplot(dd, aes(country, 100 * error.er, fill = par.set.nm)) + 
  geom_hline(yintercept = 0, lty = 2, colour = 'gray45') +
  geom_boxplot() +
  facet_wrap(~ app.mthd.nm, scale = 'free') +
  theme(legend.position = 'top') +
  labs(x = 'Country', y = 'Model error in 168 h cum. emission (% applied TAN)',
       fill = 'Model and parameter set:')
ggsave('../plots/error_box2.png', height = 6, width = 7)

dd <- subset(d.pred.168, par.set %in% c('i', 'ALFAM1', 'EF 2008'))
ggplot(dd, aes(country, 100 * error.er, fill = par.set.nm)) + 
  geom_hline(yintercept = 0, lty = 2, colour = 'gray45') +
  geom_boxplot() +
  facet_wrap(~ app.mthd.nm, scale = 'free') +
  theme(legend.position = 'top') +
  labs(x = 'Country', y = 'Model error in 168 h cum. emission (% applied TAN)',
       fill = 'Model and parameter set:')
ggsave('../plots/error_box6.png', height = 6, width = 7)

dd <- subset(d.pred.168, par.set %in% c('1', 'i', 'j', 'k', 'ALFAM1'))
ggplot(dd, aes(country, 100 * error.er, fill = par.set.nm)) + 
  geom_hline(yintercept = 0, lty = 2, colour = 'gray45') +
  geom_boxplot() +
  facet_wrap(~ app.mthd.nm, scale = 'free') +
  theme(legend.position = 'top') +
  labs(x = 'Country', y = 'Model error in 168 h cum. emission (% applied TAN)',
       fill = '')
ggsave('../plots/error_box3.png', height = 6, width = 7)

dd <- subset(d.pred.168, par.set %in% c('i', 'ALFAM1'))
ggplot(dd, aes(country, 100 * error.er, fill = par.set.nm)) + 
  geom_hline(yintercept = 0, lty = 2, colour = 'gray45') +
  geom_boxplot() +
  facet_wrap(~ app.mthd.nm, scale = 'free') +
  theme(legend.position = 'top') +
  labs(x = 'Country', y = 'Model error in 168 h cum. emission (% applied TAN)',
       fill = 'Model and parameter set:')
ggsave('../plots/error_box4.png', height = 6, width = 7)


ggplot(ds2, aes(country, ct.max, fill = app.mthd.nm)) + 
  geom_boxplot() +
  labs(x = 'Country', y = 'Trial duration (h)',
       fill = 'Application method')
ggsave('../plots/ct_box.png', height = 8, width = 7)

ggplot(ds2, aes(country, j.final.rp, fill = app.mthd.nm)) + 
  geom_boxplot() +
  ylim(0, 20) +
  labs(x = 'Country', y = 'Final flux (% cum./d)',
       fill = 'Application method')
ggsave('../plots/final_flux_box.png', height = 6, width = 7)

dd <- subset(fsumm.ct2, par.set == 'i') 
ddd <- subset(d.pred, par.set == 'i') 
ggplot(dd, aes(ct.mean, MBE, colour = factor(country))) +
       geom_point(data = ddd, aes(ct, error.er), alpha = 0.2) +
       geom_point(shape = 21, size = 3, colour = 'black', aes(bg = country)) +
       geom_smooth(method = lm, se = FALSE) +
       facet_grid(man.source.nm ~ app.mthd.nm) +
       labs(x = 'Time (h)', y = 'Model error (frac. applied TAN)', colour = 'Country', bg = 'Country') +
       theme(legend.position = 'top')
ggsave('../plots/MBE.png', height = 6, width = 7)

dd <- subset(fsumm.ct2, par.set == 'i') 
ddd <- subset(d.pred, par.set == 'i') 
ggplot(dd, aes(ct.mean, er.mean, colour = factor(country))) +
       geom_point(data = ddd, aes(ct, er), alpha = 0.2) +
       geom_line(aes(group = inst)) +
       geom_point(shape = 21, size = 3, colour = 'black', aes(bg = country)) +
       facet_grid(man.source.nm ~ app.mthd.nm) +
       labs(x = 'Time (h)', y = 'Cumulative emission (frac. applied TAN)', colour = 'Country', bg = 'Country') +
       theme(legend.position = 'top')
ggsave('../plots/mean_er.png', height = 6, width = 7)

dd <- subset(d.pred.168, par.set == 'i')
ggplot(dd, aes(er.pred, er, colour = country)) +
  geom_abline(intercept = 0, slope = 1, col = 'gray45') +
  geom_point(bg = 'gray45', alpha = 0.3) +
  geom_line(stat = 'smooth', method = 'lm', se = FALSE, alpha = 0.6) +
  facet_grid(man.source.nm ~ app.mthd.nm) +
  labs(x = 'Calculated', 
       y = 'Measured',
       colour = 'Country') +
  theme(legend.position = 'top') +
  guides(colour = guide_legend(nrow = 1))
ggsave('../plots/e168_comp.png', height = 4.5, width = 7)

dd <- subset(d.pred.168, par.set == 'i')
ggplot(dd, aes(er.pred, er, colour = man.source.nm)) +
  geom_abline(intercept = 0, slope = 1, col = 'gray45') +
  geom_point(bg = 'gray45') +
  facet_wrap(~ app.mthd.nm, scale = 'free') +
  labs(x = 'Calculated', 
       y = 'Measured',
       colour = 'Type') +
  theme(legend.position = 'top') +
  guides(colour = guide_legend(nrow = 1))
ggsave('../plots/e168_comp_free.png', height = 4.5, width = 7)
