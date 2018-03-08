# convert to date/time and retain as a new field
precip.boulder$DateTime <- as.POSIXct(precip.boulder$DATE, 
                                      format="%Y%m%d %H:%M") 
# date in the format: YearMonthDay Hour:Minute 

# double check structure
str(precip.boulder$DateTime)

# histogram - would allow us to see 999.99 NA values 
# or other "weird" values that might be NA if we didn't know the NA value
hist(precip.boulder$HPCP)

Looking at the histogram, it looks like we have mostly low values (which makes sense) but a few values up near 1000 -- likely 999.99. We can assign these entries to be NA, the value that R interprets as no data.

# assing NoData values to NA
precip.boulder$HPCP[precip.boulder$HPCP==999.99] <- NA 

# check that NA values were added; 
# we can do this by finding the sum of how many NA values there are
sum(is.na(precip.boulder))



nCLIMDIV <- read.csv("climate_co.txt", header = TRUE)

#add a day of the month to each year-month combination
nCLIMDIV$Date <- paste0(nCLIMDIV$YearMonth,"01")

#convert to date
nCLIMDIV$Date <- as.Date(nCLIMDIV$Date, format="%Y%m%d")

# check to see it works
str(nCLIMDIV$Date)

#view summary stats of the Palmer Drought Severity Index
summary(nCLIMDIV$PDSI)

#view histogram of the data
hist(nCLIMDIV$PDSI,   # the date we want to use
     main="Histogram of PDSI",  # title
     xlab="Palmer Drought Severity Index (PDSI)",  # x-axis label
     col="wheat3")  #  the color of the bars


###look for nodata holders in each file.  Replace these with NA (often -999.99)



##discharge
#import data
discharge <- read.csv("disturb-events-co13/discharge/06730200-discharge_daily_1986-2013.txt",
                      sep="\t",
                      skip=24,
                      header=TRUE,
                      stringsAsFactors = FALSE)

cubic feet per second (Mean)

#view first few lines
head(discharge)

# number of rows. 
discharge <- discharge[2:nrow(discharge),]


discharge/06730200-discharge_daily_1986-2013.txt

We now have an R object that includes only rows containing data values. Each column also has a unique column name. However the column names may not be descriptive enough to be useful - what is X17663_00060_00003?.

Reopen the discharge/06730200-discharge_daily_1986-2013.txt file in a text editor or browser. The text at the top provides useful metadata about our data. On rows 10-12, we see that the values in the 5th column of data are "Discharge, cubic feed per second (Mean)". Rows 14-16 tell us more about the 6th column of data, the quality flags.

Now that we know what the columns are, let's rename column 5, which contains the discharge value, as disValue and column 6 as qualFlag so it is more "human readable" as we work with it in R.

#view names
names(discharge)

#rename the fifth column to disValue representing discharge value
names(discharge)[4] <- "disValue"
names(discharge)[5] <- "qualCode"

#view names
names(discharge)

# view class of the disValue column
class(discharge$disValue)

# convert column to integer
discharge$disValue <- as.integer(discharge$disValue)

str(discharge)

#view class
class(discharge$datetime)

#convert to date/time class - POSIX
discharge$datetime <- as.POSIXct(discharge$datetime)

#recheck data structure
str(discharge)