# Plots

dd <- subset(d0, ct > 48 & ct <= 168)
ggplot(dd, aes(ct, ljerr, colour = factor(inst), group = pmid)) +
  geom_point() +
  geom_smooth(method = lm, se = FALSE, alpha = 0.3) + 
  geom_abline(intercept = 0, slope = 1)  +
  facet_grid(man.source ~ app.method) 

ggplot(dd, aes(ct, leerr, colour = factor(inst))) +
  geom_point() +
  geom_smooth(method = lm, se = FALSE, alpha = 0.3) + 
  geom_abline(intercept = 0, slope = 1)  +
  facet_grid(man.source ~ app.method) 


mod1 <- lm(leerr ~ ct * app.method + factor(pmid), data = dd, subset = is.finite(ljerr))
summary(mod1)
mod2 <- lm(leerr ~ ct * app.method + factor(pmid), data = dd, subset = is.finite(ljerr) & ct <= 168)
summary(mod2)
coef(mod1)

mod1 <- lm(ljerr ~ ct * app.method + factor(pmid), data = dd, subset = is.finite(ljerr))
summary(mod1)
mod2 <- lm(ljerr ~ ct * app.method + factor(pmid), data = dd, subset = is.finite(ljerr) & ct <= 168)
summary(mod2)
coef(mod1)


ggplot(dend, aes(j.NH3, j.pred, colour = ct)) +
  geom_point() +
  geom_abline(intercept = 0, slope = 1)  +
  xlim(0, 0.2) + ylim(0, 0.2) +
  facet_grid(man.source ~ app.method) 

dd <- subset(d0, is.finite(rerr))
ggplot(dd, aes(ct, lerr, colour = factor(inst), group = pmid)) +
  geom_point(alpha = 0.2) +
  geom_smooth(method = lm, se = FALSE) + 
  ylim(-1, 2) +
  labs(x = 'Time (h)', y = 'Apparent relative error in ALFAM2 model (log10, 0.2 = 60%, 0.5 = 3x, 1 = 10x diff.)') +
  facet_grid(man.source ~ app.method) 
ggsave('../plots/dur_err.pdf', height = 8, width = 16)

dd <- subset(ds, man.source %in% c('cat', 'pig') & app.method %in% c('bsth', 'bc', 'os', 'ts'))
ggplot(dd, aes(ct.max, inc.p72, colour = factor(paste(app.method, man.source)))) +
  geom_point(alpha = 0.2) +
  geom_smooth(se = FALSE) + 
  geom_smooth(aes(group = I(1)), colour = 'black', se = FALSE, lty = 2) + 
  labs(x = 'Time (h)', y = 'Apparent relative error in measured 72 h emission (% of final)')
ggsave('../plots/72h_err.pdf', height = 8.5, width = 11)

# Plot ALFAM2 predictions
pdf('../plots/dur_emis.pdf', height = 11, width = 8.5)
  par(mfrow = c(6, 4), mar = c(3, 3, 1, 0))
  for (i in unique(d0$pmid)) {

    dd <- subset(d0, pmid == i)
    if (all(!is.na(dd$er.pred))) {
      plot(c(er.pred, e.rel) ~ c(ct, ct), data = dd, type = 'n', 
           col = 'gray45', xlab = 'Time (h)', ylab = 'Rel. emission', 
           main = i)
      points(e.rel ~ ct, data = dd, col = 'gray45')
      lines(er.pred ~ ct, data = dd, col = 'blue')
    }

  }
dev.off()

