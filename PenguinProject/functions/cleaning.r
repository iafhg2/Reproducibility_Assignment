## ---------------------------
##
## Script name: cleaning.r
##
## Purpose of script: define 'cleaning' function
##
## Author: ANONYMOUS
##
## Date Created: 2022-11-30
##
##
## Notes:
##   
##
## ---------------------------


# 'cleaning' function: cleans column names, removes empty rows, and removes columns called comment and delta
cleaning <- function(data_raw){
  data_raw %>%
    clean_names() %>%
    remove_empty(c("cols", "rows")) %>%
    select(-comments) %>%
    select(-starts_with("delta"))
}


# 'correct_Adelie' function: decapitalises the 'Penguin' in Adelie, so that it is lowercase like in the other species:
correct_Adelie <- function(data){
  data1 <- data
  data1$species <- str_replace(data$species, pattern = "Penguin", replacement = "penguin")
  data1
}
  

# 'remove_empty_culmen_length' function: subsets the data to only include the penguins that are not NA for the bill length
remove_empty_culmen_length <- function(data_clean){
  data_clean %>%
    filter(!is.na(culmen_length_mm)) %>%
    select(species, culmen_length_mm)
}
