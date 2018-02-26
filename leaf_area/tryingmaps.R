
data(ozone)

library(maps) #build into base R

windows()
map('world')

##add ozone data to a map
map('state', xlim=range(ozone$x), ylim=range(ozone$y)) #uses usa boundaries to start, then trimmed
  #text(ozone$x, ozone$y, ozone$median) #plot the actual values
  points(ozone$x, ozone$y, pch=21, bg="cornflower blue") #plot the locations

##points size representative of the variable value
map('state', xlim=range(ozone$x), ylim=range(ozone$y))
  points(ozone$x, ozone$y, pch=21, bg="dodgerblue", cex=sqrt(ozone$median/100))
#scaling usually done with squareroot transformation 
#data may need to be decreased by a order of magnitude to cex= a reasonable #


## plot but with color breaks for range of ozones
library(RColorBrewer)
colors <- brewer.pal(9, "YlOrRd") #another way for a ramped color choice

library(classInt)  #determine break points (bins) of a variable
brks<-classIntervals(ozone$median,  style="pretty") #non-overlapping breaks (lots of options)
brkcols <- findColours(brks, colors)
brklab<- brks$brks

par(mar=c(1,1,1,1))
map('state', xlim=range(ozone$x), ylim=range(ozone$y))
points(ozone$x, ozone$y, pch=21, bg=brkcols) #plot the locations
legend("topleft", pch=21, pt.bg=brkcols, legend=brklab, title="Ozone Levels", 
       xpd=TRUE, inset=-.1)



leafsize <- read.csv(leafsize_global.csv)


# https://journal.r-project.org/archive/2011-1/RJournal_2011-1_South.pdf
library(rworldmap)
#many map making systems use standard ISO country codes (3 letters)
data(countryExData)
str(countryExData)



# basic map 
library(rworldxtra)
newmap <- getMap(resolution = "high")
plot(newmap)

#Europe
plot(newmap,
     xlim = c(-20, 59),
     ylim = c(35, 71),
     asp = 1
)

###variables by country code
sPDF <- joinCountryData2Map( countryExData
                             ,joinCode = "ISO3"  ###this is the type of country code bein used
                             ,nameJoinColumn = "ISO3V10") ##variable in dataframe with country code
mapDevice() #create world map shaped window
mapCountryData(sPDF,nameColumnToPlot='PRODUCTIVE_NATURAL_RESOURCES', colourPalette = 'topo')

###points on map

newmap <- getMap(resolution = "low")
plot(newmap, xlim = c(-20, 59), ylim = c(35, 71), asp = 1)
points(airports$lon, airports$lat, col = "red", cex = .6)


mapDevice() #create world map shaped window
mapBubbles(dF=getMap()
           ,nameZSize="POP2005"
           ,nameZColour="REGION"
           ,colourPalette="rainbow")
#Zsize equals symbol sizing and Zcolour equals symbols colors

