## ---------------------------
##
## Script name: statistics.r
##
## Purpose of script: define functions for statistical analysis
##
## Author: ANONYMOUS
##
## Date Created: 2022-12-1
##
##
## Notes:
##   
##
## ---------------------------


# 'summarise_culmenlm': generates a linear model (culmen vs species) and then gives the summary of the model
summarise_culmenlm <- function(penguins_culmen) {
  culmen_model<- lm(culmen_length_mm ~ species, penguins_culmen)      #first creates a linear model; culmen length is response variable, species is dependent variable
  summary(culmen_model)                                               # then gives a summary of the model
}



# 'anova_culmen': carries out a one-way ANOVA to test if culmen length differs significantly between species
anova_culmen <- function(penguins_culmen) {
    culmen_model<- lm(culmen_length_mm ~ species, penguins_culmen)      #first creates a linear model; culmen length is response variable, species is dependent variable
    anova(culmen_model)                                                 # then carries out ANOVA on linear model
}



#'tukeyHSD_culmen': carries out a Tukey HSD to see which species differ significantly in their culmen length

tukeyHSD_culmen <- function(penguins_culmen) {
  culmen_model<- lm(culmen_length_mm ~ species, penguins_culmen)        # first creates a linear model; culmen length is response variable, species is dependent variable
  tukey_results <- TukeyHSD(aov(culmen_model))                          # then carries out Tukey HSD on linear model
  tukey_results1 <-as.data.frame(tukey_results[1:1])                    # turns it into a data frame so we can save it as a csv later
}

