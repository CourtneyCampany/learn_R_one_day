###(3) Using 'data3.csv' explore the relationship between height and mass of Stars Wars characters
### that reside on planets 'Tatooine' and 'Naboo'. On your figure, please distinguish between both
### the homeworld and species of each character. Please make sure height and mass are 
### presented in metric units.

starwars_chars <- read.csv("data/data3.csv")
  #unit conversion
  starwars_chars$mass_kg <- starwars_chars$mass_lb * 2.20462
  starwars_chars$height_m <- starwars_chars$height_in * .0254

#home planet subsets
tatooine <- starwars_chars[starwars_chars$homeworld == "Tatooine",]
tatooin_nona <- tatooine[complete.cases(tatooine),]
tatooin_nona2 <- droplevels(tatooin_nona)

naboo <-  starwars_chars[starwars_chars$homeworld == "Naboo",]
naboo_nona <- naboo[complete.cases(naboo),]
naboo_nona2 <- droplevels(naboo_nona)
  
#plot bits:
library(scales)
library(wesanderson)
swcols <- c("gold", "cornflowerblue")
swcols2 <- alpha(swcols, .75)
lengthlab <- "Petal Length (mm)"
widthlab <- "Petal Width (mm)"
  
#plot
par(mar=c(4,4,1,1))
plot(mass_kg ~ height_m, data=starwars_chars, type='n', ylab="Body Mass (kg)", 
     xlab="Height (m)", ylim=c(0, 1000), xlim=c(1 ,3))
points(mass_kg ~ height_m, data=tatooin_nona2, pch=21, bg=swcols[species], cex=2)
points(mass_kg ~ height_m, data=naboo_nona2, pch=22, bg=swcols2[species], cex=2)
legend("topright", legend = c("Tatooine", "Naboo", "Gungan", "Human"),
       pch=c(0, 1, 21,21), pt.bg=c("black", "black", mycols2[1], mycols2[2]), inset=0.01, bty='n')




