##tutorial with Fern data

#install R (R cran) and R studio for FREE

#setup R studio in a convienent way (tools:global options:pane layout)
#1. source is where most of your work goes, you will write scripts here
#2. console is a tool to perform quicker options you likely dont want to save
## console also prints output of code you run in source
#3. environment allows you to see what you currently have loaded (datasets, objects, etc.)

# R basics ----------------------------------------------------------------
##comment with at least one # (no code will be run, useful formaking notes or stopping code)

##R works has a calculator (these operations will prin in console)

# Arithmetic


# pi is a built-in constant


# Absolute value


# Square root


# Exponents


# Projects ----------------------------------------------------------------

##skipping a lot of intro steps to learn the ease of using Rprojects 
## just like a pc desktop - folder based system

##go ahead and setup folders for raw_data, scripts, functions, output, etc..

##IMPORTANTLY your working directory starts in the project (super easy)
## What is the working directory (where you are located)
## getwd() and setwd()


# First script ------------------------------------------------------------

#what is a script? A text file with code that allows for reproducibility

#Scripts should be saved with .R extenstion (i.e. tutorial.R)
#will work autmatically when you save


# OBJECTS -----------------------------------------------------------------

#objects make the scripting world go round. They are name variables that can hold
# different values.  Can be a single value, many or a whole dataset!

#lets make a few: define them, hit ctrl+enter(or run) and watch them appear in environment
#once they are in the environment you can reuse them (until you quit R or clear environment) 
#use  "<-"



#do some calculations



#rewrite a new 'x':



# VECTORS -----------------------------------------------------------------

#vector is a string of numbers or bits of text (but not a combination of both). 
#The power of R is that most functions can use a vector directly as input



# Get the sum of a vector:


# Get mean, standard deviation, number of observations (length):





#how would you reuse or save the output of one of these operations??????

# cumulative sum as new object

##Vectorized operations: perform operations on multiple vectors
##results in another vector (operation on one elements of the vector at a time)



#calculations with two vectors of same length


#pairwise calculations


#there are so many logical functions to apply to vectors which are key to learn
length()
sort()
order()
head()
tail()
unique()
round()
which.max()
max() #note the difference (one is the value the other is the location in the vector)
which.min()
min()
mean()
var()
sd()

##you can use multiple functions in one line of code: 

# Mean of the vector, *then* square it:


# Mean of the log of vec2:


# The sum of squared deviation from the sample mean:


# The sample variance:


###How would you calculate the SE of vec1????


##remember vectors can be characters too...useful for plotting labels and colors




#extract one element of a vector


# making data -------------------------------------------------------------

# we can use c() to ’concatenate’ (link together) a series of numbers


#generate sequences of numbers using (1) : (2) seq and  (3) rep 
 
# Sequences of integer numbers using the ":" operator:
1:10 # Numbers 1 through 10

# Examples using seq()


##what are the inner bits of seq()?  lets look at help
?seq()

# Replicate 
?rep()

# generate random numbers using the runif function. 
# draws from a uniform distribution,
# meaning there is an equal probability of any number being chosen.


# Lots of random numbers between 100 and 1000


##workspace quickies
ls() #what is loaded in your environment, can also just look
rm(x) #delete objects

# learn how to read in dataframes -----------------------------------------------

#in R we mostly use csv.files, which are just 1 sheet excel files
#you need to tell R to read in the file and where it is located:
mydata <- read.csv("pathtofile.csv")
# read.csv() is the most common function, which everyone uses
# ?read.csv() shows lots of options, but the defaults are mostly fine
# we have to tell it a file path.....in Rprojects this is super easy

traits <- read.csv("raw_data/fern_traits.csv")
#set up your project to have a raw_data folder and put the data file in there manually

# read in the dataframe and save it as an object (you choose the name)
# the 'traits' object is a dataframe (rows + columns)
# just one more dimensions added to the vector format

##lets inspect the data several ways (i usally do these operations in console)
traits
head(traits) #first 6 rows (good to see that nothings is broken)
str(traits) #inspection of variables
summary(traits) #base level stats
nrow(traits)
ncol(traits)

