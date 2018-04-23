###biomass data

photo <- read.csv("FACE/data/face_photosynthesis.csv")

photo$Date <- paste(photo$Date, "01", sep="_")
photo$Date2<- as.Date


library(doBy)
#function for se
library(sciplot)
  
photo_co2 <- summaryBy(Anet ~ Date2 + treatment, data=photo, 
             FUN=mean, na.rm=TRUE, keep.names = TRUE)

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

aco2 <- photo[photo$treatment=="aCO2",]
names(aco2)[7] <- "anet_aco2"

eco2 <- photo[photo$treatment=="eCO2",]
names(eco2)[7] <- "anet_eco2"

rr_data <- cbind(aco2, eco2[7]) 
rr_data$responseratio <- with(rr_data, anet_eco2/anet_aco2)

rr_co2 <- summaryBy(responseratio ~ Date2 + treatment, data=rr_data, FUN=c(mean, se))
plot(responseratio.mean ~ Date2, data=rr_co2, pch=19, "blue", xlab="", ylab="responseratio",
     ylim=c(0,2))
abline(h=1, lty=2)
