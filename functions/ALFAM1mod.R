# ALFAM1 model

ALFAM1mod <- function(
  dat  = data.frame(val = c(wetsoil = 0, air.temp = 13, wind.2m = 2, 
                            man.source.pig = 0, man.dm = 5, man.tan = 2.5, 
                            app.mthd.bsth = 1, app.mthd.ts = 0, 
                            app.mthd.os = 0, app.mthd.cs = 0, 
                            app.mthd.pi = 0, app.rate = 30, 
                            incorp.none = 1, meas.tech.wt = 0, meas.tech.mm = 1) 
                    ),
  pars = list(
           nmax = c(int = -3.026191481,
                    wetsoil = 0.0971267107,
                    air.temp = 0.0220549908,
                    wind.2m = 0.040853994,
                    man.source.pig = -0.1554849028,
                    man.dm = 0.1025565883,
                    man.tan = -0.1887421246,
                    app.mthd.bsth = -0.5499130125,
                    app.mthd.ts = -0.4094731295,
                    app.mthd.os = -1.2982834838,
                    app.mthd.cs = -0.610645959,
                    app.mthd.pi = -3.5755507688,
                    app.rate = -0.0040080214,
                    incorp.none = 2.4248027257,
                    meas.tech.wt = -0.6386589953,
                    meas.tech.mm = -0.5481814103),

           km = c(int = 0.0372957847,
                  wetsoil = 0.0971267107,
                  air.temp = -0.0408219945,
                  wind.2m = -0.0512932944,
                  man.source.pig = 1.3558351536,
                  man.dm = 0.1612681476,
                  man.tan = 0.1007499031,
                  app.mthd.bsth = 0,
                  app.mthd.ts = 0,
                  app.mthd.os = 0,
                  app.mthd.cs = 0,
                  app.mthd.pi = 0,
                  app.rate = 0.0175451792,
                  incorp.none = 0,
                  meas.tech.wt = 0.3920420878,
                  meas.tech.mm = 0.7030975114)
           ),
  time.name = 'ct',
  group = NULL,
  value = 'total',
  warn = TRUE) 
{

  # Get primary parameters for each observation
  par.names <- unique(names(pars[['nmax']]), names(pars[['km']]))
  par.names <- par.names[par.names != 'int']

  # Add missing predictors (set to 0)
  missing.vars <- par.names[!par.names %in% names(dat)]
  dat[, missing.vars] <- 0

  if (warn & length(missing.vars) > 0) {
    warning('Some parameters not used: ', paste(missing.vars, collapse = ', '))
  }

  # Calculate primary parameter values
  dat$int <- 1
  for (i in names(pars)) {
    bet <- pars[[i]]
    xmat <- as.matrix(dat[, names(bet)])
    dat[, i] <- exp(xmat %*% bet)
  }
 
  # NTS: limit nmax to 1????

  # Assign a fake group if needed
  if (is.null(group)) {
    dat$group <- 1
    group <- 'group'
  }

  # Sort
  dat$order.orig <- 1:nrow(dat)
  dat <- dat[order(dat[, group], dat[, time.name]), ]

  for (i in unique(dat[, group])) {
    dd <- dat[dat[, group] == i, ]
    dt <- diff(c(0, dd[, time.name]))

    # Adjust ct to start of interval
    cte <- dd[, time.name]
    cts <- c(0, dd[-nrow(dd), time.name])
    nmax <- dd$nmax
    km <- dd$km

    # Explicit form of model interval emis = [emis(t + dt) - emis(t)]
    # Formula in paper does not work
    er.int <- (nmax * cte / (cte + km)) - (nmax * cts / (cts + km))
    j <- er.int / dt
    er <- cumsum(er.int)

    dat[dat[, group] == i, c('j', 'er.int', 'er')] <- cbind(j, er.int, er)

  }

  dat <- dat[order(dat$order.orig), ]
  return(dat[, c(group, time.name, 'nmax', 'km', 'j', 'er.int', 'er')])
  #if (!is.null(group)) {
  #  return(dat[, c(time.name, 'j', 'e.rel.int', 'e.rel')])
  #} else {
  #}

}


calcA1Pars <- function(dat, pars, warn) {

  # Drop unused variables
  par.names <- unique(names(pars[['nmax']]), names(pars[['km']]))
  par.names <- par.names[par.names != 'int']
  dat <- dat[, names(dat) %in% par.names]

  # Add missing predictors (set to 0)
  missing.vars <- par.names[!par.names %in% names(dat)]
  dat[, missing.vars] <- 0
  dat <- as.data.frame(t(dat))
  names(dat) <- 'val'

  if (warn & length(missing.vars) > 0) {
    warning('Some parameters not used: ', paste(missing.vars, collapse = ', '))
  }

  # Add int row to dat
  dat <- rbind(dat, int = 1)

  nmaxd <- merge(data.frame(p = pars$nmax), dat, by = 0, all.x = TRUE)
  kmd <- merge(data.frame(p = pars$km), dat, by = 0, all.x = TRUE)

  nmax <- exp(sum(nmaxd$p * nmaxd$val))
  km <- exp(sum(kmd$p * kmd$val))

  return(c(nmax = nmax, km = km))


}
