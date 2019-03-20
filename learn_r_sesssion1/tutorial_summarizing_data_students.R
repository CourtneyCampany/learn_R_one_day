traits <- read.csv("raw_data/fern_traits.csv")



# Summarizing data -----------

table(traits$niche) #table() is a easy summary to inspect factor levels

# probably my most used package is "doBy" which is great for data summaries
# there is an aggregate() function in base R, but the doBy package is way easier

library(doBy)
# function summaryBy() uses the same equation based formula you are used to:
# summaryBy(var1 + var2 ~ Groupvar1 + Groupvar2, FUN=c(mean,sd), data=mydata)

chl_agg <- summaryBy(chl_mg_m2 ~ niche, FUN=mean, data=traits)

traits_agg <- summaryBy(chl_mg_m2 + frond_length_cm + lamina_area_cm2 ~ 
                          niche + site, FUN=mean, data=traits)

# if you only have one FUN, you can add keep.names() 
# keeps variable names the same (BE CAREFUL)
species_agg <- summaryBy(chl_mg_m2 + frond_length_cm + lamina_area_cm2 ~ 
                           species, FUN=mean, data=traits, keep.names = TRUE)

# this function is pretty smart too, so you can apply to all variables
traits_agg2 <- summaryBy(. ~ niche, FUN=mean, data=traits, keep.names = TRUE)

# depending on you stats function (i.e. mean()), you may have to drop missing values
# or develop a new function with na.rm=TRUE




# first function!!! A way to automate repeated processes 
se <- function(x) sd(x)/sqrt(length(x))

chl_summ <- summaryBy(chl_mg_m2 ~ niche,data=traits_nona,FUN=c(mean, se))
traits_summ <- summaryBy(. ~ species + niche,data=traits_nona,FUN=c(mean, se))

# save this summary dataframe to make a table or analyze later
# we didnt do it super clean (ran all variables without thinking)

# get rid of plant_no_mean and plant_no_se, then save





# Merging data  -----------

# There are 2 ways to merge data
# 1. adding rows 
# 2. adding columns

# adding rows to each other is not difficult, if variables are the same
# ex. two experiment datasheets taken at different time periods

# row binding datasets with different columns is messy, 
# you may want to first ask why?

# fake data
mydata1 <- data.frame(var1=1:3, var2=5:7, var3=11:13)
mydata2 <- data.frame(var1=4:6, var2=8:10, var3=17:19)

# data have the same variable names in the same order, so....
rbind(mydata1, mydata2)
mydata3 <- rbind(mydata1, mydata2)


# You can also add to dataset together that have some 'matched' variables
# 'glueing datasets' side by side

# Here we use the 'merge' function but you have to PAY ATTENTION
?merge()

data1 <- data.frame(unit=c("x","x","x","y","z","z"),Time=c(1,2,3,1,1,2))
data2 <- data.frame(unit=c("y","z","x"), height=c(3.4,5.6,1.2))

# here we have datasets that share the variable 'unit'. 
# notice that they have different lengths

merge(data1, data2, by='unit')
# since both dataframes have all the levels of 'unit' the merge is easy....
# it assigns the same 'height' to each level of time for units x,y & z


# it is possible that your 'by' variable have differnt names, e.g. 'unit' & 'item'
# you can still merge:
merge(data1, data2, by.x="unit", by.y="item")
# avoid this headache by being diligent with our variable names!!!!!!!



# merge two dataframes with multiple variables

data3 <- data.frame(unit=c("x","x","x","y","y","y","z","z","z"),
                      Time=c(1,2,3,1,2,3,1,2,3),
                      Weight=c(3.1,5.2,6.9,2.2,5.1,7.5,3.5,6.1,8.0))

data4 <- data.frame(unit=c("x","x","y","y","z","z"),
                    Time=c(1,2,2,3,1,3),
                    Height=c(12.1,24.4,18.0,30.8,10.4,32.9))

combdata <- merge(data3, data4, by=c("unit","Time"))
# this looks different from the previous merge.....
# by default, only times that appear in the dataset that have measurements
# for both Weight (data1) and Height (data2) are kept


# may not be what you want. you may want all possible combinations,

combdata2 <- merge(data3, data4, by=c("unit","Time"), all=TRUE)
#no data are filled with NA's



###PRACTICE with the traits datasets, which I have split for you#####

traits_leaf <- traits[,1:9]
traits_chl <- traits[,c(3,5,10)]

#inspect the data frames and use the appropirate variables to merge

newtraits <- 
