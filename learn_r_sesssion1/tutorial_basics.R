##Tutorial with Fern data



# install R (R cran) and R studio for FREE-----------

# setup R studio in a convienent way (tools:global options:pane layout)

# 1. source is where most of your work goes, you will write scripts here

# 2. console is a tool to perform quicker options you likely dont want to save
#    type date() in the console

# 3. environment allows you to see what you currently have loaded 
#    (datasets, objects, etc.)



# Projects -----------

#  skipping a lot of intro steps to learn the ease of using Rprojects 
#  just like a pc desktop - folder based system

#  start a new project: top right corner and call it "r_workshop"

#  go ahead and setup folders for raw_data, scripts, functions, output, etc..

# IMPORTANTLY your working directory starts in the project (super easy)
#  What is the working directory (where you are located on your computer)
#  getwd() and setwd()



# R basics -----------

# comment with at least one # 
# (no code will be run, useful for making notes)

# R works as a calculator (these operations will print in console)

# Arithmetic
12 * (10 + 1)

# pi is a built-in constant
sin(pi/2)

# Absolute value
abs(-10)

# Square root
sqrt(225)

# Exponents
15^2


# First script -----------

# what is a script? A text file with code that allows for reproducibility

# scripts will/should be saved with .R extenstion (i.e. tutorial.R)



# OBJECTS -----------

# objects make the scripting world go round. 
# They are name variables that can hold different values.  
# Can be a single value, many values or a whole dataset!

# lets make a few: define them and set them equal to something with "<-"
# hit ctrl+enter(or run) and watch them appear in global environment
# once they are in the environment you can reuse them 
# until you quit R or clear environment) 

x <- 23  # get really used to typing <-
y <- -15

#do some calculations: 

x+y

z <- x*2 + y^2

# rewrite a new 'x':

x <- "I am sooo awesome"
message(x)



# VECTORS -----------

# vector = a string of numbers or bits of text 
# The power of R is that most functions can use a vector directly as input

#we use c() to ’concatenate’ (link together) a series of numbers
nums1 <- c(1,4,2,8,11,100,8)

# Get the sum of a vector:
sum(nums1)

# Get mean, standard deviation, number of observations (length):
mean(nums1)
sd(nums1)
length(nums1)

# how would you reuse or save the output of one of these operations??????
cs_nums1 <- cumsum(nums1) # cumulative sum as new object

# vectorized operations: perform operations on multiple vectors

# results in another vector
# operation on one elements of the vector at a time)

nums1 * y
nums1^2

# calculations with two vectors of same length
nums2 <- c(7,11,12,8,14,10,80)

# pairwise calculations
nums1/nums2

# there are many logical functions to apply to vectors 
# each are key to learn
# Page 18 in manual
length(nums1)
sort(nums1)
order(nums2)
head(nums2)
tail()
unique()
round(nums2, digits=2)

which.max(nums1)
max(nums1) #note the difference 
# one is the value the other is the location in the vector)

which.min()
min()
var()

# if you need to dig deeper look at the help file
?mean() #type in the console 
# mean function has an option to remove missing values if they exists
# the default is to stop working if it encounters a 'NA', we can change this:
mean(nums2, na.rm=TRUE)


# you can use multiple functions in one line of code: 

# Mean of the vector, *then* square it:
mean(nums1)^2

# Mean of the log of vec2:
mean(log10(nums1))

# The sum of squared deviation from the sample mean:
sum((nums1 - mean(nums1))^2)

# The sample variance:
sum((nums1 - mean(nums1))^2) / (length(nums1) - 1)

# How would you calculate the SE of vec1????
sd(nums1)/sqrt(length(nums1))

# vectors can be characters too
# useful for making objects for plotting labels and colors
mycols <- c("red","forestgreen","cornflowerblue","gold","pink")
sort(mycols)
nchar(mycols)

#extract one element of any vector
mycols[3]




# Creating Data -----------

# we can use c() to ’concatenate’ (link together) a series of numbers
nums3 <- c(nums1, nums2)

# generate sequences of numbers and words is easy and useful
 
# 1. Sequences of integer numbers using the ":" operator:
  1:10 # Numbers 1 through 10

# 2. Examples using seq()
seq(from=1,to=67,by=8)

    #can use with letters too
    str(letters)
    letters[]
    LETTERS[seq( from = , to =  )]

# what are the inner bits of seq()?  lets look at help
?seq() #there should always be working examples at the bottom of the help page

