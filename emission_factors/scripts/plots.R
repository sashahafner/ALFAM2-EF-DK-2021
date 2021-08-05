# Create plots

d <- droplevels(subset(dat, man.trt == 'None' & 
                       (incorp == 'None' | t.incorp ==  4) & app.mthd != 'Broadcast' &
                       decade == 2010))

d2 <- droplevels(subset(dat, man.trt == 'None' & 
                       (incorp == 'None' | t.incorp ==  4) & 
                       decade == 2010))

dd <- droplevels(subset(dat, incorp %in% c('None', 'Shallow', 'Deep') & man.trt == 'None' & 
                       (incorp == 'None' | t.incorp ==  4) &
                       decade == 2010))

ggplot(dd, aes(app.timing, EFp, shape = incorp.nm, colour = factor(app.mthd))) +
  geom_point() +
  facet_wrap(~ man.source) +
  labs(x = 'Application period', y = 'Emission factor (% applied TAN)',
       shape = '', colour = 'Application method\n(color)') + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
        legend.position = 'top')
ggsave('../plots/emis_factors_b.png', height = 5, width = 6.5)

ggplot(d2, aes(app.timing, EFp, shape = incorp.nm, colour = factor(app.mthd))) +
  geom_point() +
  facet_wrap(~ man.source) +
  ylim(0, max(d2$EFp)) +
  labs(x = 'Application period', y = 'Emission factor (% applied TAN)',
       shape = 'Slurry type (shape)', colour = 'Application method\n(color)') + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
        legend.position = 'right')
ggsave('../plots/emis_factors_wbc.png', height = 5, width = 7)

ggplot(d, aes(app.timing, EFp, shape = incorp.nm, colour = factor(app.mthd))) +
  geom_point() +
  facet_wrap(~ man.source) +
  ylim(0, max(d$EFp)) +
  labs(x = 'Application period', y = 'Emission factor (% applied TAN)',
       shape = 'Incorporation (shape)', colour = 'Application method\n(color)') + 
  scale_shape_manual(values = c(19, 24, 1)) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
        legend.position = 'right')
ggsave('../plots/emis_factors.png', height = 4.8, width = 6.9)

ggplot(dat, aes(app.timing, EFp, shape = man.source, colour = factor(app.mthd))) +
  geom_jitter(height = 0) +
  facet_grid(man.trt.nm ~ incorp.nm) +
  labs(x = 'Application period', y = 'Emission factor (% applied TAN)',
       #shape = 'Slurry type (shape)', colour = 'Application method\n(color)') + 
       shape = '', colour = '') + 
  scale_shape_manual(values = c(1, 3, 17)) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
        legend.position = 'top')
ggsave('../plots/emis_factors_all.png', height = 8.7, width = 7.5)

# Change over time
d <- dat
d$group <- interaction(d$man.trt, d$man.source, d$app.mthd, d$crop.status, d$app.timing, d$incorp.timing, d$incorp)
d$decadej <- d$decade + runif(nrow(d), min = -2, max = 2)

ggplot(d, aes(decadej, EF.rel, shape = app.mthd, colour = man.source,
              group = interaction(man.trt, man.source, app.mthd, crop.status, app.timing, incorp.timing, incorp))) +
  geom_point(size = 2) +
  geom_path(alpha = 0.3) +
  labs(x = 'Decade', y = 'Change in emission factor (%)', shape = 'Application method', colour = 'Manure type')
ggsave('../plots/ef_trends.png', height = 4, width = 6.5)

# Digestion effect
ggplot(comp.dig, aes(Cattle, rrc, colour = app.mthd, shape = factor(incorp))) +
  geom_point() +
  labs(x = 'Cattle EF (% app. TAN)', y = 'Rel. diff. digestate vs. cattle (% of EF)', colour = 'Application method',
       shape = 'Incorporation')
ggsave('../plots/dig_comp2.png', height = 4, width = 5.5)

ggplot(comp.dig, aes(Cattle, Digestate, colour = app.mthd, shape = factor(incorp))) +
  geom_point() +
  geom_abline(intercept = 0, slope = 1, colour = 'gray65') +
  xlim(0, 40) + ylim(0, 40) +
  labs(x = 'Cattle EF (% app. TAN)', y = 'Digestate EF (% app. TAN)', colour = 'Application method',
       shape = 'Incorporation')
ggsave('../plots/dig_comp1.png', height = 4, width = 5.5)

# Acidification comparison
dd <- na.omit(subset(comp.acid, incorp == 'None'))
dl <- melt(dd, id.vars = c('decade', 'app.timing', 'app.mthd', 'man.source'), measure.vars = c('None', 'Barn acidified', 'Field acidified'), variable.name = 'treatment', value.name = 'EFp')
head(dl)

ggplot(dl, aes(app.timing, EFp, colour = treatment, shape = factor(app.mthd))) +
  geom_point() +
  facet_wrap(~ man.source) +
  ylim(0, max(dl$EFp)) +
  labs(x = 'Application period', y = 'Emission factor (% applied TAN)',
       shape = 'Shape', colour = '') + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
        legend.position = 'top')
ggsave('../plots/acid_ef.png', height = 5, width = 6.5)
