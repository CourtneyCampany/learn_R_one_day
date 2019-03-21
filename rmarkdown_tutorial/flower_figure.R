

#read data
flowers <- read.csv("raw_data/flowers.csv")

#simple linera model:
petal_mod <- lm(Petal.Length ~ Petal.Width, data=flowers)

#plot bits:
library(scales)
library(wesanderson)
library(plotrix)
mycols <- wes_palette("FantasticFox1", 3, type = "discrete")
mycols2 <- alpha(mycols, .75)
lengthlab <- "Petal Length (mm)"
widthlab <- "Petal Width (mm)"

#plot

# windows()
# 
# jpeg(filename = "rmarkdown_tutorial/flowers.jpeg",
#      width = 7, height =7, units = "in", res= 400)

par(mar=c(4,4,1,1))
plot(Petal.Length ~ Petal.Width, data=flowers, ylim=c(0, 9), xlim=c(0, 2.75),
     pch=21, bg=mycols2[Species], cex=1.5, ylab=lengthlab, xlab=widthlab)
ablineclip(petal_mod, x1=min(flowers$Petal.Width), x2=max(flowers$Petal.Width), lty=2, lwd=2)
legend("topleft", legend=levels(flowers$Species), pch=21, pt.bg=mycols, bty='n', inset=0.01)

# dev.off()
