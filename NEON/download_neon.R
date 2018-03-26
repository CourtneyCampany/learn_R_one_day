#Getting NEON data from the web
#package not on Cran so we have to download from source
#this requires devtools package

library(devtools)
install_github("NEONScience/NEON-utilities/neonDataStackR", dependencies=TRUE)

library (neonDataStackR)


stackByTable("NEON/NEON_size-dust-particulate.zip")


##I want data from leaf litter (desert, tropics, mountain, temperate)

#rates and chemistry & weather tp match?