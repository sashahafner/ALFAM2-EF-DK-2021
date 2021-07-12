
# Morning, night
ggplot(datm) +
  geom_line(data = dath, aes(ct, er, group = sim), colour = 'gray45') +
  geom_line(data = dathn, aes(ct, er, group = sim), colour = 'black', lty = 3) +
  facet_wrap(~ yr) +
  labs(x = 'Time (h)', y = 'Relative emission (frac. of applied TAN)')
ggsave('../plots/sim_morn_night.png', height = 8, width = 6)

# Rain, none
ggplot(datm) +
  geom_line(data = dath, aes(ct, er, group = sim), colour = 'skyblue') +
  geom_line(data = dathnr, aes(ct, er, group = sim), colour = 'gray45', lty = 3) +
  facet_wrap(~ yr) +
  labs(x = 'Time (h)', y = 'Relative emission (frac. of applied TAN)')
ggsave('../plots/sim_rain.png', height = 8, width = 6)

# Mean of 3 hourly vs. mean and mean w/ ff
ggplot(datm) +
  geom_line(data = dathnm, aes(ct, er), colour = 'black', lwd = 1.5) +
  geom_line(data = dathm, aes(ct, er), colour = 'gray45', lwd = 1.5) +
  geom_line(data = datm, aes(ct, er), colour = 'blue') +
  geom_line(data = datmf, aes(ct, er), colour = 'red') +
  facet_wrap(~ yr) +
  labs(x = 'Time (h)', y = 'Relative emission (frac. of applied TAN)')
ggsave('../plots/sim_mean.png', height = 8, width = 6)

ggplot(datm) +
  geom_line(data = dath, aes(ct, er, group = sim), colour = 'gray55') +
  geom_line(data = dathm, aes(ct, er), colour = 'blue', lwd = 1.5, alpha = 0.4) +
  geom_line(data = datm, aes(ct, er), colour = 'black', lwd = 1.5, alpha = 0.6) +
  geom_line(data = datmf, aes(ct, er), colour = 'red', lwd = 1.5, alpha = 0.6) +
  facet_wrap(~ yr) +
  xlim(0, 48) +
  labs(x = 'Time (h)', y = 'Relative emission (frac. of applied TAN)')
ggsave('../plots/sim_meana.png', height = 8, width = 6)

ggplot(datm) +
  geom_line(data = dath, aes(ct, air.temp, group = sim), colour = 'skyblue', lty = 1) +
  geom_step(data = datm, aes(ct, air.temp, group = sim), colour = 'red', lwd = 1.5, alpha = 0.3) +
  facet_wrap(~ yr) +
  labs(x = 'Time (h)', y = 'Air temperature')
ggsave('../plots/temp.png', height = 8, width = 6)

ggplot(datm) +
  geom_line(data = dath, aes(ct, r1, group = sim), colour = 'skyblue', lty = 1) +
  geom_step(data = datm, aes(ct, r1, group = sim), colour = 'red', lwd = 1.5, alpha = 0.3) +
  facet_wrap(~ yr) +
  labs(x = 'Time (h)', y = 'r1')
ggsave('../plots/r1.png', height = 8, width = 6)

ggplot(datm) +
  geom_line(data = dath, aes(ct, log10(r1), group = sim), colour = 'skyblue', lty = 1) +
  geom_step(data = datm, aes(ct, log10(r1), group = sim), colour = 'red', lwd = 1.5, alpha = 0.3) +
  facet_wrap(~ yr) +
  xlim(0, 48) +
  labs(x = 'Time (h)', y = 'r1')
ggsave('../plots/r1a.png', height = 8, width = 6)

ggplot(datm) +
  geom_line(data = dath, aes(ct, log10(r1), group = sim), colour = 'skyblue', lty = 1) +
  geom_step(data = datm, aes(ct, log10(r1), group = sim), colour = 'red', lwd = 1.5, alpha = 0.3) +
  facet_wrap(~ yr) +
  labs(x = 'Time (h)', y = 'log10 r1')
ggsave('../plots/logr1.png', height = 8, width = 6)

ggplot(datm) +
  geom_line(data = dath, aes(ct, wind.2m, group = sim), colour = 'skyblue', lty = 1) +
  geom_step(data = datm, aes(ct, wind.2m, group = sim), colour = 'red', lwd = 1.5, alpha = 0.3) +
  facet_wrap(~ yr) +
  labs(x = 'Time (h)', y = 'Air temperature')
ggsave('../plots/wind.png', height = 8, width = 6)

ggplot(datw168, aes(er.r, er.nr, colour = factor(yr))) +
  geom_abline(intercept = 0, slope = 1, col = 'gray45') +
  geom_point() +
  labs(x = 'EF with rain', y = 'EF without rain')
ggsave('../plots/rain_bv.png', height = 6, width = 6)
