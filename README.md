# Data-visualisation-Comaprison-of-Technical-Fundamental-Analysis

Instruction on how to run the code:

Stock Market Data Analysis and Visualization
This project analyzes and visualizes stock market data, focusing on sector performance and stock trends. The analysis includes candlestick charts, treemaps, boxplots, and histograms.

Table of Contents
Requirements
Setup
Running the Code
Output
Visualizations
Requirements
Ensure the following software and packages are installed:

R (>= 4.0.0)
R libraries:
dplyr, tidyverse, plotly, quantmod, treemapify
You can install the required R libraries with:

R
Copy
Edit
install.packages(c("dplyr", "tidyverse", "plotly", "quantmod", "treemapify"))
Setup
Prepare Data Files:

Download or organize your stock market data as .csv files in a single directory.
Place the 2018 financial data file (2018_Financial_Data.csv) in the same directory.
Update File Paths:

Modify the directory variable to point to the folder containing your stock data files.
Update the path to 2018_Financial_Data.csv accordingly.
Running the Code
Follow these steps to execute the analysis:

Open RStudio: Ensure you have the working directory set to the folder containing this script.

Run the Script:

Source the script to load and process the stock data. For example:
R
Copy
Edit
source("your_script_name.R")
The script will:
Merge stock data.
Filter and clean the data.
Calculate sector-level summaries.
Generate visualizations.
Generated Output:

The combined and processed dataset is saved as df1.csv in your specified output directory.
Output
Processed Data:

A combined dataset of stock market information (df1.csv).
Sector summaries, including mean Revenue, EPS, EBITDA, Net Debt, and Market Cap.
Visualizations:

Candlestick Chart: Displays stock price movements (open, high, low, close).
Treemap: Shows sector distribution by market capitalization.
Boxplot & Violin Plot: Highlights the EPS spread across sectors.
Histogram: Faceted visualization of EPS distribution by sector.
Visualizations
Examples of visualizations created by the script include:

Candlestick Chart: Shows the trading range (open, high, low, close) for specific stocks (e.g., Apple Inc.).

Treemap: Displays the distribution of market capitalization across sectors, colored by revenue.

Boxplots: Highlights EPS variation among different sectors.

Histograms: Faceted views of EPS distributions for each sector.
