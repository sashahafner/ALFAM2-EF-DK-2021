# Model fit

d.pred$ct.grp <- cut(d.pred$ct, breaks = 0:100 * 24)

fsumm <- as.data.frame(summarise(group_by(d.pred.168, par.set, app.mthd), n.obs = length(er), MBE = mbe(er, er.pred), MAE = mae(er, er.pred), RMSE = rmse(er, er.pred), ME = me(er, er.pred)))
fsumm <- rounddf(fsumm, 3)

fsumm2 <- as.data.frame(summarise(group_by(d.pred.168, par.set), n.obs = length(er), MBE = mbe(er, er.pred), MAE = mae(er, er.pred), RMSE = rmse(er, er.pred), ME = me(er, er.pred)))
fsumm2 <- rounddf(fsumm2, 3)

fsumm.ct <- as.data.frame(summarise(group_by(d.pred, par.set, ct.grp), n.obs = length(er), MBE = mbe(er, er.pred), MAE = mae(er, er.pred), 
                                    RMSE = rmse(er, er.pred), ME = me(er, er.pred)))
fsumm.ct <- rounddf(fsumm.ct, 3)

fsumm.ct2 <- as.data.frame(summarise(group_by(d.pred, par.set, country, inst, man.source, app.mthd, ct.grp), n.obs = length(er), ct.mean = mean(ct), 
                                     er.mean = mean(er), 
                                     MBE = mbe(er, er.pred), MAE = mae(er, er.pred), 
                                     RMSE = rmse(er, er.pred), ME = me(er, er.pred)))

write.csv(fsumm, '../output/fit_summ1.csv', row.names = FALSE)
write.csv(fsumm2, '../output/fit_summ2.csv', row.names = FALSE)
write.csv(fsumm.ct, '../output/fit_summ_ct.csv', row.names = FALSE)
write.csv(fsumm.ct2, '../output/fit_summ_ct2.csv', row.names = FALSE)
