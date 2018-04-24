#Getting NEON data from the web
#package not on Cran so we have to download from source
#this requires devtools package

install.packages("devtools")
library(devtools)

install_github("NEONScience/NEON-utilities/neonUtilities", dependencies=TRUE)

library(neonUtilities)

#Here is my example of a zip file saved in the NEON folder in my project
#The first argument is the data product ID (look inside your zip file or see tutorial)
#The second argument is the path to your zip file

stackByTable("DP1.00003.001","NEON/NEON_temp-air-triple.zip")
