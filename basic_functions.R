# functions to re-use

se <- function(x) sd(x)/sqrt(length(x))

se_na <- function(x) sqrt(var(x,na.rm=TRUE)/length(na.omit(x)))
mean_na <- function(x) mean(x, na.rm=TRUE)