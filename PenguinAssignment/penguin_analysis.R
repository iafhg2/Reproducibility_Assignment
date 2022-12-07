## ---------------------------
##
## Script name: run_penguin_analysis.r
##
## Purpose of script: 
##     a) Loads penguin data and cleans it
##     b) Test assumptions of one-way ANOVA
##     b) Runs a one-way ANOVA and Tukey HSD to test whether culmen (bill) length differs significantly between species
##     c) Plots figure displaying culmen length in each species, with results from the statistical tests
##     d) Saves final figure and statistical output
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



# 1. Initial setup  ----------------------------------------------------------------

# Set the working directory to the downloaded folder "PenguinAssignment".

# Loading the packages:
source("functions/libraries.r")

# Load functions from my files (roles of each function will be explained as they are used)
source("functions/cleaning.r")
source("functions/plotting.r")
source("functions/statistics.r")




# 2.  Load the data -------------------------------------------------------

# Data was originally published by Gorman et al., 2014.
penguins_raw <- read.csv("data_raw/penguins_raw.csv")




# 3. Cleaning data ---------------------------------------------

# Novel functions in this section are defined in file 'cleaning.r'

# Clean column names, remove empty rows, and remove columns called 'comment' and 'delta'
penguins_cleaner <- cleaning(penguins_raw)

# Decapitalise the 'Penguin' in Adelie, so that it is lowercase like in the other species:
penguins_clean <- correct_Adelie(penguins_cleaner)

# Subset the data to only include the penguins that are not NA for the culmen length:
penguins_culmen <- remove_empty_culmen_length(penguins_clean)

# Save the cleaned data:
write.csv(penguins_clean, "data_clean/penguins_clean.csv")




# 4. Testing assumptions of one-way ANOVA -------------------------------------------------

# Novel functions in this section are defined in file 'plotting.r'

# A) Testing for normality

# Plot a quick histogram of culmen length as a visual check for normality:
culmen_hist <- plot_culmen_hist(penguins_culmen)
culmen_hist
# Distribution looks roughly normal within each species - perhaps edging towards bimodality in Chinstrap & Gentoo.

# Plotting a qqplot as a check for normality:
culmen_qqplot<- plot_culmen_qqplot(penguins_culmen)
culmen_qqplot
# Again, the data seems normally distributed within each species


# B) Testing for equal variances

# Visual check of equal variances by plotting a boxplot
culmen_boxplot <- plot_culmen_boxplot(penguins_culmen)
culmen_boxplot
# Variance of culmen length appears to be roughly equal in each species - perhaps a bit larger in Chinstrap penguins.

# Use bartlett test:
bartlett.test(culmen_length_mm ~ species, data=penguins_culmen)
# p value = 0.06027
# Variances in culmen length are not significantly different between species (at alpha = 0.05);
# however, they are on the borderline of significance.

# Nonetheless, one-way ANOVA is considered relatively robust to non-equal variances.
# Thus, a one-way ANOVA is still suitable.





# 5.  Statistical analyses --------------------------------------------------

# Novel functions in this section are defined in file 'statistics.r'

# Generating a linear model and checking its summary:
summary_culmenlm<- summarise_culmenlm(penguins_culmen)
summary_culmenlm

# Coefficients: there's an average 10mm difference in culmen length between Adelie and Chinstrap penguins, 
# and an average 8mm difference between Adelie and Gentoo penguins.
# Multiple R squared is 0.7078 - species explains 70.8% of variance in culmen length,
# indicating strong biological significance of the variable species

#Performing a one-way one-way ANOVA to compare the effect of species on culmen length:
anova_results <- anova_culmen(penguins_culmen)
anova_results

# There is a highly significant difference in culmen length between at least two species 
# (One-way ANOVA; F(2, 33) = [410.6], p < 2.2e-16).

# Running a Tukey HSD test to see which species differ significantly:
tukey_results <- tukeyHSD_culmen(penguins_culmen)
tukey_results

# Tukey’s HSD Test for multiple comparisons found a significant difference between all three species
# (Adelie vs Chinstrap: p<0.000001, 95% CI = [9.024859, 11.0600064]; 
# Adelie vs Gentoo: p<0.000001, 95% CI = [7.867194, 9.5597807]; 
# Gentoo vs Chinstrap: p=0.0088993, 95% CI = [-2.381868, -0.2760231].)





# 6.  Making the figure ---------------------------------------------------

# Produce a histogram of culmen length in different Penguin Species, displaying the the significance results from TukeyHSD & one-way ANOVA.
# (uses plot_culmen_figure function from plotting.r)
culmen_histogram <- plot_culmen_figure(penguins_culmen)
culmen_histogram
# NB: A box plot would have my preferred method of reporting ANOVA results; 
# however, we were not allowed to use box plots for this assignment.

# CAPTION FOR FIGURE (for use when reported):
## "Fig. 1 - Faceted histogram plot displaying culmen length in different penguin species. 
## Dashed grey line indicates mean culmen length within each species. Significance levels of differences between
## species are given by asterixes, where ** indicates p<0.01 and *** indicates p<0.001 (one-way ANOVA, Tukey HSD).




# 7. Saving the figure and statistical results ------------------------------------------------

# Save the ANOVA results:
write.csv(anova_results, "output/statistics/anova.csv")

# Save the Tukey HSD results:
write.csv(tukey_results, "output/statistics/tukey.csv")

# Save the histogram plot as a png: must define size, resolution and scaling
# (see plotting.r for function definition)
save_culmen_plot_png(penguins_culmen, "output/figures/figure.png", size = 14, res = 600, scaling = 1)

# Save the histogram plot as a vector (svg): must define size and scaling
# (see plotting.r for function definition)
save_culmen_plot_svg(penguins_culmen, "output/figures/figure.svg", size = 14, scaling = 1)




# 8. Saving session information  -------------------------------------------------

# Saving session information:
sink(file = "output/package-versions.txt", )
sessionInfo() 
sink ()   
     