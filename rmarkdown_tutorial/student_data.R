
data1 <- read.csv("raw_data/class_data.csv")
  
data2 <- 
  
  
alldata <- 
  
  

#We want to be able to make some comparison between some of our categorical factor levels
#and numerical data
  
##lets look at spirit animal....
##in its current state, it is not very useful 
##but what if we group different animals into 'types' (mammals/reptiles or land/aquatic/air)

  
##for this we can use the ifelse function to to make a new vairable based on a logical test
?ifelse()
ifelse(test, yes, no)

levels(data1$spirit_animal)

#here we classlify 'mammals" and anything that is not a mammal is "missing"
data1$spirit_type <- ifelse(data1$spirit_animal %in%
                              c("dog", "elephant", "giraffe", "mouse", "otter", "sloth", 
                                "squirrel_flying", "wolf"), 
                              "mammal", 
                              "missing")

#next we add 'reptiles' BUT we no longer use 'missing', that would reset the mammal group
#we leave all others as they are...
data1$spirit_type <- ifelse(data1$spirit_animal %in% c("turtle_land", "turtle_sea"), 
                            "reptile", 
                            data1$spirit_type)

#you can repeat this until you have made all your groups

##now test
which(data1$spirit_type == "missing")
#that fine, those where missing

##we need to check the str of spirit_type
str(data1$spirit_type)

#lets make is a factor for plotting/stats
data1$spirit_type <- as.factor(data1$spirit_type)
#all done!!!