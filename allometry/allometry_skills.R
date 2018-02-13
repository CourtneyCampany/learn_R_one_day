#read in tree allometry data
trees <- read.csv("allometry/tree_allometry.csv")

###TREE ALLOMETRIC RELATIONSHIPS

### values can extend from 1, 10, 100, 1000...so....
### This can be a real issue when analyzing biomass data
### trees are a great example, there is hhhuuugggeee variation

###These large differences can results in a farily skewed dataset'

###Lets look at one:

plot(m.so ~ h.t, data=trees) ##aboveground mass as a function of tree height
##trees seem to get exponentially fatter as they get taller
##this type of relationship is also more difficult to analyze

#log transformations change the scale of the data. 
#Normally data is expressed on a linear scale, so each tickmark increasess by the same amount
##Our data doesnt appear to follow this constant linear trend

#Using a log scale we shift to a multiplicative scale, so data will be expressed by multipliers
#if we use log10, then we can express the data in scales of ten---"orders of magnitude'

###lets go ahead and replot
plot(m.so ~ h.t, data=trees, log='xy') #in base graphics you can choose which axis to log
#the problem here is the plot is ugly and by default R computes the natural logarithm

##learn magic axis
install.packages("magicaxis")
install.packages("scales")
install.packages("wesanderson")

library(magicaxis)
??magaxis

library(scales)
library(wesanderson)
vegfac <- length(levels(trees$vegetation))
vegcols <- wes_palette('Zissou', vegfac, type = 'continuous')
vegcols2 <- alpha(vegcols, .25)

windows()
plot(log10(m.so) ~ log10(h.t), data=trees, xlab="Tree Height (m)", ylab="Tree biomass (kg)",
     axes=FALSE, pch=16,col=vegcols2[vegetation]) #here I turn both axes 'off' so I can customize them
magaxis(side=c(1,2), unlog=c(1,2), frame.plot=TRUE)
legend("topleft", legend=levels(trees$vegetation), pch=16, col=vegcols, bty='n',inset=0.02)

##Know we could proceeed with building predicitive linean allometric models
##based on log linear data.

####BIOMASS ALLOCATION

#mass fractions and ontogeny...

#allocation of biomass is different than just measured biomass at anytime
#reflects investment in certain components during specific growth phases
#may vary over time, across environments and among species

##IT MOST DEFINETELY varies with age --- 'ontogeny' or development
##This mostly relates to the increase in trunk wood through time, as it doesnt turnover

smf <- massinstems/totalmass
lmf <- massinleaves/totalmass

lma <- massinleaves/areaofleaves #investment in leaf longevity (fast vs slow)


###If you have 2 figures with a shared axis you may want to make a panel figure
### this is fairly easy in base graphics wiht the mfrow() argument in ?par

windows(10,7)
par(mfrow=c(2,1)) #By switching order (1,2) makes either 2 horizontal of vertical panes
plot(m.so ~ h.t, data=trees, log='xy')
plot(m.so ~ h.t, data=trees, log='xy')

##if you enter these in your markdown chunk remember that you can change 
##the size of the total figure in chunk options
