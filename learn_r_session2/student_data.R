
data1 <- read.csv("student_data/class_data.csv")
  
data2 <- read.csv("student_data/class_data2.csv")
  
  
data <- merge(data1, data2)

write.csv(data, "student_data/classdata.csv", row.names = FALSE
          )
