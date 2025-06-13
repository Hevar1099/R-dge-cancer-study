# R-dge-cancer-study

This project analyzes gene expression data in relation to age for cancer studies using R.

## Getting Started

### Prerequisites

- R (version 4.0 or higher recommended)
- [dplyr](https://cran.r-project.org/web/packages/dplyr/index.html) package (for data manipulation)
- [ggplot2](https://cran.r-project.org/web/packages/ggplot2/index.html) package (optional, for advanced plotting)

### Data Preparation

1. **Merge Data:**  
   Combine your datasets into a single data frame called `merged_data`.

2. **Drop Columns:**  
   Remove unnecessary columns using either base R or `dplyr`:
   ```r
   # Base R
   merged_data <- merged_data[ , !(names(merged_data) %in% c("column_to_drop"))]

   # dplyr
   library(dplyr)
   merged_data <- merged_data %>% select(-column_to_drop)
   ```

3. **Plotting Expression vs. Age:**  
   Visualize the relationship between gene expression and age:
   ```r
   # Base R
   plot(x = merged_data$age, y = merged_data$expression)

   # or using with()
   with(merged_data, plot(age, expression))

   # or using formula interface
   plot(expression ~ age, data = merged_data)
   ```

## Example

```r
# Assuming merged_data is already loaded and cleaned
plot(expression ~ age, data = merged_data)
```

## License

This project is for research and educational purposes.