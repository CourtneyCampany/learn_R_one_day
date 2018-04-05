#plotting precip

rain <- read.csv("flood/data/rain_co.csv")
  rain$DateTime<- as.POSIXct(rain$DATE,format="%Y%m%d %H:%M") 

seqraindates <- seq(min(rain$DateTime), max(rain$DateTime), length.out=10)
seqraindates2 <- seq(min(rain$DateTime), max(rain$DateTime), by = "10 years")

plot(HPCP ~ DateTime, data=rain, type="l", xaxt='n', xlab="")
axis.POSIXct(1, at=seqraindates2, las=3)




#make a month variable with lubridate package
library(lubridate)
rain$month <- month(rain$DateTime)

#function for se
# se <- function(x) sd(x)/sqrt(length(x))
# stderr <- function(x) sqrt(var(x,...)/length(na.omit(x)))


#means dataframe with doBy package
library(sciplot)
library(summaryBy)
rain_agg <- summaryBy(HPCP ~ month, , data=rain, FUN=c(mean, se), na.rm=TRUE)

meanrain <- with(rain, tapply(HPCP, month, FUN = mean)) 

library(plotrix)
b <- barplot(meanrain, col="white", width = 0.5, space = 0.5, ylim = c(0, 0.12),
             xaxt = "n")
plotCI(b, meanrain, uiw = rain_agg$HPCP.se, add = TRUE, pch = NA)
abline(h=0)
axis(1, at = 1:12, label = 1:12)
