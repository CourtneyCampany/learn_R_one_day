#litter data

litter <- read.csv("FACE/data/face_litter.csv")
  litter$Date <- as.Date(litter$Date, format= "%d/%m/%Y")
  litter$year <- as.factor(lubridate::year(litter$Date))
  litter$ring <- as.factor(litter$ring)
  litter$treatment <- as.factor(ifelse(litter$ring == 2 |
                             litter$ring == 3 |
                             litter$ring == 6,
                             "aCO2", "eCO2"))
  
  
##EAC litter trap is .2m^2. 
##How should we scale up to 1m^2? We can do this at the end
##To get annual average total lets take the mean of litter traps
##at each time point.  Then add up the time points?
  
library(doBy)
litter_mean_trap <- summaryBy(twig + bark+ seed + leaf ~ year + Date + ring +treatment, 
                    data=litter, FUN=mean, na.rm=TRUE, keep.names = TRUE) 

#now we have mean trap collection for each time point
#lets calculate the annual litter production

litter_annual <- summaryBy(twig + bark+ seed + leaf ~ year + ring + treatment, 
                 data=litter, FUN=sum, na.rm=TRUE, keep.names = TRUE)

litter_carbon<- data.frame(litter_annual[1:3], litter_annual[,4:7]*.47)

# litter_gCm2<- data.frame(litter_annual[1], litter_carbon[,2:5]*25)


litter_co2 <- summaryBy(twig + bark + seed + leaf ~ year +treatment, 
                        data=litter_carbon, FUN=mean, keep.names = TRUE)

litter_co2$total_litter <- with(litter_co2, twig+bark+seed+leaf)

litter_fum <- litter_co2[litter_co2$year != 2020,]

litter_bar <-litter_fum[,3:6]
cols <- c("brown", "forestgreen", "dodgerblue", "gold")

par(mar = c(5, 5, 1, 7.5), xpd = TRUE)
barplot(t(as.matrix(litter_bar)), names.arg=litter_fum[,2], width=2, xlab= "", 
        ylab="Annual Litter Flux (g)", col=cols, ylim=c(0, 650))
box()
legend("topright", inset = c(-0.3, 0), fill = cols, 
       legend=colnames(litter_bar), cex=1)
text(round(litter_co2[,7],0), y=6100, x=c(1.4,3.8, 6.2, 8.6))
