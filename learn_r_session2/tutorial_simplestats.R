# BASIC STATS -----------

traits <- read.csv("raw_data/fern_traits.csv")

mean(traits$lamina_area_cm2)
var_la <- var(traits$lamina_area_cm2)
sqrt(var_la)
sd(traits$lamina_area_cm2)
median(traits$lamina_area_cm2)
quantile(traits$lamina_area_cm2)
#these functions might fail with NA's so remember to check for na.rm=TRUE)


# calculate a confidence inteval (perhaps subset a specific niche)

alpha_level <- 0.05 # 95% confidence interval
mean_lamina <- mean(traits$lamina_area_cm2) #sample mean
sd_lamina <- sd(traits$lamina_area_cm2) #sample standard deviation
n <- length(traits$lamina_area_cm2) #sample size
half.width <- qt(1-alpha_level/2, n-1)*sd_lamina/sqrt(n) #tail points of t distrib.

# Confidence Interval
ci_lamina <- c(xbar - half.width, xbar + half.width)




# hypothesis testing -----------

#we may ask if fern leaf size is consistent with global leaf size
t.test(traits$lamina_area_cm2, mu=315, conf.level = 0.90) #i made this number up

# depending on our data type, we usually check for a normal distribution
hist(traits$lamina_area_cm2)

#we can run non-parametric tests if we determine a ttest is not appropriate
wilcox.test(traits$lamina_area_cm2, mu=315)

# compare 2 populations
hist(traits$frond_length_cm)
levels(traits$niche)

#practive making 2 objects of frond length for epiphytes and terrestrial species 
frond_epi <- traits[traits$niche == "epiphyte",]
frond_terr <- traits[traits$niche == "terrestrial",]

#compare frond length between them
t.test(frond_epi$frond_length_cm, frond_terr$frond_length_cm, var.equal = TRUE)




# simple linear regression -----------

#we visualized this relationship earlier...
plot(frond_length_cm ~ lamina_area_cm2, data=traits)


# lets assume that our previous plot looked remotely linear
# lets setup a linear model investigated  the linear relationship between them

leaf_model <- lm(frond_length_cm ~ lamina_area_cm2, data=traits)
summary(leaf_model)

# It is necessary to examine how well our model fits the data
# R provides many ways to do this, man of them based on the residuals

#diagnoistics plots 

plot(leaf_model) #there should be not structure on the scale-location plot
norm <- residuals(leaf_model)
hist(norm)

# the car package has some of the best ones
library(car)
qqPlot(leaf_model) #uses confidence intervals to see departures from normality
residualPlot(leaf_model)

#often you may need a data transformation, lets visualize with a log transformation

windows()
plot(frond_length_cm ~ lamina_area_cm2, data=traits, log='xy')

#lets refit the model with the log transformation
logmodel <- lm(log10(frond_length_cm) ~ log10(lamina_area_cm2), data=traits)

qqPlot(logmodel) 
residualPlot(logmodel)
#R points out the row numbers of possible outliers on diagnostic plots

#it is easy to extract bits from the model summary
summary(logmodel)
coef(logmodel)

#lots of things you can extract
str(summary(logmodel))

#lets keep the R2 value
myr2 <- summary(logmodel)$r.squared


# lets remake our figure with a regression line
plot(log10(frond_length_cm) ~ log10(lamina_area_cm2), data=traits)
abline(logmodel) #draws a line from point a - b (look at help file)


# regression line CAN NOT exceed data points, 
# so we will use another package function from plotrix
library(scales)
library(plotrix)

LAlabel <- expression(Lamina~area~~(cm^2))
FLlabel <- "Frond Length (cm)"

mycols <- c("firebrick", "forestgreen", "dodgerblue")
mycols2 <- alpha(mycols, .75)

# make a nice r2 object to place on the graph
r2lab <- paste(expression(R^2), round(myr2,2), sep = " = ")

# R prints things on plots in the order you code them, 
# so for practice I want to put regression line underneath points
# I will need to make an empty plot first = type='n'

windows(7,7)
par(mar=c(4,4,1,1), cex.axis=.8, cex.lab=1.1, mgp=c(2.5, 1, 0))

plot(log10(frond_length_cm) ~ log10(lamina_area_cm2), data=traits,
     ylab=FLlabel, xlab=LAlabel, type = 'n') 

points(log10(frond_length_cm) ~ log10(lamina_area_cm2), data=traits,
       bg=mycols2[niche], pch=21, cex=1.5)

ablineclip(logmodel, x1=min(log10(traits$lamina_area_cm2)), 
                  x2=max(log10(traits$lamina_area_cm2)),
                  lty=2, lwd=2, col="black")

legend("bottomright", levels(traits$niche), pch=21,inset=0.01, 
       pt.bg=mycols2, bty='n')

#adding r2 object to the figure
text(1.5, 2.1, r2lab )
