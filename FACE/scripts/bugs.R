#bugs

litter <- read.csv("FACE/data/face_litter.csv")
  litter$Date <- as.Date(litter$Date, format= "%d/%m/%Y")
  litter$ring <- as.factor(litter$ring)
  litter$treatment <- as.factor(ifelse(litter$ring == 2 |
                                         litter$ring == 3 |
                                         litter$ring == 6,
                                       "aCO2", "eCO2"))

  
library(doBy)
litter_mean_trap <- summaryBy(leaf ~ Date + ring +treatment, 
                                data=litter, FUN=mean, na.rm=TRUE, keep.names = TRUE) 
cols <- c("black", "red")
co2lab <- c(expression(aCO^2), expression(eCO^2))
colpoly <- scales::alpha("red", .5)
polydates <- c(as.Date("2023-10-01"), as.Date("2023-10-30"))

plot(leaf ~ Date, data=litter, col=treatment, pch=16)
legend("topleft", legend=co2lab, pch=19, col=cols, bty='n', inset=.03)

polygon(x=c(polydates[1], polydates[1],polydates[2], polydates[2]), y=c(30, 60, 60, 30), col=colpoly)
