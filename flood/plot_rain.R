#plotting precip

rain <- read.csv("flood/data/rain_co.csv")


str(rain)

#make a month variable with lubridate package
library(lubridate)
rain$month <- month(rain$DateTime)

#function for se
se <- function(x) sd(x)/sqrt(length(x))
#means dataframe with doBy package
rain_agg <- doBy::summaryBy(HPCP ~ month, data=rain,FUN=c(mean,se))

                         