#litter data

litter <- read.csv("FACE/data/face_litter.csv")
  litter$Date <- as.Date(litter$Date, format= "%d/%m/%Y")
  litter$year <- as.factor(lubridate::year(litter$Date))

litter_agg <- doBy::summaryBy(twig + bark+ seed + leaf ~ year, data=litter, FUN=sum, na.rm=TRUE)

new_sum <- function(x) {sum(x, na.rm=TRUE)}

litter_agg2 <- doBy::summaryBy(twig + bark+ seed + leaf ~ year, data=litter, FUN=new_sum)

