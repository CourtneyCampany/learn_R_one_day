clim_bc <- read.table("flood/data/climate_co.txt", header = TRUE)

head(clim_bc$YearMonth)
## That would make life hard, so lets add a day (01)

#add a day of the month to each year-month combination (new variable)
clim_bc$Date <- paste(clim_bc$YearMonth,"01", sep="")

clim_bc$Date <- as.Date(clim_bc$Date, format="%Y%m%d")

#check for NOdata
summary(clim_bc$PDSI)
hist(clim_bc$PDSI)

write.csv(clim_bc, "flood/data/climate_co.csv", row.names = FALSE)

