# Model fit

dd <- subset(d.pred.168, !is.na(er.pred) & !is.na(er))
fsumm0 <- with(dd, data.frame(n.obs = length(er.pred), n.pmid = length(unique(pmid)), MBE = mbe(er, er.pred), MAE = mae(er, er.pred), RMSE = rmse(er, er.pred), ME = me(er, er.pred)))
fsumm0 <- rounddf(fsumm0, 3)

dd <- subset(d.pred.168, !is.na(er.pred) & !is.na(er))
fsumm <- as.data.frame(summarise(group_by(dd, app.mthd), n.obs = length(er.pred), n.pmid = length(unique(pmid)), MBE = mbe(er, er.pred), MAE = mae(er, er.pred), RMSE = rmse(er, er.pred), ME = me(er, er.pred)))
fsumm <- rounddf(fsumm, 3)

dd <- subset(d.pred2.168, !is.na(er.pred) & !is.na(er))
fsumm2 <- as.data.frame(summarise(group_by(dd, app.mthd), n.obs = length(er.pred), n.pmid = length(unique(pmid)), MBE = mbe(er, er.pred), MAE = mae(er, er.pred), RMSE = rmse(er, er.pred), ME = me(er, er.pred)))
fsumm2 <- rounddf(fsumm2, 3)

write.csv(fsumm0, '../output/fit_summ0.csv', row.names = FALSE)
write.csv(fsumm, '../output/fit_summ.csv', row.names = FALSE)
write.csv(fsumm2, '../output/fit_summ2.csv', row.names = FALSE)
