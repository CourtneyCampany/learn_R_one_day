
### First we will learn how to use expression to tidy up or labels-----------------

### We often need to use expression() when we need sub-, superscripts & greek letters
### Replaces basic character strings such as "Leaf Area  (cm2)"

### Expression is a type of 'object' that has more ability than basic character strings
### Expression objects can sometimes be a headache, so only use it when needed

##basic plot
plot(5 , 5, xlab="Leaf Mass (g)", ylab="Leaf Area (cm2)")
##The label here is fine, but is not of publication quality with the cm2

la_lab <- expression(Leaf~Area~~(cm^2)) 
  ##you can have no blank spaces, set them with ~
  ##use ^ for supercripts

par(mar=c(5,5,1,1))
plot(5 , 5, xlab="Leaf Mass (g)", ylab=la_lab)


##other label examples------------

condlab <- expression(g[s]~~(mu*mol~m^-2~s^-1))
  #Greek letters are possible and subscripts use []

c13lab <-expression(paste(delta^{13}, "C (\u2030)")) 
  #more complicated symbols can be with unicodes
  #expression and character strings can be combined (if needed) using paste ()

anet <- expression(italic(A)[net]~~(mu*mol~m^-2~s^-1))
  #you can also add text style to certain bits instead of the whole string

plot(-20:-35 , 5:20, xlab=condlab, ylab=c13lab)
plot(20:35 , 5:20, xlab=condlab, ylab=anet)

###The above labels cover most aspects, just organize them somewhere useful.


#lets make a MAP with samples locations-------------------------------------------

##there are many many options for this based on your data and goals
## coordiantes, gis, interactive, etc
## http://cran.r-project.org/web/views/Spatial.html


library(maps) #build into base R

windows()
map('world')

data(ozone)
##add ozone data to a map
map('state', xlim=range(ozone$x), ylim=range(ozone$y)) #uses usa boundaries to start, then trimmed
text(ozone$x, ozone$y, ozone$median) #plot the actual values
points(ozone$x, ozone$y, pch=21, bg="cornflower blue") #plot the locations

##points size representative of the variable value
windows()
map('state', xlim=range(ozone$x), ylim=range(ozone$y))
points(ozone$x, ozone$y, pch=21, bg="dodgerblue", cex=sqrt(ozone$median/100))
#scaling usually done with squareroot transformation 
#data may need to be decreased by a order of magnitude to make cex= a reasonable value


## plot but with color breaks for range of ozones
library(RColorBrewer)
colors <- brewer.pal(8, "Greens") #another way for a ramped color choice

library(classInt)  #determine break points (bins) of a variable
brks<-classInt::classIntervals(ozone$median,style="pretty") 
#non-overlapping breaks (lots of options)
bins<- brks$brks

ozone$ozone_bin <- cut(ozone$median, breaks = bins)

par(mar=c(1,1,1,1))
map('state', xlim=range(ozone$x), ylim=range(ozone$y))
points(ozone$x, ozone$y, pch=21, bg=colors[ozone$ozone_bin]) #plot the locations
legend("topleft", pch=21, pt.bg=colors, legend=bins, title="Ozone Levels", 
       xpd=TRUE, inset=-.1)

