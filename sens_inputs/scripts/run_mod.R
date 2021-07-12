# Run model

prw <- ALFAM2mod(dat, app.name = 'tan.app', time.name = 'ct', time.incorp = 'time.incorp', 
                group = 'sida', pars = pars.w, parallel = FALSE, add.incorp.rows = TRUE)

pru <- ALFAM2mod(dat, app.name = 'tan.app', time.name = 'ct', time.incorp = 'time.incorp', 
                group = 'sida', pars = pars.u, parallel = FALSE, add.incorp.rows = TRUE)

# Run with par set 1 from paper
pr1 <- ALFAM2mod(dat, app.name = 'tan.app', time.name = 'ct', time.incorp = 'time.incorp', 
                group = 'sida', parallel = FALSE, add.incorp.rows = TRUE)
