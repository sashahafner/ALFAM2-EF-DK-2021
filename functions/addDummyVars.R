
addDummyVars <- function(d) {

  # Factor levels, designed to match lm output
  if('man.source' %in% names(d)) {
    for(i in levels(d$man.source)) {
      d[, paste0('man.source.', i)] <- d$man.source == i
    }
  }

  if('app.mthd' %in% names(d)) {
    for(i in levels(d$app.mthd)) {
      d[, paste0('app.mthd.', i)] <- d$app.mthd == i
    }
  }

  if('app.mthd2' %in% names(d)) {
    for(i in levels(d$app.mthd2)) {
      d[, paste0('app.mthd2.', i)] <- d$app.mthd == i
    }
  }

  if('soil.type' %in% names(d)) {
    for(i in tolower(levels(d$soil.type))) {
      d[, paste0('soil.type.', i)] <- d$soil.type == i
    }
  }

  if('soil.type2' %in% names(d)) {
    for(i in tolower(levels(d$soil.type2))) {
      d[, paste0('soil.type2.', i)] <- d$soil.type2 == tolower(i)
    }
  }

  if('crop' %in% names(d)) {
    for(i in levels(d$crop)) {
      d[, paste0('crop.', i)] <- d$crop == i
    }
  }

  d[, 'crop.any'] <- d$crop != 'bare soil'

  if('inst' %in% names(d)) {
    for(i in levels(d$inst)) {
      d[, paste0('inst.', i)] <- d$inst == i
    }
  }

  if('incorp' %in% names(d)) {
    for(i in levels(d$incorp)) {
      d[, paste0('incorp.', i)] <- d$incorp == i
    }
  }

#  # Interactions, designed to match lm output
#  if('app.mthd' %in% names(d) & 'man.source' %in% names(d)) {
#    for(i in levels(d$app.mthd)) {
#      for(j in levels(d$man.source)) {
#        d[, paste0('app.mthd', i,'.man.source', j)] <- d$app.mthd == i & d$man.source == j
#      }
#    }  
#  }
#
#  if('app.mthd' %in% names(d) & 'crop' %in% names(d)) {
#    for(i in levels(d$app.mthd)) {
#      for(j in levels(d$crop)) {
#        d[, paste0('app.mthd', i,'.crop', j)] <- d$app.mthd == i & d$crop == j
#      }
#    }  
#  }
#
#  for(i in levels(d$app.mthd)) {
#    for(j in c('man.dm', 'man.tan', 'man.ph', 'app.rate', 'tan.app', 'air.temp', 'soil.temp', 'wind.1m', 'rad', 'crop.z')) {
#      if('app.mthd' %in% names(d) & j %in% names(d)) {
#        d[, paste0('app.mthd', i,'.', j)] <- (d$app.mthd == i)*d[, j]
#      }
#    }  
#  }
#
#  for(i in levels(d$crop)) {
#    for(j in c('man.dm', 'man.tan', 'man.ph', 'app.rate', 'tan.app', 'air.temp', 'soil.temp', 'wind.1m', 'rad', 'crop.z')) {
#      if('crop' %in% names(d) & j %in% names(d)) {
#        d[, paste0('crop', i,'.', j)] <- (d$crop == i)*d[, j]
#      }
#    }  
#  }

  return(d)
}


