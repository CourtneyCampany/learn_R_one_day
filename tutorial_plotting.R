# visualizing data --------------------------------------------------------

##choosing a plot type:  you have all the options (plot, barplot, hist, pie, boxplot)

#Two ways to make a plot of two variables X and Y that are contained in a dataframe

# Option 1: plot of X and Y
with(dfr, plot(X,Y))
# Option 2: formula interface (Y 'as a function of' X)   
plot(Y ~ X, data=dfr) #i use this one

plot(frond_length_cm ~ lamina_area_cm2, data=traits)

###time time make it look pretty
###?par is your BFF
plot(frond_length_cm ~ lamina_area_cm2, data=traits,
     ylim=c(0, 180), xlim=c(0, 1800))
#you can easily add treatment colors as long as they are factors
plot(frond_length_cm ~ lamina_area_cm2, data=traits,
     ylim=c(0, 180), xlim=c(0, 1800),
     bg=niche, pch=25)
#that pretty cool but the colors are soo ugly
levels(traits$niche)
length(mycols)

plot(frond_length_cm ~ lamina_area_cm2, data=traits,
     ylim=c(0, 180), xlim=c(0, 1800),
     bg=mycols[niche], pch=21)
#so often you have points that overlap, so we can add transparency and change point type

##This is our first look at packages (they are made to enhance base R)
library(scales) #you have to install them first, then load intro environment
mycols2 <- alpha(mycols, .75)

windows()
plot(frond_length_cm ~ lamina_area_cm2, data=traits,ylim=c(0, 180), 
     xlim=c(0, 1800), cex=1.5,
     bg=mycols2[niche], pch=21)

##we need to make some better axis titles (use ylab, xlab)
plot(frond_length_cm ~ lamina_area_cm2, data=traits,ylim=c(0, 180), xlim=c(0, 1800),
     bg=mycols2[niche], pch=21, ylab="Frond Length (cm)", 
     xlab=expression(Lamina~area~~(cm^2))) #expression allows sub/superscripts

#what if you need to use the super long lamina area label for many plots???
LAlabel <- expression(Lamina~area~~(cm^2))


plot(frond_length_cm ~ lamina_area_cm2, data=traits,ylim=c(0, 180), xlim=c(0, 1800),
     bg=mycols2[niche], pch=21, ylab="Frond Length (cm)", 
     xlab=LAlabel)

#almost there but are outside margins are funky.... ?par
#we can setup some global plotting parameters which will work for all subsequent plots

windows()
par(mar=c(4,4,1,1), cex.axis=.8, cex.lab=1.1, mgp=c(2.5, 1, 0))

plot(frond_length_cm ~ lamina_area_cm2, data=traits,ylim=c(0, 180), xlim=c(0, 1800),
     bg=mycols2[niche], pch=21, ylab="Frond Length (cm)", cex=1.5,
     xlab=LAlabel)  

#almost done...but we need a legend 

legend("bottomright", levels(traits$niche), pch=21,inset=0.01, 
       pt.bg=mycols2, bty='n') 

dev.copy2pdf(file="output/lengthbyarea.pdf")
dev.off()
###BASIC STATS

mean(traits$lamina_area_cm2)
var_la <- var(traits$lamina_area_cm2)
sqrt(var_la) #stand dev 0r ....
sd(traits$lamina_area_cm2)
median(traits$lamina_area_cm2)
quantile(traits$lamina_area_cm2)
#these functions might fail with NA's s0 remember na.rm=TRUE)


#calculate a confidence inteval (perhaps subset a specific niche)
alpha <- 0.05 # 95% confidence interval
xbar <- mean(traits$lamina_area_cm2)
s <- sd(traits$lamina_area_cm2)
n <- length(traits$lamina_area_cm2)
half.width <- qt(1-alpha/2, n-1)*s/sqrt(n)
# Confidence Interval
c(xbar - half.width, xbar + half.width)

qqnorm(traits$lamina_area_cm2)



# simple linear regression ------------------------------------------------

##lets assume that our previous plot looked remotely linear

plot(frond_length_cm ~ lamina_area_cm2, data=traits)

model <- lm(log10(frond_length_cm) ~ log10(lamina_area_cm2), data=traits)
summary(model)

plot(log10(frond_length_cm) ~ log10(lamina_area_cm2), data=traits,log='xy')
abline(model)

##we can plot the model object to get some diagnostics of the fit
plot(model)
library(car)
qqPlot(model) #puts confidence intervals on to better understand departures from normality
###we could perform a data transformation
plot(frond_length_cm ~ lamina_area_cm2, data=traits, log='xy')
logmodel <- lm(log10(frond_length_cm) ~ log10(lamina_area_cm2), data=traits)
summary(logmodel)
plot(logmodel)
#R points out the row numbers of the outliers on diagnostic plots

norm <- residuals(model)
hist(norm)


# summarizing data --------------------------------------------------------

#probably my most used package is "doBy" which is great for data summaries

library(doBy)
#summaryBy(Yvar1 + Yvar2 ~ Groupvar1 + Groupvar2, FUN=c(mean,sd), data=mydata)

chl_agg <- summaryBy(chl_mg_m2 ~ species + niche, FUN=mean, data=traits)

traits_agg <- summaryBy(chl_mg_m2 + frond_length_cm + lamina_area_cm2 ~ 
                          niche, FUN=mean, data=traits)

#if you only have one FUN, you can add keep.names to not alter variable names (BE CAREFUL)
species_agg <- summaryBy(chl_mg_m2 + frond_length_cm + lamina_area_cm2 ~ 
                           species, FUN=mean, data=traits, keep.names = TRUE)
##this function is pretty smart too so you can to all variables
## assuming your factors are properly assigned
traits_agg2 <- summaryBy(. ~ species + niche, FUN=mean, data=traits, keep.names = TRUE)

#if we add more FUN, we very likley need to get rid of any missing values
traits_nona <- traits[complete.cases(traits),]

se <- function(x) sd(x)/sqrt(length(x))
traits_summ <- summaryBy(. ~ species + niche,
                         data=traits_nona,
                         FUN=c(mean, se))

##we can save this summary dataframe to make a table later...we didnt do it super clean
##so lets use what we have learned to get rid of plant_no_mean
str(traits_summ)
fernsumm <- traits_summ[, -c(3, 10)]

write.csv(fernsumm, "output/fern_traits_summary.csv", row.names = FALSE)