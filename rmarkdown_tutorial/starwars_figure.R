###(3) Using 'data3.csv' explore the relationship between height and mass of Stars Wars characters
### that reside on planets 'Tatooine' and 'Naboo'. On your figure, please distinguish between both
### the homeworld and species of each character. Please make sure height and mass are 
### presented in metric units.

starwars_chars <- read.csv("rmarkdown_tutorial/data/data3.csv")
  #unit conversion
  starwars_chars$mass_kg <- starwars_chars$mass_lb * 2.20462
  starwars_chars$height_m <- starwars_chars$height_in * .0254

#home planet subsets
twoplanets <- droplevels(starwars_chars[starwars_chars$homeworld  %in% c("Tatooine", "Naboo"),])

#plot bits:
library(scales)
library(wesanderson)
swcols <- c("gold", "cornflowerblue", "forestgreen")
swcols2 <- alpha(swcols, .75)
pchs <- c(21, 22)  
spp_names <- levels(twoplanets$species)

par(mar=c(4,4,1,1))
plot(mass_kg ~ height_m, data=twoplanets, ylab="Body Mass (kg)", 
     xlab="Height (m)", ylim=c(0, 200), xlim=c(0 ,4),
     pch=pchs[homeworld], 
     bg=swcols2[species], cex=2, type='n')

points(mass_kg ~ height_m, data=twoplanets[twoplanets$species == "Droid",],pch=21 ,bg=swcols[1], cex=2)
points(mass_kg ~ height_m, data=twoplanets[twoplanets$species == "Gungan",],pch=21 ,bg=swcols[2], cex=2)
points(mass_kg ~ height_m, data=twoplanets[twoplanets$species == "Human",],pch=21 ,bg=swcols[3], cex=2)

legend("topright", legend = c("Tatooine", "Naboo", spp_names),inset=0.01, bty='n',
       pch=c(pchs[1], pchs[2], rep(21, 3)), 
       pt.bg=c("black", "black", swcols2[1], swcols2[2], swcols2[3]))


  


