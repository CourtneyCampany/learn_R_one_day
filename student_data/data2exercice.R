##read in full dataset

classdata <- read.csv("student_data/student_data.csv")

plot(snapchat ~ instagram, data=instasnap)

instasnap <- classdata[classdata$instagram >0 & classdata$snapchat >0, 
                       c("snapchat", "instagram")]

test <- classdata[,c("snapchat", "instagram")]
rm(test)

str(classdata$clumsiness)
classdata$clumsiness <- as.numeric(classdata$clumsiness)


#here we classlify 'mammals" and anything that is not a mammal is "missing"
classdata$spirit_type <- ifelse(classdata$spirit_animal %in%
                              c("dog", "elephant", "giraffe", "mouse", "otter", "sloth", 
                                "squirrel_flying", "wolf"), 
                                "mammal", 
                                "missing")

#next we add 'reptiles' BUT we no longer use 'missing', 
#that would reset the mammal group
#we leave all others as they are...
classdata$spirit_type <- ifelse(classdata$spirit_animal %in% c("turtle_land", "turtle_sea"), 
                            "reptile", 
                            classdata$spirit_type)

which(classdata$spirit_type == "missing")
classdata$spirit_type <- as.factor(data1$spirit_type)

str(classdata)

merlab <- "Merperson potential (s)"

windows()
boxplot(merperson_potential_sec ~ food_pref, data=classdata, ylab=merlab)



classdata2 <- classdata[classdata$snapchat <= 45,]
