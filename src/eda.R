library(tidyverse)
library(ggcorrplot)
library(docopt)

main <- function(path_data, path_out) {
  
train_data <- read_csv(path_data)

correlation_mat <- ggcorrplot::cor_pmat(train_data %>%
                                          select_if(is.numeric))
ggsave(
  ggcorrplot::ggcorrplot(
    correlation_mat, 
    show.diag = TRUE, 
    title = "Correlation Plot of All Features (Pearon's R)"), 
  filename = paste(path_out, "/correlation_matrix.png", sep = ""))

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
       filename = paste(path_out, "/box-plots.png", sep = ""),
       width = 9, height = 12)

# Absences

ggsave(ggplot(data = train_data, aes(x = absences, y = G3)) +
  geom_point() +
  theme_minimal() + 
  coord_flip(), 
  filename = paste(path_out, "/absences.png", sep = ""))

# G3 Distribution

ggsave(ggplot(data = train_data, aes(x = G3, y = ..density..)) +
  geom_histogram(binwidth = 1) +
  geom_density() +
  theme_minimal(),
  filename = paste(path_out, "/g3_hist.png", sep= ""))


}