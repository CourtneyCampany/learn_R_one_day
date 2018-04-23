#read in wood biomass (from allometry with dbh)
wood_biomass <- read.csv("FACE/data/face_woodbiomass.csv")

#packages
library(doBy)
library(sciplot)

#constants & functions
ring_diameter <- 25 # ring diameter m
ring_area <- pi * (ring_diameter/2)^2 # ring total ground area m2
c_frac <- .47 #conversion to biomass carbon
kg_to_g <- 1000

se <- function(x) sd(x)/sqrt(length(x))

#sum wood biomass for each ring during each year
total_wood_ring <- summaryBy(biomass_kg ~ year + Ring + treatment, 
                  data=wood_biomass, FUN=sum, na.rm=TRUE, keep.names = T)


###total wood biomass is not npp, we need to know how much they grew each year-----------


#we only have year, so lets make a date to represent the end or each year-------
total_wood_ring$Date <- paste(total_wood_ring$year, "/12/31", sep="")
total_wood_ring$Date <- as.Date(total_wood_ring$Date, format = "%Y/%m/%d")

#these dates are going to be key so lets make a vector of them, in the right order
dates <- unique(total_wood_ring$Date)
dates <- dates[order(dates)]

#next lets make a new dataframe of our treatment years of biomass
wood_npp <- total_wood_ring[total_wood_ring$Date != dates[1],]
  wood_npp$Start_date <- wood_npp$Date  # we will populate it later, but it needs to be a date

#our first and only FOR LOOP:-----------
for (i in 1:length(wood_npp$Date)) {
 
   #set start data as the element before 'it' in the date vector. "it" is the date in wood_npp
  wood_npp$Start_date[i] <- dates[which(dates == wood_npp$Date[i]) - 1]  
  #uses our date vector
  
  # finds the previous years biomass for each ring @ right time
  wood_npp$prev_biom_kg[i] <- total_wood_ring$biomass_kg[total_wood_ring$Ring == wood_npp$Ring[i] &
                                             as.numeric(total_wood_ring$Date-wood_npp$Start_date[i])==0]
}

  
###almost there, need to convert units and deal with the first treament year........  
  
# Unit coversion from ring total in kg biomass to g C m-2 yr-1
wood_npp$wood_growth <- ((wood_npp$biomass_kg - wood_npp$prev_biom_kg)* c_frac * kg_to_g)/ring_area
  
#length of period for wood growth (2019 - 2021 is a problem)
wood_npp$timelength <- as.numeric(wood_npp$Date - wood_npp$Start_date)

wood_npp$wood_yr <- ifelse(wood_npp$timelength == 365, wood_npp$wood_growth/1, wood_npp$wood_growth/2)

##we now have annual production of wood biomass. Lets save it (but only the variables i need)
savedata <- wood_npp[, c(1:3, 5, 10)]

write.csv(savedata, "FACE/data/wood_npp.csv", row.names = FALSE)
                                      
                                      
  
  
###litter --------
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
#lets calculate the annual litter wood_nppuction

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

       