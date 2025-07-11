# MTH-208 Course Project - Group 26
## Olympic Games Data Analysis and Visualization

### 📋 Project Overview
This project is a comprehensive analysis of Olympic Games data, developed as part of the MTH-208 statistics course. Our team has created an interactive data exploration tool that provides insights into Olympic performance across different countries, sports, and time periods.

### 🎯 Project Objectives
- Analyze Olympic Games data from Summer and Winter Olympics (1984-2020)
- Create interactive visualizations to explore medal distributions and trends
- Examine relationships between country GDP and Olympic performance
- Develop a user-friendly Shiny web application for data exploration
- Provide comprehensive statistical analysis and reporting

### 🗂️ Project Structure
```
├── Data/                           # Contains all datasets
│   ├── full_data.Rdata            # Complete Olympic dataset
│   ├── GDP_Countries.Rdata        # GDP data for countries
│   ├── GDP_Medals_final_data.Rdata # Combined GDP and medals data
│   ├── Summer_games.Rdata         # Summer Olympics data
│   ├── Winter_games.Rdata         # Winter Olympics data
│   ├── sports_wise_medals_summer.Rdata
│   ├── sports_wise_medals_winter.Rdata
│   ├── year_sports_wise_medals_summer.Rdata
│   ├── year_sports_wise_medals_winter.Rdata
│   └── trimmed_data.Rdata         # Cleaned and processed data
├── ShinyApp/                       # Interactive web application
│   ├── app.R                      # Main Shiny application
│   └── README.md                  # Shiny app documentation
├── Report/                         # Project documentation
│   ├── Group_26.qmd              # Main project report
│   └── README.md                  # Report documentation
├── Presentation/                   # Project presentation materials
│   ├── GROUP_26 Presentation.pptx
│   └── README.md                  # Presentation documentation
├── ProjectGuidelines.qmd          # Course project guidelines
└── README.md                      # This file
```

### 📊 Data Sources
The dataset includes:
- **Olympic Games Data**: Medal winners from Summer and Winter Olympics (1984-2020)
- **Athlete Information**: Age, height, weight, and performance statistics
- **Country Data**: GDP information for participating countries
- **Sports Categories**: Performance data across various Olympic sports
- **Temporal Data**: Year-wise and season-wise medal distributions

### 🚀 Features
Our Shiny application provides:
- **Interactive Visualizations**: Dynamic plots and charts
- **Country Performance Analysis**: Medal counts and trends by country
- **Sports-wise Breakdown**: Performance analysis by sport categories
- **GDP Correlation**: Relationship between economic indicators and Olympic success
- **Temporal Analysis**: Trends over time (1984-2020)
- **Seasonal Comparison**: Summer vs Winter Olympics analysis

### 🛠️ Technologies Used
- **R**: Primary programming language
- **Shiny**: Interactive web application framework
- **ggplot2**: Data visualization
- **dplyr**: Data manipulation
- **plotly**: Interactive plots
- **GGally**: Advanced plotting
- **patchwork**: Plot composition
- **Quarto**: Report generation

### 📋 Prerequisites
To run this project, you need:
- R (version 4.0 or higher)
- RStudio (recommended)
- Required R packages:
  ```r
  install.packages(c("shiny", "ggplot2", "GGally", "patchwork", 
                     "dplyr", "plotly", "shinythemes"))
  ```

### 🚀 Getting Started

#### Running the Shiny Application
1. Clone or download this repository
2. Open R/RStudio
3. Set working directory to the project folder
4. Navigate to the `ShinyApp` directory
5. Run the application:
   ```r
   shiny::runApp("ShinyApp/app.R")
   ```

#### Viewing the Report
1. Open `Report/Group_26.qmd` in RStudio
2. Render the document to view the complete analysis

### 📈 Key Analyses
Our project explores:
1. **Medal Distribution**: How medals are distributed across countries and sports
2. **Performance Trends**: Changes in Olympic performance over time
3. **Economic Correlations**: Relationship between GDP and Olympic success
4. **Seasonal Variations**: Differences between Summer and Winter Olympics
5. **Top Performers**: Identification of leading countries and athletes

### 🎯 Research Questions
- Which countries consistently perform well in the Olympics?
- How does a country's GDP correlate with Olympic medal counts?
- What trends can be observed in Olympic performance over the past decades?
- How do Summer and Winter Olympics differ in terms of participation and success?
- Which sports contribute most to a country's overall Olympic success?

### 🔍 Usage Instructions
1. **Data Exploration**: Use the Shiny app to interactively explore the data
2. **Filtering**: Apply filters by year, country, sport, or season
3. **Visualization**: Generate various plots and charts
4. **Analysis**: Review statistical summaries and trends
5. **Export**: Save visualizations and results for further analysis

### 📚 References
- Olympic Games official data sources
- World Bank GDP data
- Course materials and guidelines
- R documentation and package vignettes
---
*Last updated: July 2025*
*Course: MTH-208 - Data Science Lab 1*
*Group: 26*