#we can also make dataframes ourselves:
newdata <-  #here x & y are the column/variable names
rm(newdata)

# working with data ----------------------------------------------------------

# (1) Read in (2) Inspect (3) Clean (4) Format (5) make calculations, subset, etc.

# column names
names(traits)

names(traits) <- #c("S","D","SP","N","Pno", "g", "h' ")
  
# rename first vairable


# rename 1st and 2nd:


#INDEXING (super mega very important) ****PAY ATTENTION*****---------------------------

#Individual elements of a vector can be extracted using square brackets, [ ]

#[rows,columns] #in the beginning you will forget the comma often



# Select a few elements of a vector (reusable)


# Remove the first element:


#logical indexing (almost endless possibilities)

#since nums1 is a vector (one dimenson) we only need one argument inside brackets


  #two arguments together
  #either 

  #does not equal
  #includes


#subsetting (can use subset function but better to learn indexing)
# read about it and practice in R lab book

#remember = dataframe[rows, columns]

 #the value for the 4th row in the 4th column

#use variable name


#common error:
traits[1:5, stipe_length_cm] #object not found = you need quotations

fern_chl <- traits[, c("site", "niche", "plant_no","chl_mg_m2")] #new dataframe

 #logical indexing at its best

#what is the cholorophyll content of the longest leaf? 
#This is evaluated as the the row number, in the chl column, which has the largest lamina length

#useful example: dataframe with chlorophyll content of epiphytes
levels(traits$niche)
chl_epi <- traits[traits$niche=="epiphyte", c("plant_no", "chl_mg_m2", "niche")]

#new datafrae without chl variables

##EXPORTING:-------------------------------------------

#now that we made new dataframes (datasets)...we can save them for later use

write.csv(chl_epi, "calculated_data/chl_data.csv", row.names = FALSE)
#just like read.csv, but in reverse

# good data science practices : 
#     (1) NO spaces in file/variable ames
#     (2) use lowercase as much as possible (efficiency)
#     (3) always always always keep raw data intact !!!!!!!!
#     (4) I make a folder for new data = "calculated_data"


#classes --------------------------------------------------------------------------

#Variables have different classes: all of which are important
#numeric, character, factor(categorical), logical, date, POSIXct (date+time) are the main ones

str(traits)

#R tries to assign character classes at factors (but you can always do it yourself)

str(traits$site)

traits$site <- as.character(traits$site)
traits$site <- as.factor(traits$site)

 #factor levels are important (zeros, deleting data)


#if you delete a certain factor in your dataframe all the factors levels will still remain

 #this can be very important for stats
 #if you want it really gone.



#Manipulating data-----------------------------------------------------

#1. Combining character vectors (columns) with paste()

?paste()
dfr$trt <- paste(dfr$co2, dfr$wp, sep="-") #this is the format

#lets pretend that we had different sites for the traits dataset



#or use with()



#another useful function is gsub() for formatting (find and replace)
traits$species2 <- gsub("_", " ", traits$species)

traits$genus <- as.factor(gsub("_.*","", traits$species)) #uses regular expression

#2, make new variables (unit conversions are a great example)



#3.changing variable classes

#for example: you have 2 CO2 treatments which are read as numeric
dfr$co2 <- as.factor(dfr$co2)

#4. DATES: there is a standard format for dates with coding:

##: "1969-08-18 09:00:00"

## most of the time we forget to do this and R often classifies our Date column as factor

# Dates simple
sometime <- as.Date("1980-6-19")
str(sometime)

#format date for traits dataframe
head(traits$date)
?as.Date
?strptime



#did it work?
max(traits$date)
str(traits$date)

max(traits$date) - min(traits$date) 

# missing values ----------------------------------------------------------

#missing values are represented with NA,indicating the data is simply 'Not Available'.

myvec1 <- c(11,13,5,6,NA,9)
mean(myvec1) #functions may not work with missing values, check help file
mean(myvec1, na.rm=TRUE)

#super useful to check your data...
is.na()
which(is.na())

is.na()
which(is.na())

#if you want the dataframe with only rows that have no missing values (BE CAREFUL)

traits_nona <- traits[complete.cases(traits),] #this deletes real data too!!!!


