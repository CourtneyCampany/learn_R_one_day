traits <- read.csv("raw_data/fern_traits.csv")

# summarizing data --------------------------------------------------------

#probably my most used package is "doBy" which is great for data summaries

library(doBy)
#summaryBy(Yvar1 + Yvar2 ~ Groupvar1 + Groupvar2, FUN=c(mean,sd), data=mydata)

chl_agg <- summaryBy(chl_mg_m2 ~ species + niche, FUN=mean, data=traits)

traits_agg <- summaryBy(chl_mg_m2 + frond_length_cm + lamina_area_cm2 ~ 
                          niche, FUN=mean, data=traits)

#if you only have one FUN, you can add keep.names to not alter variable names (BE CAREFUL)
species_agg <- summaryBy(chl_mg_m2 + frond_length_cm + lamina_area_cm2 ~ 
                           species, FUN=mean, data=traits, keep.names = TRUE)

##this function is pretty smart too, so you apply to all variables
## assuming your factors are properly assigned
traits_agg2 <- summaryBy(. ~ species + niche, FUN=mean, data=traits, keep.names = TRUE)

#if we add more FUN, we very likley need to get rid of any missing values
traits_nona <- traits[complete.cases(traits),]


##first function!!! A way to automate repeated processes 
se <- function(x) sd(x)/sqrt(length(x))

traits_summ <- summaryBy(. ~ species + niche,
                         data=traits_nona,
                         FUN=c(mean, se))

##we can save this summary dataframe to make a table later...we didnt do it super clean
##so lets use what we have learned to get rid of plant_no_mean
str(traits_summ)
fernsumm <- traits_summ[, -c(3, 10)]

write.csv(fernsumm, "output/fern_traits_summary.csv", row.names = FALSE)

