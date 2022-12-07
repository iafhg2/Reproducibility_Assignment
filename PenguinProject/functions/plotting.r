## ---------------------------
##
## Script name: plotting.r
##
## Purpose of script: define plotting function
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



# Defining function "plot_culmen_hist" ----------------------------------
# plots a quick histogram of culmen length to use as a normality check:
plot_culmen_hist <- function(penguins_culmen){
  ggplot(penguins_culmen, aes(x =culmen_length_mm)) +
  geom_histogram(bins = 35) +
  facet_wrap(~species, ncol = 1)
}



# Defining function "plot_culmen_qqplot" ----------------------------------

# Plots a qqplot to test for normality in culmen length:
plot_culmen_qqplot <- function(penguins_culmen){
  penguins_culmen %>% 
ggplot(aes(sample = culmen_length_mm)) +                        # choose culmen length to make the plot
  geom_qq() +                           
  geom_qq_line(colour = "limegreen") +                          # add the qqline
  facet_wrap(~species, ncol = 1)
}



# Defining function "plot_culmen_boxplot" ----------------------------------

# Plots a  box plot of culmen length:
plot_culmen_boxplot <- function(penguins_culmen){
  ggplot(penguins_culmen, aes(y = culmen_length_mm, x = species)) +
geom_boxplot() 
}





# Defining function 'plot_culmen_figure' ----------------------------------

# plots final figure: histogram of culmen length in different Penguin Species. 
# Displays results of ANOVA and Tukey HSD - ie significant differences between culmen length in all three groups

plot_culmen_figure <- function(penguins_culmen){
  
  penguins_culmen2 <- penguins_culmen %>% group_by(species) %>%  mutate(mean = mean(culmen_length_mm))  # calculate mean culmen length for each species
  
  plot1 <-  ggplot(penguins_culmen2, aes (x = culmen_length_mm, fill = species)) +                  # use culmen length for x axis, colour bars by species
    geom_histogram(bins = 35, alpha = 0.7, show.legend = FALSE) +                                   # hide the legend, set transparency of bars to 70%, select 30 bins
    facet_wrap(~species, ncol = 1) +                                                                # put each species in a separate facet, and stack them (ie create 1 column)
    theme_light() +                                                                                 # adjust position of title
    scale_fill_manual(values = c("darkorange","purple","cyan4")) +                                  # choose colours to fit the convention for each penguin
    xlab("Culmen length (mm)") +                                                                    # add axis labels and title:
    ylab("Frequency") +
    labs(title = "Effect of Species on Culmen Length", subtitle = "(ANOVA; Tukey HSD)") +
    theme(plot.title = element_text(hjust = 0, vjust = 1)) +                                      # adjust position of title
    geom_vline(aes(xintercept = mean, group = species), colour = 'gray40', linetype = "dashed")     # finally, add a line to show the mean culmen length for each species
    
  signif_image <- image_read("significance_bars.png")
  plot2 <- ggdraw() + draw_image(signif_image, scale = 1) + ggtitle("   ")                                          # plot significance bars separately
    
  plot_grid( plot1, plot2, rel_widths = c(3.5,1))                                                   # plot significance bars with the histogram plot

}




# Defining function "save_culmen_plot_png" --------------------------------

# Saves the plot as a png - must define the size, resolution, and scaling
save_culmen_plot_png <- function(penguins_culmen, filename, size, resolution, scaling){
  agg_png(filename, width = 1.3*size, 
          res = resolution,
          units = "cm", 
          height = size, 
          scaling = scaling)
  culmen_box <- plot_culmen_figure(penguins_culmen)
  print(culmen_box)
  dev.off()
}



# Defining function "save_culmen_plot_svg": --------------------------------

# Save the plot as a svg and define the size and scaling
save_culmen_plot_svg <- function(penguins_culmen, filename, size, scaling){
  size_inches = size/2.54
  svglite(filename, height = size_inches, width = 1.3*size_inches, scaling = scaling)
  culmen_box <- plot_culmen_figure(penguins_culmen)
  print(culmen_box)
  dev.off()
}









