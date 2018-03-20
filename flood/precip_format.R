####precipitation data:-----------------------
rain <- read.csv("flood/data/805333-precip_daily_1948-2013.csv")


# convert to date/time and retain as a new field
rain$DateTime<- as.POSIXct(rain$DATE,format="%Y%m%d %H:%M") 


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

sum(is.na(rain))
hist(rain$HPCP)

write.csv(rain, "flood/data/rain_co.csv", row.names = FALSE)


