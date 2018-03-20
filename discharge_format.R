#import data
discharge <- read.csv("flood/data/06730200-Discharge_Daily_1986-2013.csv")

#view first few lines
head(discharge)
#view names
names(discharge)

###unit conversion of discharge
discharge$disval_m<- discharge$disValue*0.0283168

###disvalue units: Discharge, cubic feet per second (Mean)
###we are not cool with feet so lets convert & make a label
dislab <- expression(Stream~Discharge~~(m^3~s^-1))

#date formatting
class(discharge$datetime)
head(discharge$datetime) ##we will need to format so lets search:
?as.Date

discharge$Date <- as.Date(discharge$datetime, format="%m/%d/%y")
str(discharge)

##check for NOdata:
hist(discharge$disval_m)

plot(disval_m ~ Date, data=discharge, col="dodgerblue", pch=16)

write.csv(discharge, "flood/data/discharge_co.csv", row.names = FALSE)