# 3. Replicate 
rep(2, times = 10)
rep(c(4,5), each=3)
?rep()
legendcols <- c(rep("blue", 4), "black", rep("yellow", 4))

# 4. generate random numbers using the runif function. 
# draws from a uniform distribution,
# meaning there is an equal probability of any number being chosen.

runif(10)

plot(runif(1000))

# Lots of random numbers between 100 and 1000
a <- runif(425, 100, 1000)




# workspace quickies -----------

ls() #what is loaded in your environment, can also just look
rm(a) #delete objects




# learn how to read in dataframes -----------

# in R we mostly use csv.files, which are just 1 sheet excel files
# you need to tell R to read in the file and where it is located:

mydata <- read.csv("pathtofile.csv")

# read.csv() is the most common function, which everyone uses
# ?read.csv() shows lots of options, but the defaults are mostly fine
# we have to tell it a file path.....in Rprojects this is super easy

traits <- read.csv("raw_data/fern_traits.csv")
# setup your project to have a raw_data folder
# put the data file in there manually

# read in the dataframe and save it as an object (you choose the name)
# the 'traits' object is a dataframe (rows + columns)
# just one more dimension (rows) added to the vector format

# Always inspect your data first!!!!
# Do these operations in console (not in script)

traits
head(traits) #first 6 rows (good to see that nothings is broken)
str(traits) #inspection of variables
summary(traits) #base level stats

# count of the number of rows and columns
nrow(traits)
ncol(traits)

# we can also make dataframes ourselves:
newdata <- data.frame(coolnums=nums1, coolnums=nums2) 

# here coolnums & coolnums are the column/variable names
colnames(newdata)

rm(newdata)

# Working with data -----------

# (1) Read in (2) Inspect (3) Clean (4) Format 
# (5) Manipulate (6) write, analyze and visualize

# column names
names(traits) #you often need to rename variable names

  
# rename first vairable
names(traits)[1] <- "Location"

# rename 1st and 2nd:
names(traits)[1:2] <- c("Place","Date") 



#INDEXING (super mega very important) ****PAY ATTENTION***** -----------

# Individual elements of a vector can be extracted using square brackets [ ]

nums1[1:3]

# Select a few elements of a vector (reusable)
selectthese <- c(1,5,7)
nums1[selectthese]
nums2[selectthese]

# Remove the first element:
nums1[-1]
newnums1 <- nums1[-1]

#logical indexing (almost endless possibilities)

nums2[nums2 > 10]
nums2[nums2 >= 11]
nums1[nums1 == 8] #note the use of "=="

nums2[nums2 > 5 & nums2 < 10] #two arguments together
nums2[nums2 < 8 | nums2 > 20] #either 

nums1[nums1 != 100] #does not equal

nums1[nums1 %in% c(1,4,11)] #includes
legendcols2 <- legendcols[! legendcols %in% "black"]

nums2[nums2 > 10 & !nums2 == 80]


# For dataframes we have 2 dimensions [rows,columns] 
# in the beginning you will forget the comma often

traits[4,4] #the value for the 4th row in the 4th column
traits[,3]  # all rows of the 3rd column

traits[1:5, 4:7] #use variable name
traits[1:5, c("species", "plant_no", "frond_length_cm")]

# common error:
traits[1:5, stipe_length_cm] #object not found = you need quotations

# chorophyll content of largest leaf 
traits[which.max(traits$lamina_area_cm2) , "chl_mg_m2"] 

# new dataframe of chlorophyll data
fern_chl <- traits[, c(1:5, 10)] 

# dataframe with chlorophyll content of only epiphytes
levels(traits$niche)
chl_epi <- traits[traits$niche=="epiphyte", 
                  c("plant_no", "chl_mg_m2", "niche")]

str(traits)
traits_nochl <- traits[,-10] #new dataframe without chl variables

# one dimensional index with dataframe
highchlspecies <- unique(droplevels(traits$species[traits$chl_mg_m2 > 700]))
# you could use this object to index another dataset


# subsetting (can use subset function but better to learn to index)
?subset()
# read about it and practive in R manual if you want




##EXPORTING new data -----------

#now that we made new dataframes (datasets)...we can save them for later use

write.csv(traits_nochl, "working_data/cholorphyll.csv", row.names = FALSE)
#just like read.csv, but in reverse
?write.csv()

# good data science practices : 
#     (1) NO spaces in file/variable names
#     (2) use lowercase as much as possible (efficiency)
#     (3) always always always keep raw data intact !!!!!!!!
#     (4) I make a folder for new data = "working_data"



