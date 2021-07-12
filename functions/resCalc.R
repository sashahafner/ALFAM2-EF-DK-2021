# Function for calculating residuals

resCalc <- function(p, dat, weights = 1, app.name, group = NULL, to = 'j', fixed, method = 'absolute', time.incorp = NULL, parallel = FALSE, prog = TRUE){

  #cat(p, '\n')

  if(!all(is.numeric(weights) | length(weights) > 0 | !all(is.na(weights)))) stop('Problem with weights argument.')
  if(!to%in%c('j', 'e', 'e.int', 'er')) stop('to argument must be "j", "e", "er", or "e.int" but is ', to)
  if(any(is.na(weights)) || any(is.null(weights))) stop('weights are NA or NULL')
  if(!missing(fixed)) p <- c(p, fixed)

  # This was where the order was off 24 Oct 2014
  obs <- dat[, to]
  if(length(weights) == 1) weights <- rep(weights, nrow(dat))
  obs[weights == 0] <- NA # To prevent warning on NaNs
  if(any(is.na(obs[weights>0]))) stop('NA values in observations obs, not just where weights = 0.')

  pred <- ALFAM2mod(dat, app.name = app.name, time.name = 'ct', 
                    time.incorp = time.incorp, group = group, pars = p, parallel = parallel)[, to]
  
  if(method == 'absolute') {
    res <- weights*(pred - obs) 
    res[weights == 0] <- 0 
    if(any(is.na(res))) warning('NA in residuals, see rows ', paste(which(is.na(res)), collapse = ', '), '. ')
    res[is.na(res)] <- 0
    return(res)
  }
  
  if(method == 'relative') {
    res <- weights*(log10(pred/obs)) 
    res[weights == 0] <- 0 
    if(any(is.nan(res))) {
      warning('NaN values in residuals:')
      cat('NaN values in residuals:')
      print(p)
      print(dat[is.nan(res), c('nid', 'file', 'row.in.file')])
      cat('NaN values in residuals (see above):')
    }
    return(res)
  }
  stop('method must be "absolute" or "relative" but is ', method)
}


resCalcOptim <- function(p, dat, weights = 1, app.name, group = NULL, to = 'j', fixed, method = 'TAE', time.incorp = NULL, parallel = FALSE, prog = TRUE){

  #cat(p, '\n')

  if(!all(is.numeric(weights) | length(weights) > 0 | !all(is.na(weights)))) stop('Problem with weights argument.')
  if(!to%in%c('j', 'e', 'e.int', 'er')) stop('to argument must be "j", "e", "er", or "e.int" but is ', to)
  if(any(is.na(weights)) || any(is.null(weights))) stop('weights are NA or NULL')
  if(!missing(fixed)) p <- c(p, fixed)

  # This was where the order was off 24 Oct 2014
  obs <- dat[, to]
  if(length(weights) == 1) weights <- rep(weights, nrow(dat))
  obs[weights == 0] <- NA # To prevent warning on NaNs
  if(any(is.na(obs[weights>0]))) stop('NA values in observations obs, not just where weights = 0.')

  pred <- ALFAM2mod(dat, app.name = app.name, time.name = 'ct', 
                    time.incorp = time.incorp, group = group, pars = p, parallel = parallel)[, to]
  
  if (method == 'TAE') {
    res <- weights*(pred - obs) 
    res[weights == 0] <- 0 
    if(any(is.na(res))) warning('NA in residuals, see rows ', paste(which(is.na(res)), collapse = ', '), '. ')
    res[is.na(res)] <- 0
    obj <- sum(abs(res))
    if (prog) cat(signif(obj, 5), ' ')
    return(obj)
  } else if (method == 'SS') {
    res <- weights * (pred - obs)
    res[weights == 0] <- 0 
    if(any(is.na(res))) warning('NA in residuals, see rows ', paste(which(is.na(res)), collapse = ', '), '. ')
    res[is.na(res)] <- 0
    obj <- sum(res^2)
    if (prog) cat(signif(obj, 5), ' ')
    return(obj)
  }
  stop('method must be "TAE" but is ', method)
}

