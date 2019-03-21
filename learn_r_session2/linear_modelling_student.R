# Linear Modelling -----------

traits <- read.csv("raw_data/fern_traits.csv")

# in our data set we have plant traits at different habitats
# because we have more than 2:
unique(levels(traits$niche))
#we can compare means across all these populations

# there are two commonly used functions to run an ANOVA
?aov() 
?lm()

# we will focuse on lm() because aov is limited to balanced designs

# lets examine a stipe_length_cm by habitat (niche)

boxplot()
#looks like there are possible some differences and a few outliers 
# lets test using lm()

stipe_mod <- lm()
stipe_mod
# coefficients are our contrasts with the intercept as the mean 1st variable
# R does things in alphabetical order, but you can change this if you want
# i.e. epiphytes have a mean that is -21.3 lower than climbers

summary()
# looks like epiphytes and hemi-epiphytes are different than climbers (so what?!?)
# we get a t stat and a p value for each contrast

# what maybe more interesting is the F stat and p value for the whole model
# at the bottom of the summary
# tells us that a model with means for each habitat works bettern than a model
# with a grand mean

anova() # we can run just the anova with the built in function

#there is also Anova() function in the car package
library(car)
?Anova() #it lets you change your between type II or II tests


# we likely want to whether stipe length in different habitats differ
# so we can use a new package for Tukey's multiple comparisons
library(mvtnorm) #i needed to load this
library(multcomp)

stipe_tukey <- glht(mymodel, linfct=mcp(factor = "Tukey"))
#that is some scary code (but you get to reuse it!) 
#input your model and state what factor to get Tukey values for (niche)

summary() #some of these are different, but not all
plot()

#this packages also creates significant letters for comparisons!! 
stipe_siglets <-cld() #stick these in a figure!!!



# 2-way Anova ----------

# We often have more thatn one treatment factor 
stipe_mod2 <- lm(stipe_length_cm ~ niche + site, data=traits)

summary()
#use car package to run Anova (for F statistic)
Anova()


# If you experimental design has an interaction, just re-write the model code
stipe_mod3 <- lm(stipe_length_cm ~ niche * site, data=traits)
#this will include each main effect and the interactions between them

summary()
Anova()

#there is a great pacakge to visual model predictions
library(visreg)
visreg(stipe_mod3) #main effects
visreg(stipe_mod3, "niche", by="site", overlay=TRUE)

# often you may want to compare model fits, 
# if you are thinking about removing factors or interactions

anova()
#compare AIC, pick the model with lowest AIC
AIC()


# There are a lot more details with 2-way ANOVA and multiple regression
# The manual has some great workflows, if you need a resouce