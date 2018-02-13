#read in student data
student1 <- read.csv("student_data/class_data.csv")
student2 <- read.csv("student_data/class_data2.csv")

str(student1)
str(student2)

class_data <- merge(student1, student2, by='student', all=TRUE)

write.csv(class_data, "student_data/student_data.csv", row.names = FALSE)
