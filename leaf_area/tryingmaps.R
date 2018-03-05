
leafsize <- read.csv("leaf_area/leafarea_global.csv")
leafsize2 <- leafsize[complete.cases(leafsize$Leaf.size_cm2),]


leafsize <- read.csv("leaf_area/leafarea_global.csv")
library(maps)
map('world')
cols <- c("gold", "forestgreen")

map('world')
points(Latitude ~ Longitude, col=cols[Decid_or_Ever], data=leafsize, pch=16, cex=.5)




library(RColorBrewer)
colors <- brewer.pal(6, "Greens")


library(classInt) 
brks<-classIntervals(leafsize2$Leaf.size_cm2,style="fixed",
                     fixedBreaks=c(0, 500, 1000, 1500, 2000, 2600)) 
#non-overlapping breaks (lots of options)
bins<- brks$brks

leafsize2$la_bin <- cut(leafsize2$Leaf.size_cm2, breaks = bins)

par(mar=c(1,1,1,1))

windows()
map('world')
points(Latitude ~ Longitude, col=colors[la_bin], data=leafsize2, pch=16, cex=.5)

legend("topleft", pch=21, pt.bg=colors, legend=leafsize2$la_bins, title="Ozone Levels", 
       xpd=TRUE, inset=-.1)





library(maps) #build into base R

map('world')
cols <- c("gold", "forestgreen")

windows()
map('world')
points(Latitude ~ Longitude, col=cols[Decid_or_Ever], data=leafsize, pch=16, cex=.5)



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

