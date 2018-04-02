##packages
library(doBy)

#constants
basket <- .2 #basket size in m2
c_frac <- .47 #conversion to biomass carbon
unit_conv <- c_frac/basket #units from .2m2 biomass to m2 C


#litter data
litter <- read.csv("FACE/data/face_litter.csv")
  litter$Date <- as.Date(litter$Date, format= "%d/%m/%Y")
  litter$year <- as.factor(lubridate::year(litter$Date))
  litter$ring <- as.factor(litter$ring)
  litter$treatment <- as.factor(ifelse(litter$ring == 2 |
                             litter$ring == 3 |
                             litter$ring == 6,
                             "aCO2", "eCO2"))

# remove two data points where big branches fell into litter bascket (repeat in sequence)
line.num <- which.max(litter$twig)
litter <- litter[-line.num,]
  
line.num <- which.max(litter$twig)
litter <- litter[-line.num,]
  
#first lets take care of our units, .2m2 biomass month-1 to g C m2 month-1-------
litter_carbon  <- data.frame(litter[,c(1:3, 8:9)], (litter[,4:7] * c_frac)/basket)

##To get annual litter flux lets take the mean of litter traps at each time point. -------
###Then sum up for the year

litter_mean_trap <- summaryBy(twig + bark+ seed + leaf ~ year + Date + ring +treatment, 
                    data=litter_carbon, FUN=mean, na.rm=TRUE, keep.names = TRUE) 


#no lets calculate the annual litter production
litter_annual <- summaryBy(twig + bark+ seed + leaf ~ year + ring + treatment, 
                 data=litter_mean_trap, FUN=sum, keep.names = TRUE)

#CO2 effect
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
