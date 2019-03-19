
# VISUALIZING DATA -----------

traits <- read.csv("raw_data/fern_traits.csv")

# choosing a plot type:  you have all the options (plot, barplot, hist, pie, boxplot)

# Two ways to make a plot of two variables X and Y that are contained in a dataframe

# Option 1: plot of X and Y
with(dfr, plot(X,Y))

# Option 2: formula interface (Y 'as a function of' X)   
plot(Y ~ X, data=dfr) #i use this one as it syncs with coding models

# try with traits:
plot(frond_length_cm ~ lamina_area_cm2, data=traits)
boxplot(frond_length_cm ~ niche, data=traits)
hist(traits$frond_length_cm)

# Making plots pretty

###?par is your BFF  -----------

?par()

plot(frond_length_cm ~ lamina_area_cm2, data=traits,
     ylim=c(0, 180), xlim=c(0, 1800)) #alter axis ranges

# easily add treatment colors as long as they are factors

plot(frond_length_cm ~ lamina_area_cm2, data=traits,
     ylim=c(0, 180), xlim=c(0, 1800),
     bg=niche, pch=25) #choose a symbol type and color by factor 'niche'

# basic colors are ugly
# create an object of nice ones

levels(traits$niche) #how many colors do we need?

mycols <- c("firebrick","forestgreen","dodgerblue")

length(mycols)

plot(frond_length_cm ~ lamina_area_cm2, data=traits,ylim=c(0, 180), 
     xlim=c(0, 1800),bg=mycols[niche], pch=21)

# often you have points that overlap
# add transparency and change point type

##This is our first look at PACKAGES (they are made to enhance base R)

library(scales) #you have to install them first, then load into global environment

mycols2 <- alpha(mycols, .75)

windows() #windows/quartc function opens a plotting box, 
# you can customise size: quartz(7,7)

plot(frond_length_cm ~ lamina_area_cm2, data=traits,ylim=c(0, 180),  xlim=c(0, 1800), 
     cex=1.5, #bigger points
     bg=mycols2[niche], pch=21) #better colors


# Make some better axis titles (use ylab, xlab) as it just uses column name
plot(frond_length_cm ~ lamina_area_cm2, data=traits,ylim=c(0, 180), xlim=c(0, 1800),
     cex=1.5, bg=mycols2[niche], pch=21, ylab="Frond Length (cm)", 
     xlab="Lamina area (cm^2)") 

# use expression to format sub/superscripts:
# make your label as an object so they are re-usable and cleaner
LAlabel <- expression(Lamina~area~~(cm^2))
FLlabel <- "Frond Length (cm)"


plot(frond_length_cm ~ lamina_area_cm2, data=traits,ylim=c(0, 180), xlim=c(0, 1800),cex=1.5,
     bg=mycols2[niche], pch=21, ylab=FLlabel, xlab=LAlabel)

# almost there but are outside margins are funky.... ?par
# look at the plotting box, too much white space at top
# we can setup some global plotting parameters above any plot using par()
# will work for all subsequent plots

windows(7,7)
par(mar=c(4,4,1,1), cex.axis=.8, cex.lab=1.1, mgp=c(2.5, 1, 0))

plot(frond_length_cm ~ lamina_area_cm2, data=traits,ylim=c(0, 180), xlim=c(0, 1800),
     bg=mycols2[niche], pch=21, ylab=FLlabel, cex=1.5,
     xlab=LAlabel)  

# LEGEND time....
?legend() #lots and lots of options
#key ones: placements, labels, points or lines, and colors

legend("bottomright", levels(traits$niche), pch=21, pt.bg=mycols2, bty='n') 
legend(x=0, y=180,levels(traits$niche), pch=21, pt.bg=mycols2, bty='n', 
       title = "Plant Type") 


# Save figures, just about every output available: -----------

# lets first practive with making a pdf

# one way is to ' copy the device", which is our windows()

windows()
par(mar=c(4,4,1,1), cex.axis=.8, cex.lab=1.1, mgp=c(2.5, 1, 0))

plot(frond_length_cm ~ lamina_area_cm2, data=traits,ylim=c(0, 180), xlim=c(0, 1800),
     bg=mycols2[niche], pch=21, ylab=FLlabel, cex=1.5,
     xlab=LAlabel)  
legend("bottomright", levels(traits$niche), pch=21,inset=0.01, 
       pt.bg=mycols2, bty='n')

dev.copy2pdf(file="output/lengthbyarea.pdf")
dev.off() #this turns the device off

#you can also export the image from the plotting window in Rstudio:
# rerun the code without windows() or dev.copy and click export


# there are built in base functions for creating pngs, jpg, tiffs, etc
# ususally more than one are needed, my setup tends to have pdf and png/jpg
# make sure to type the filepath with right extendion (.pdf)
#comment out other printing formats


# windows()

png(filename = "output/lengthbyarea.png", width = 7, height = 7,
    units = "in", res= 400)

# jpeg(filename = "output/lengthbyarea.jpeg",
#      width = 7, height =7, units = "in", res= 300)

par(mar=c(4,4,1,1), cex.axis=.8, cex.lab=1.1, mgp=c(2.5, 1, 0))

plot(frond_length_cm ~ lamina_area_cm2, data=traits,ylim=c(0, 180), xlim=c(0, 1800),
     bg=mycols2[niche], pch=21, ylab=FLlabel, cex=1.5,
     xlab=LAlabel)  
legend("bottomright", levels(traits$niche), pch=21,inset=0.01, 
       pt.bg=mycols2, bty='n')

# dev.copy2pdf(file="output/lengthbyarea.pdf")
dev.off()

