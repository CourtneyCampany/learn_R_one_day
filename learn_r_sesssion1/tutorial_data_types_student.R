#working with dataframes

traits <- read.csv("raw_data/fern_traits.csv")


# data classes -----------

# Variables have different classes: all of which are important:

# numeric, character, factor(categorical), logical, date, POSIXct (date+time)

str(traits)

#R tries to assign character classes at factors 
# you can always set or change them yourself)

str(traits$site)

traits$site <- as.character(traits$site)
traits$site <- as.factor(traits$site)

levels(traits$niche) #factor levels are important (zeros, deleting data)

# table function is a nice way to summarize or double check factor levels
table(traits$niche)

#if you delete a factor in your dataframe all the factors levels will remain
epi_dat <- traits[!traits$niche == "terrestrial",]

levels(epi_dat$niche) #this can be very important for stats

epi_dat2 <- droplevels(epi_dat) #if you want it really gone.
levels(epi_dat2$niche)




#Manipulating data -----------

#1. Combining character vectors (columns) with paste()

dfr$newvar <- paste(dfr$co2, dfr$light, sep="-") #this is the format, 
?paste()

#lets pretend that we had different sites for the traits dataset
traits$id <- 
  
#or use with()
  
traits$id2 <- with(traits, paste("site", "niche", sep="."))

#another useful function is gsub() for formatting (find and replace)
?gsub()

#make a new variable species2, replace the '-' with a space
traits$species2 <- 


traits$genus <- as.factor(gsub("_.*","", traits$species)) 
# uses regular expression for complex patterns in strings
# this code removes everything after "_"
# when requiring regular expression, consult Google


#2, make new variables (often for unit conversions)
traits$laminalength_m <- 


#3.changing variable classes

#for example: you have 2 CO2 treatments which are read as numeric
newdata <- data.frame(co2 = c(rep(415, 15), rep(650, 15)),
                      photosynthesis = runif(30, min=10, max=20))

newdata$co2 <- 


#4. DATES: there is a standard format for dates with coding:
# "1969-08-18 09:00:00"
# most of the time we forget to do this because we are AMERICAN!!!
# R often classifies our Date column as factor

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

max(traits$date) - min(traits$date) 


# missing values -----------

# missing values are represented with NA,
# indicates that data is simply 'Not Available'.

myvec1 <- c(11,13,5,6,NA,9)
mean(myvec1) #functions may not work with missing values, check help file
mean(myvec1, na.rm=TRUE)

#super useful to check your data...
is.na(myvec1)
which(is.na(myvec1))

is.na(traits)
which(is.na(traits))

#if you want the dataframe with only rows that have no missing values 
#  BE CAREFUL
traits_nona <- traits[complete.cases(traits),] #this really deletes data!!!!


