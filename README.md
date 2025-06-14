# R-dge-cancer-study

## Objective
To identify genes with significantly different expression levels between cancer and healthy tissues, aiming to discover potential biomarkers for cancer.

## Methods
Data was tidied and merged from multiple sources to create a unified dataset. Unnecessary columns were removed for clarity. Gene expression data was visualized against age. For each gene, an independent t-test was performed to compare expression between cancer and healthy tissue groups. P-values from these tests were adjusted for multiple comparisons using the Bonferroni method. Key genes of interest were filtered and visualized.

## Results
Of the five genes analyzed, three (GENE001, GENE004, GENE005) showed a statistically significant increase in expression in cancer tissues compared to healthy tissues (Bonferroni-adjusted p < 0.05). Scatter plots and summary tables were generated for these genes.

## Conclusion
These genes are strong candidates for further biological investigation as potential biomarkers for this cancer type.

---

### Example R Workflow

```r
# Data cleaning and filtering
merged_data <- merged_data %>%
  filter(!is.na(expression)) %>%
  select(gene_id, expression, condition, age)

# Statistical testing
library(dplyr)
library(purrr)
t_test_results <- merged_data %>%
  group_by(gene_id) %>%
  summarise(
    t_test = list(t.test(expression ~ condition)),
    p_value = map_dbl(t_test, "p.value")
  ) %>%
  mutate(p_adj = p.adjust(p_value, method = "bonferroni"))

# Selecting significant genes
significant_genes <- t_test_results %>%
  filter(p_adj < 0.05) %>%
  pull(gene_id)

# Filtering for selected genes
selected_genes <- merged_data %>%
  filter(gene_id %in% significant_genes)

# Plotting example
if (!dir.exists("Output")) dir.create("Output")
png("Output/scatter_plot.png")
plot(expression ~ age, data = selected_genes)
dev.off()
```

---

## License

This project is for research and educational purposes.