library(dplyr)
library(tidyr)
library(ggplot2)


getwd()
gene_ex <- read.table("Data/gene_expression.csv", header = TRUE, sep = ",")
sample_met <- read.table("Data/sample_metadata.csv", header = TRUE, sep = ",")

head(gene_ex)
head(sample_met)

gene_ex_long <- gene_ex %>%
  pivot_longer(
    cols = -gene_id,
    names_to = "sample_id",
    values_to = "expression"
  )

head(gene_ex_long)
merged_data <- merge(gene_ex_long, sample_met, by.x = "sample_id", by.y = "sample_id") # nolint
head(merged_data)

# Checking missing values
colSums(is.na(merged_data)) # all clean

# checking if expression levels correlate with age
correlation_matrix <- merged_data %>%
  select(where(is.numeric)) %>%
  cor()

correlation_matrix # NOTE based on this matrix there is a moderate positive r = 0.54 # nolint
# correlation between age and expression levels, this need further investigation

# since sample id and condition representative of the same
# thing sample id gets dropped
merged_data <- merged_data %>% select(-sample_id)

head(merged_data) # now the data is much cleaner

# time for some data visualization
boxplot_of_condition <- ggplot(data = merged_data, aes(x = condition, y = expression, fill = condition)) + # nolint
  geom_boxplot(alpha = 0.5, size = 1.5) +
  geom_jitter(aes(color = age)) +
  labs(
    title = "expression level between caner and healthy patients",
    x = "condition",
    y = "Expression level"
  ) +
  theme_classic()
ggsave("Output/boxplot_of_condition.png")


# NOTE expression levels seems much higher in caner patients based on this
# boxplot and also they seems to be older patients too, based on this boxplot
# and the previous correlation matrix it seems caner is heavily related to
# age and higher expression level

# To further investigate that claim we will make a scatter plot
png("Output/scatter_plot.png")
scatter_plot <- with(merged_data, {
  plot(age ~ expression)
  linear_model <- lm(expression ~ age)
  abline(linear_model)
})
dev.off()
# NOTE Again the expression levels looks higher in older patients


## Differential Expression Analysis

t_test_results <- by(
  merged_data,
  merged_data$gene_id,
  function(df) t.test(expression ~ condition, data = df)$p.value
)
t_test_results
t_test <- data.frame(
  gene_id = names(t_test_results),
  unadjusted_p_values = unlist(t_test_results)
)
t_test$p_adjusted <- p.adjust(t_test$unadjusted_p_values, method = "bonferroni")
significant_p_values <- t_test %>% filter(p_adjusted <= 0.05)

significant_p_values # NOTE gene 001 and 004 and 005 are significant
significant_genes <- significant_p_values$gene_id
selected_genes <- merged_data %>% filter(gene_id %in% significant_genes) #nolint

significant_gene_boxplot <- ggplot(data = selected_genes, aes(x = condition, y = expression, color = condition)) +
  geom_boxplot() + facet_wrap(gene_id~.)
ggsave("Output/significant_gene_boxplot.png")