
# visualizing data --------------------------------------------------------

#read in data
traits <- 

##choosing a plot type:  you have all the options (plot, barplot, hist, pie, boxplot)

#Two ways to make a plot of two variables X and Y that are contained in a dataframe

# Option 1: plot of X and Y
with(dfr, plot(X,Y))
# Option 2: formula interface (Y 'as a function of' X)   
plot(Y ~ X, data=dfr) #i use this one



###time to make it look pretty

###?par is your BFF

#alter axis ranges


#you can easily add treatment colors as long as they are factors

#choose a symbol type and color by factor 'niche'

#that pretty cool but the colors are soooo ugly
mycols <- c("red","forestgreen","cornflowerblue","gold","pink")
levels(traits$niche)
length(mycols)



#so often you have points that overlap, so we can add transparency and change point type

##This is our first look at PACKAGES (they are made to enhance base R)

library(scales) #you have to install them first, then load into global environment
?alpha()
mycols2 <- alpha(mycols, .75)

windows() #windows function opens a plotting box, and you and customise size (7,7)

 #bigger points
 #better colors

##we need to make some better axis titles (use ylab, xlab)

ylab="Frond Length (cm)", 
xlab=expression(Lamina~area~~(cm^2))) #expression allows sub/superscripts

#what if you need to use the super long lamina area label for many plots???
LAlabel <- expression(Lamina~area~~(cm^2))
FLlabel <- "Frond Length (cm)"




#almost there but are outside margins are funky.... ?par
#look at the plotting box, too much white space at top
#we can setup some global plotting parameters which will work for all subsequent plots

windows()
par(mar=c(4,4,1,1), cex.axis=.8, cex.lab=1.1, mgp=c(2.5, 1, 0))



#LEGEND time....
?legend() #lots and lots of options
#key ones: placements, 




##There are several ways to save figures, lets practive with making a pdf
##one way is to ' copy the device", which is our windows()

windows()
par(mar=c(4,4,1,1), cex.axis=.8, cex.lab=1.1, mgp=c(2.5, 1, 0))

plot(frond_length_cm ~ lamina_area_cm2, data=traits,ylim=c(0, 180), xlim=c(0, 1800),
     bg=mycols2[niche], pch=21, ylab=FLlabel, cex=1.5,
     xlab=LAlabel)  
legend("bottomright", levels(traits$niche), pch=21,inset=0.01, 
       pt.bg=mycols2, bty='n')

dev.copy2pdf(file="output/lengthbyarea.pdf")
dev.off() #this turns the device off


