###(2) Using 'data2.csv' make a boxplot/boxplots that summarizes the fuel efficiency of different 
###cars based on the number of engine cylinders (hwy/city)

cars <- read.csv("rmarkdown_tutorial/data/data2.csv")

par(mar=c(4,4,1,1))
boxplot(cty~ cyl, data=cars, xlab = "Engine Cylinders (#)", ylab= "City Fuel Efficiency (mpg)",
        ylim=c(0, 40), outline=FALSE)

boxplot(hwy~ cyl, data=cars, xlab = "Engine Cylinders (#)", ylab= "Highway Fuel Efficiency (mpg)",
        ylim=c(0, 40), outline=FALSE)
