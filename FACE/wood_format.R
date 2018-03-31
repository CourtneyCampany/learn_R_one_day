###biomass data
se <- function(x) sd(x)/sqrt(length(x))

wood_biomass <- read.csv("FACE/data/face_woodbiomass.csv")

library(doBy)
ring_total_wood <- summaryBy(biomass_kg ~ year + treatment + Ring, 
                             data=wood_biomass, FUN=sum, na.rm=TRUE, keep.names = T)


###litter 
litter <- read.csv("FACE/data/face_litter.csv")
litter$Date <- as.Date(litter$Date, format= "%d/%m/%Y")
litter$year <- lubridate::year(litter$Date)
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

#ready to merge, but check variable names
colnames(ring_total_wood)
colnames(litter_annual)

#ring is not the same:
names(ring_total_wood)[3] <- "ring"
ring_total_wood$ring <- as.factor(ring_total_wood$ring)

##remeber that merge can work in many ways
##we dont want all the years:  try different ways to get the merge to work

#here the basic merge works...why?  will only include direct matches..
#the two years that dont match are dropped
anpp <- merge(litter_annual, ring_total_wood)
  anpp$litter_total <- with(anpp, leaf+twig+bark+seed)
  anpp$anpp <- with(anpp, litter_total + biomass_kg)
  
library(plotrix)
anpp_year <- summaryBy(.~year+treatment, data=anpp, FUN=c(mean,se))

##plotbits
cols <- c("black", "red")
co2lab <- c(expression(aCO^2), expression(eCO^2))

meananpp <- with(newrain, tapply(HPCP, month, FUN = mean))

##plot anpp
par(mar = c(5, 5, 1, 7.5), xpd = TRUE)  
anpp_bar <- barplot(anpp_year$anpp.mean, anpp_year$year, col=anpp$treatment, 
                    ylim=c(0, 6500))
box()
legend("topright", inset = c(-0.3, 0), fill = cols, legend=co2lab, cex=1)
plotCI(anpp_bar, anpp_year$anpp.mean, uiw = anpp_year$anpp.se, 
       add = TRUE,pch=NA)

       