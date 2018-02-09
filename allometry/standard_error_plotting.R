#read in tree allometry data
trees <- read.csv("allometry/tree_allometry.csv")


levels(trees$vegetation)

trop_rf <- droplevels(trees[trees$vegetation == "TropRF",c("m.so", "h.t", "species", "pft")])
names(trop_rf)[1:2] <- c("biomass", "height")


table(trop_rf$species)

library(doBy) 
se <- function(x) sd(x)/sqrt(length(x))

trop_rf_means <- summaryBy(biomass +height ~ species + pft, data=trop_rf, FUN=c(mean, se))

##after inspection many of the mean, se did not work...why? look back at table

trop_rf_means2 <- trop_rf_means[complete.cases(trop_rf_means),]


##ok we are ready to plot, you can add standard erros with the arrows()

library(scales)
library(wesanderson)
pftfac <- length(levels(trop_rf_means2$pft))
pftcols <- wes_palette('Darjeeling', pftfac, type = 'discrete')
pftcols2 <- alpha(pftcols, .6)

plot(log10(biomass.mean) ~ log10(height.mean), data=trop_rf_means2, 
     xlab="Tree Height (m)", ylab="Tree biomass (kg)",
     axes=FALSE, pch=16,col=pftcols2[pft], cex=1)

with(trop_rf_means2, arrows(x0=log10(height.mean), y0=log10(biomass.mean), 
                           y1=log10(biomass.mean+biomass.se), 
                              angle=90, col="black",length=0.01, cex=1))

with(trop_rf_means2, arrows(x0=log10(height.mean), y0=log10(biomass.mean), 
                            y1=log10(biomass.mean-biomass.se), 
                            angle=90, col="black",length=0.01, cex=1))

magaxis(side=c(1,2), unlog=c(1,2), frame.plot=TRUE)


legend("topleft", legend=levels(trop_rf_means2$pft), pch=16, 
       col=pftcols2, bty='n',inset=0.02)



plot(biomass.mean ~ height.mean, data=trop_rf_means2, 
     xlab="Tree Height (m)", ylab="Tree biomass (kg)", pch=16,col=pftcols2[pft], cex=1)

with(trop_rf_means2, arrows(x0=height.mean, y0=biomass.mean, 
                            y1=biomass.mean+biomass.se, 
                            angle=90, col="black",length=0.01, cex=1))

with(trop_rf_means2, arrows(x0=height.mean, y0=biomass.mean, 
                            y1=biomass.mean-biomass.se, 
                            angle=90, col="black",length=0.01, cex=1))

legend("topleft", legend=levels(trop_rf_means2$pft), pch=16, 
       col=pftcols2, bty='n',inset=0.02)
