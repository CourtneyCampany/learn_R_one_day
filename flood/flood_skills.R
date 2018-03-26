
####precipitation data:-----------------------
rain <- read.csv("flood/data/805333-precip_daily_1948-2013.csv")


# convert to date/time and retain as a new field
rain$DateTime <- as.POSIXct(rain$DATE,format="%Y%m%d %H:%M") 
  # date in the format: YearMonthDay Hour:Minute 
  # double check structure
  str(rain$DateTime)


####check for NOdata values
  
# histogram - would allow us to see 999.99 NA values 
# or other "weird" values that might be NA if we didn't know the NA value
hist(rain$HPCP)
#Looking at the histogram, it looks like we have mostly low values 
#(which makes sense) but a few values up near 1000 -- likely 999.99. 
#We can assign these entries to be NA, the value that R interprets as no data.
range(rain$HPCP)
# assing NoData values to NA
rain$HPCP[rain$HPCP==999.99] <- NA 

# check that NA values were added; 
# we can do this by finding the sum of how many NA values there are
sum(is.na(rain$HPCP))

write.csv(rain, "flood/data/rain_co.csv", row.names = FALSE)


##Discharge data:-------------------------------------------------------------
#import data
discharge <- read.csv("flood/data/06730200-Discharge_Daily_1986-2013.csv")

#view first few lines
head(discharge)
#view names
names(discharge)

###disvalue units: Discharge, cubic feet per second (Mean)
###we are not cool with feet so lets convert & make a label
dislab <- expression()


#Convert datetime:
class(discharge$datetime)
head(discharge$datetime) ##we will need to format so lets search:
?as.Date

discharge$Date <- as.Date(discharge$datetime, format="%m/%d/%y")

#recheck data structure
str(discharge)

##check for NOdata:
hist(discharge$disValue)


plot(disValue ~ Date, data=discharge, col="dodgerblue", pch=16)


### Drought data:  we have a new data type (text file)----------------------
clim_bc <- read.table("flood/data/climate_co.txt", header = TRUE)

##we have a funky date variable (YearMonth)
head(clim_bc$YearMonth)
## That would make life hard, so lets add a day (01)

#add a day of the month to each year-month combination (new variable)
clim_bc$Date <- paste(clim_bc$YearMonth,"01", sep="")

#convert to date
clim_bc$Date <- as.Date(clim_bc$Date, format="%Y%m%d")
# check to see it works
str(clim_bc$Date)
range(clim_bc$Date)

#view summary stats of the Palmer Drought Severity Index, check for NOData
summary(clim_bc$PDSI)
hist(clim_bc$PDSI)

write.csv(clim_bc, "", row)


###Now: Investigate the rest of the variables by reading the divisional-readme.txt
###There are standard climate variables as well as several indexes
###Can you use the SPxx variables to help with your story

