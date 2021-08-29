# Record package and R versions

sink('software_versions.txt')
  source('versions.R', echo = TRUE)
sink()
