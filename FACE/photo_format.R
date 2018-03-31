###biomass data

photo <- read.csv("FACE/data/face_photosynthesis.csv")
  photo$Date2 <- paste(photo$Date, "01", sep="_")
  photo$Date2 <- as.Date(photo$Date2, format = "%b_%Y_%d", tz='UTC')
  
library(doBy)
#function for se
se <- function(x) sd(x)/sqrt(length(x))
  
photo_co2 <- summaryBy(Anet ~ Date2 + treatment, data=photo, FUN=c(mean, se))

#plot bits
cols <- c("black", "red")
co2lab <- levels(photo_co2$treatment)
photolab <- expression(italic(A)[net]~~(mu*mol~m^-2~s^-1))

par(mar=c(5,5,1,1))
plot(Anet.mean ~ Date2, data=photo_co2, pch=19, col=cols[treatment], 
     ylim=c(10, 35), xlab="", ylab=photolab)
legend("topright",co2lab, col= cols, pch=19, bty='n', inset=0.01)
with(photo_co2, arrows(Date2, Anet.mean, Date2, Anet.mean+Anet.se,
                       angle=90, length=.03, col=cols[treatment]))
with(photo_co2, arrows(Date2, Anet.mean, Date2, Anet.mean-Anet.se,
                       angle=90, length=.03, col=cols[treatment]))
