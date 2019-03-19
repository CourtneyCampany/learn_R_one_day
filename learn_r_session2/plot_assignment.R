### Learn R assignment #1

### All figures should be of publication quality
  ### use help files if you get stuck
  ### Post any questions or helpful code on slack



### all data sets are in your raw data folder



###(1) Using the 'flowers.csv' dataframe, make a figure with raw data points 
###    add a regression line
###    distinguish between 'Species" on your Figure

flowers <- read.csv("raw_data/flowers.csv")

###(2) Using 'car_mpg.csv' make a boxplot/boxplots that summarizes 
###    the fuel efficiency of different cars (both hwy & city)
###    based on the number of engine cylinders 
###    par(mfrow = c(1,2)) will allow you to put to plots together (give it a try)

cars <- read.csv("raw_data/car_mpg.csv")


###(3) Using 'star_wars.csv' explore the relationship between height and mass 
###    of Stars Wars characters that reside on planets 'Tatooine' and 'Naboo'. 
###    Distinguish between both the homeworld and species of each character. 
###    Please make sure height and mass are presented in metric units.

starwars_chars <- read.csv("raw_data/data3.csv")



