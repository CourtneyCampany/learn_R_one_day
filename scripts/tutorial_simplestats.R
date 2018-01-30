###BASIC STATS

traits <- read.csv("raw_data/fern_traits.csv")

mean(traits$lamina_area_cm2)
var_la <- var(traits$lamina_area_cm2)
sqrt(var_la) #stand dev 0r ....
sd(traits$lamina_area_cm2)
median(traits$lamina_area_cm2)
quantile(traits$lamina_area_cm2)
#these functions might fail with NA's s0 remember na.rm=TRUE)


#calculate a confidence inteval (perhaps subset a specific niche)
alpha_level <- 0.05 # 95% confidence interval
xbar <- mean(traits$lamina_area_cm2)
s <- sd(traits$lamina_area_cm2)
n <- length(traits$lamina_area_cm2)
half.width <- qt(1-alpha_level/2, n-1)*s/sqrt(n)
# Confidence Interval
c(xbar - half.width, xbar + half.width)

qqnorm(traits$lamina_area_cm2)


# simple linear regression ------------------------------------------------

##lets assume that our previous plot looked remotely linear
model <- lm(frond_length_cm~ lamina_area_cm2, data=traits)
summary(model)

plot(frond_length_cm ~ lamina_area_cm2, data=traits)
abline(model)

##we can plot the model object to get some diagnostics of the fit
plot(model)
library(car)
qqPlot(model) #with confidence intervals to better understand departures from normality
norm <- residuals(model)
hist(norm)

###we could perform a data transformation
logmodel <- lm(log10(frond_length_cm) ~ log10(lamina_area_cm2), data=traits)
summary(logmodel)
plot(logmodel)
#R points out the row numbers of the outliers on diagnostic plots

plot(frond_length_cm ~ lamina_area_cm2, data=traits, log='xy')
abline(logmodel)

###Lets remake our figure with regression line
###regression line CAN NOT exceed data points, so we will use another package function

LAlabel <- expression(Lamina~area~~(cm^2))
FLlabel <- "Frond Length (cm)"
library(scales)
library(plotrix)
mycols2 <- alpha(mycols, .75)
#extract the R2 value
r2mod <- round(summary(model)$r.squared, 2)
r2lab <- paste(expression(R^2), r2mod, sep = " = ")

#R prints things on plots in the order you code them, so for practive I want to put 
## regression line underneath points
## I will need to make an empty plot first

windows(7,7)
par(mar=c(4,4,1,1), cex.axis=.8, cex.lab=1.1, mgp=c(2.5, 1, 0))

plot(frond_length_cm ~ lamina_area_cm2, data=traits,ylim=c(0, 180), xlim=c(0, 1800),
      ylab=FLlabel, xlab=LAlabel, type = 'n') 

ablineclip(model2, x1=min(traits$lamina_area_cm2), x2=max(traits$lamina_area_cm2),
           lty=2, lwd=2)
points(frond_length_cm ~ lamina_area_cm2, data=traits, bg=mycols2[niche], pch=21, cex=1.5)

legend("bottomright", levels(traits$niche), pch=21,inset=0.01, 
       pt.bg=mycols2, bty='n')

#adding text to the figure
text(1600, 170, r2lab)
