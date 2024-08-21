# Install necessary packages if not already installed
install.packages("tidyverse")
install.packages("GGally")
install.packages("scales")

# Load the libraries
library(tidyverse)
library(GGally)
library(scales)

# Load the Ames Housing dataset
# Give your own path link to load the file
df <- read_csv("Your path")

# View the first few rows
glimpse(df)

# Check for missing values
missing_data <- df %>%
  summarize_all(~ sum(is.na(.))) %>%
  gather(key = "Variable", value = "MissingValues") %>%
  filter(MissingValues > 0)

# Display missing data
print(missing_data)

# Fill missing values or drop columns with excessive missing data
df <- df %>%
  mutate_if(is.character, ~ replace_na(., "Unknown")) %>%
  drop_na()

# Check for outliers in sale price
ggplot(df, aes(x = SalePrice)) +
  geom_histogram(bins = 30, fill = "blue", alpha = 0.7) +
  scale_x_continuous(labels = scales::dollar_format()) +
  labs(title = "Distribution of Sale Prices", x = "Sale Price", y = "Frequency")

# Remove extreme outliers
df <- df %>% filter(SalePrice < 500000)

# Correlation matrix to understand relationships between numerical variables
df_numeric <- df %>%
  select_if(is.numeric)

cor_matrix <- cor(df_numeric)
ggcorrplot::ggcorrplot(cor_matrix, lab = TRUE, lab_size = 2.5, 
                       title = "Correlation Matrix of Numerical Features")

# Analyze the relationship between SalePrice and important variables
ggplot(df, aes(x = GrLivArea, y = SalePrice)) +
  geom_point(alpha = 0.5, color = "darkblue") +
  geom_smooth(method = "lm", color = "red") +
  scale_y_continuous(labels = scales::dollar_format()) +
  labs(title = "Sale Price vs. Ground Living Area", x = "Ground Living Area (sq ft)", y = "Sale Price")

ggplot(df, aes(x = YearBuilt, y = SalePrice)) +
  geom_point(alpha = 0.5, color = "darkgreen") +
  geom_smooth(method = "lm", color = "red") +
  scale_y_continuous(labels = scales::dollar_format()) +
  labs(title = "Sale Price vs. Year Built", x = "Year Built", y = "Sale Price")


# Neighborhood analysis
ggplot(df, aes(x = reorder(Neighborhood, SalePrice, median), y = SalePrice)) +
  geom_boxplot(fill = "blue", alpha = 0.7) +
  scale_y_continuous(labels = scales::dollar_format()) +
  coord_flip() +
  labs(title = "Sale Price Distribution by Neighborhood", x = "Neighborhood", y = "Sale Price")

# Year built and sale price trend over time
ggplot(df, aes(x = YearBuilt, y = SalePrice)) +
  geom_point(alpha = 0.5, color = "purple") +
  geom_smooth(method = "loess", color = "red") +
  scale_y_continuous(labels = scales::dollar_format()) +
  labs(title = "Sale Price Trends Over Time", x = "Year Built", y = "Sale Price")
