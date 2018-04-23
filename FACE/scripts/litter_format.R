#litter data
litter <- read.csv("FACE/data/face_litter.csv")

##packages
library(doBy)
library(lubridate)

#constants
basket <- .2 #basket size in m2
c_frac <- .47 #conversion to biomass carbon

#format litter data-------
  litter$Date <- as.Date(litter$Date, format= "%d/%m/%Y")
  litter$year <- as.factor(year(litter$Date))
  
  # litter$ring <- as.factor(litter$ring)
  litter$treatment <- as.factor(ifelse(litter$ring == 2 |
                             litter$ring == 3 |
                             litter$ring == 6,
                             "aCO2", "eCO2"))

# remove two data points where big branches fell into litter bascket (repeat in sequence)
line.num <- which.max(litter$twig)
litter <- litter[-line.num,]
  
line.num <- which.max(litter$twig)
litter <- litter[-line.num,]
  
# UNIT CONVERSION: .2m2 biomass month-1 to g C m2 month-1 -------

#new dataframe, keep the categories and convert the data variables
litter_carbon  <- data.frame(litter[,c(1:3, 8:9)], (litter[,4:7] * c_frac)/basket)

##To get annual litter flux lets take the mean of litter traps at each time point-------
###Then sum up for the year

litter_mean_trap <- summaryBy(twig + bark+ seed + leaf ~ year + Date + ring +treatment, 
                    data=litter_carbon, FUN=mean, na.rm=TRUE, keep.names = TRUE) 


#no lets calculate the annual litter production------
litter_annual <- summaryBy(twig + bark+ seed + leaf ~ year + ring + treatment, 
                 data=litter_mean_trap, FUN=sum, keep.names = TRUE)

###lets save these so we can add them to the wood increment
write.csv(litter_annual, "FACE/data/litter_annual.csv", row.names = FALSE)


###sample stacked bar plot--------------------------------------

#CO2 effect for plottig
litter_co2 <- summaryBy(twig + bark + seed + leaf ~ year +treatment, 
                        data=litter_annual, FUN=mean, keep.names = TRUE)

#for 2021, 2022 & 2023
litter_fum <- droplevels(litter_co2[litter_co2$year != 2020,])
  litter_fum$totalflux <- with(litter_fum, twig+bark+seed+leaf)

#stacked bar plots reguire a matrix of only the data:
litter_bar <-litter_fum[,3:6]

#ugly colors
cols <- c("brown", "forestgreen", "dodgerblue", "gold")

par(mar = c(5, 5, 1, 7.5), xpd = TRUE)
#plot saved as an object:
b <-barplot(t(as.matrix(litter_bar)), xlab= "", xaxt='n',
        ylab="Annual Litter Flux (g)", col=cols, ylim=c(0, 350))
box()
legend("topright", inset = c(-0.3, 0), fill = cols, 
       legend=colnames(litter_bar), cex=1)
text(round(litter_fum[,7],0), y=320, x=b)
axis(1, at=b, litter_fum[,2], las=3)
mtext(text= unique(litter_fum$year), side=1, line=3.5, 
      at=c((b[2]-b[1])/2 + b[1], (b[4]-b[3])/2+b[3],((b[6]-b[5])/2)+ b[5])) 
           