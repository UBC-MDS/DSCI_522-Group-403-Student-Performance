# Authors: Brayden Tang, Kenneth Foo, Brendon Campbell
# Date: January 24, 2020

"This script creates box plots of all of the predictors, a correlation matrix,
and a plot of the estimated distribution of G3. This script assumes that it will
be run in the root directory of the repository.

Usage: eda.R <path_data> <directory_out>

Options:
<path_data>       A file path that gives the location of the data set that will be used to fit each graph.
<directory_out>   A file path specifying where to store all of the rendered graphs.
" -> doc

library(tidyverse)
library(ggcorrplot)
library(docopt)

main <- function(path_data, directory_out) {
  
train_data <- read_csv(path_data)

# Correlation Matrix

correlation_mat <- ggcorrplot::cor_pmat(train_data %>%
                                          select_if(is.numeric))
ggsave(
  ggcorrplot::ggcorrplot(
    correlation_mat, 
    show.diag = TRUE, 
    title = "Correlation Plot of All Features (Pearon's R)"), 
  filename = paste(directory_out, "/correlation_matrix.png", sep = ""))

plotting_data <- train_data %>%
  gather(key = predictor, value = value, -G3) %>%
  filter(predictor != "absences")

ggsave(ggplot(data = plotting_data, aes(x = value, y = G3)) +
         facet_wrap(. ~ predictor, scale = "free", ncol = 3) +
         geom_boxplot() +
         coord_flip() +
         theme_minimal() +
         theme(axis.title.y = element_blank()) +
         geom_jitter(alpha = 0.1),
       filename = paste(directory_out, "/box-plots.png", sep = ""),
       width = 9, height = 12)

# Absences

ggsave(ggplot(data = train_data, aes(x = absences, y = G3)) +
  geom_point() +
  theme_minimal() + 
  coord_flip(), 
  filename = paste(directory_out, "/absences.png", sep = ""))

# G3 Distribution

ggsave(ggplot(data = train_data, aes(x = G3, y = ..density..)) +
  geom_histogram(binwidth = 1) +
  geom_density() +
  theme_minimal(),
  filename = paste(directory_out, "/g3_hist.png", sep= ""))

}

opt <- docopt::docopt(doc)

main(opt$path_data, opt$directory_out)