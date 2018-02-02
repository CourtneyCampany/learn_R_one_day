traits <- read.csv("raw_data/fern_traits.csv")

#classes --------------------------------------------------------------------------

#Variables have different classes: all of which are important
#numeric, character, factor(categorical), logical, date, POSIXct (date+time) are the main ones

str(traits)

#R tries to assign character classes at factors (but you can always do it yourself)

str(traits$site)
traits$site <- as.character(traits$site)
traits$site <- as.factor(traits$site)

levels(traits$niche) #factor levels are important (zeros, deleting data)

#for example: you have 2 CO2 treatments which R reads as numeric
dfr$co2 <- as.factor(dfr$co2)

#if you delete a certain factor in your dataframe all the factors levels will still remain
epi_dat <- traits[!traits$niche == "terrestrial",]
levels(epi_dat$niche) #this can be very important for stats
droplevels(traits) #if you want it really gone.


# DATES: there is a standard format for dates with coding:
## "1969-08-18 09:00:00"
## most of the time we forget to do this and R often classifies our Date column as factor

# Dates simple
sometime <- as.Date("1980-6-19")
str(sometime)

#format date for traits dataframe
head(traits$date)
?as.Date
?strptime
traits$date <- as.Date(traits$date, format= "%d/%m/%Y", tz="UTC")
#did it work?
max(traits$date)
str(traits$date)

exp_duration <- max(traits$date) - min(traits$date) 

#Manipulating data-----------------------------------------------------

#1. Combining character vectors (columns) with paste()

dfr$trt <- paste(dfr$co2, dfr$wp, sep="-") #this is the format, see ?paste()

#lets pretend that we had different sites for the traits dataset
traits$id <- paste(traits$site, traits$species, sep="-")
#or use with()
traits$id2 <- with(traits, paste("site", "niche", sep="."))

#make new variables
traits$laminalength_m <- with(traits, laminalength_cm/100)


# missing values ----------------------------------------------------------

#missing values are represented with NA,indicating the data is simply 'Not Available'.

myvec1 <- c(11,13,5,6,NA,9)
mean(myvec1) #functions may not work with missing values, check help file
mean(myvec1, na.rm=TRUE)

#super useful to check your data...
is.na(myvec1)
which(is.na(myvec1))

is.na(traits)
which(is.na(traits))

#if you want the dataframe with only rows that have no missing values (BE CAREFUL)
traits_nona <- traits[complete.cases(traits),] #this deletes real data too!!!!

# summarizing data --------------------------------------------------------

table(traits$niche) #table() is a easy summary to inspect factor levels in a dataframe

#probably my most used package is "doBy" which is great for data summaries
#there is the aggregate() function in base R, but the doBy package is way easier

library(doBy)
#summaryBy(Yvar1 + Yvar2 ~ Groupvar1 + Groupvar2, FUN=c(mean,sd), data=mydata)

chl_agg <- summaryBy(chl_mg_m2 ~ species + niche, FUN=mean, data=traits)

traits_agg <- summaryBy(chl_mg_m2 + frond_length_cm + lamina_area_cm2 ~ 
                          niche, FUN=mean, data=traits)

#if you only have one FUN, you can add keep.names to not alter variable names (BE CAREFUL)
species_agg <- summaryBy(chl_mg_m2 + frond_length_cm + lamina_area_cm2 ~ 
                           species, FUN=mean, data=traits, keep.names = TRUE)

##this function is pretty smart too, so you apply to all variables
## assuming your factors are properly assigned
traits_agg2 <- summaryBy(. ~ species + niche, FUN=mean, data=traits, keep.names = TRUE)

#if we add more FUN, we very likley need to get rid of any missing values
traits_nona <- traits[complete.cases(traits),]


##first function!!! A way to automate repeated processes 
se <- function(x) sd(x)/sqrt(length(x))

traits_summ <- summaryBy(chl_mg_m2 ~ species + niche,data=traits_nona,FUN=c(mean, se))
traits_summ2 <- summaryBy(. ~ species + niche,data=traits_nona,FUN=c(mean, se))

##we can save this summary dataframe to make a table later...we didnt do it super clean
##so lets use what we have learned to get rid of plant_no_mean
str(traits_summ2)
fernsumm <- traits_summ2[, -c(3, 10)]

write.csv(fernsumm, "output/fern_traits_summary.csv", row.names = FALSE)


### merging data---------------------------------------------

###there are two possibel ways to merge data
###1. adding rows 
###2. adding columns

###adding rows to each other is not difficult, assuming all the variables are the same
###ex. two experiment datasheets taken at different time periods
###row binding datasets with different columns is messy, you may want to first ask why?

#some fake data
mydata1 <- data.frame(var1=1:3, var2=5:7, var3=11:13)
mydata2 <- data.frame(var1=4:6, var2=8:10, var3=17:19)

#these data have the same variable names in the same order, so....
rbind(mydata1, mydata2)
mydata3 <- rbind(mydata1, mydata2)


##the second way to merge is to add to dataset together that have different variables
##but have some common variables, such as species, treatment factor etc.
## this is 'glueing datasets" side by side
## in this case there should be some 'matched' variables in the 2 datasets

#Here we use the 'merge' function but you have to PAY ATTENTIOn to what is going on
?merge()

data1 <- data.frame(unit=c("x","x","x","y","z","z"),Time=c(1,2,3,1,1,2))
data2 <- data.frame(unit=c("y","z","x"), height=c(3.4,5.6,1.2))

#here we have datasets that share the variable 'unit'. Notice that they have different lengths

merge(data1, data2, by='unit')
#since both dataframes have all the levels of 'unit' the merge is easy....
#but notice that it assigns the same 'height' to each level of time for units x,y & z


###it is possible that your 'by' variable as a differnt name, e.g. 'unit' & 'item'
###you can still merge:
merge(data1, data2, by.x="unit", by.y="item")
##but lets avoid this headache by being diligent with our variable names!!!!!!!



###You can also merge two dataframes with multiple  variables
###two dataframes have measurements on the same units at some of the the same times, but on
###different variables:

data3 <- data.frame(unit=c("x","x","x","y","y","y","z","z","z"),
                      Time=c(1,2,3,1,2,3,1,2,3),
                      Weight=c(3.1,5.2,6.9,2.2,5.1,7.5,3.5,6.1,8.0))

data4 <- data.frame(unit=c("x","x","y","y","z","z"),
                    Time=c(1,2,2,3,1,3),
                    Height=c(12.1,24.4,18.0,30.8,10.4,32.9))

combdata <- merge(data3, data4, by=c("unit","Time"))
#this looks different from the previous merge.....
# By default, only those times appear in the dataset that have measurements
# for both Weight (data1) and Height (data2)


##That may not be what you want.  You may want to see all possible combinations,
##where you took the data or not
## so.......

merge(data3, data4, by=c("unit","Time"), all=TRUE)
#know you have all possible rows of the merge, some are just 'NA'


###PRACTICE with the traits datasets, which I have split

traits_leaf <- traits[,1:9]
traits_cholor <- traits[,c(3,5,10:11)]
#inspect the data and use the appropirate variablesto merge

