# Load necessary libraries
library(dplyr)
library(tidyverse)
library (plotly)
library(quantmod)
library (treemapify)

# Scipen

options(scipen = 999)

# Define the directory containing your CSV files

directory <- "C:/Users/Oscar Sibanda/Desktop/UofS/Data Visualisation/Coursework/Stock data/stock_market_data/sp500/csv"


# Get a list of all CSV files in the directory

file_list <- list.files(directory, pattern = "*.csv", full.names = TRUE)
sector_df1 <- read.csv("C:/Users/Oscar Sibanda/Desktop/UofS/Data Visualisation/Coursework/2018_Financial_Data.csv")

# Function to read and process each file with ticker symbol

read_stock_data <- function(file) {
  # Extract the stock ticker symbol from the file name
  ticker <- tools::file_path_sans_ext(basename(file))
  
  # Read the CSV file
  data <- read.csv(file)
  
  # Ensure the Date column is treated as a date
  data$Date <- as.Date(data$Date, format = "%d-%m-%Y")
  
  # Add a new column for the stock ticker symbol
  data$Ticker <- ticker
  
  return(data)
}

# Load and merge all files
merged_data <- bind_rows(lapply(file_list, read_stock_data))

# Check the first few rows of the merged data
#head(merged_data)

df1 <- subset(merged_data[1:50000,])

# Sector file column names & select function

colnames(sector_df1) <- gsub(" ","", colnames(sector_df1))

sector_df2 <- select(sector_df1, X,Revenue,EPS,EBITDA,NetDebt,MarketCap,Sector)

# Filterout error rows 

sector_df2 <- sector_df2[sector_df2$X!="IGLD",]
sector_df2 <- sector_df2[sector_df2$X!="CEI",]
sector_df2 <- sector_df2[sector_df2$X!="MEIP",]
sector_df2 <- sector_df2[sector_df2$X!="RSLS",]
sector_df2 <- sector_df2[sector_df2$X!="NMRK",]
sector_df2 <- sector_df2[sector_df2$X!="BSAC",]
sector_df2 <- sector_df2[sector_df2$X!="NVR",]
sector_df2 <- sector_df2[sector_df2$X!="NTXP",]
sector_df2 <- sector_df2[sector_df2$X!="SAEX",]
sector_df2 <- sector_df2[sector_df2$X!="RRTS",]
sector_df2 <- sector_df2[sector_df2$X!="JAGX",]
sector_df2 <- sector_df2[sector_df2$X!="SLS",]
sector_df2 <- sector_df2[sector_df2$X!="VIVE",]
sector_df2 <- sector_df2[sector_df2$X!="TNXP",]

sector_df2 <- sector_df2[sector_df2$EPS < 15,]
sector_df2 <- sector_df2[sector_df2$EPS > -15,]


#Renaming column


sector_df2 <- sector_df2 %>% rename(Ticker = X)

# Monthly 

monthly_avg <- Combined_df %>% 
  mutate(Month = floor_date(Date, "month")) %>% 
  group_by(Ticker, Month) %>% 
  summarise(
    Low  = mean(Low, na.rm = TRUE),
    Open = mean(Open, na.rm = TRUE),
    High = mean(High, na.rm = TRUE),
    Close = mean(Close, na.rm = TRUE),
    .groups = "drop"
    
    
  )

#Merging by sector 

Combined_df <- left_join(merged_data,sector_df2, by = c("Ticker"="Ticker"))

write.csv(Combined_df, "C:/Users/Oscar Sibanda/Documents/df1.csv", row.names = FALSE)


# Drop NA

sector_df2 <- sector_df2 %>% drop_na()
Combined_df <- Combined_df %>% drop_na()

summary_df2 <- sector_df2 %>% 
  group_by(Sector) %>% 
  summarise(
    Revenue = mean(Revenue, na.rm = TRUE),
    EPS = mean(EPS, na.rm = TRUE),
    EBITDA = mean(EBITDA, na.rm = TRUE),
    NetDebt = mean(NetDebt, na.rm = TRUE),
    MarketCap = mean(MarketCap, na.rm = TRUE),
    .groups = "drop"
  )

Combined_df <- Combined_df %>% 
  group_by(Sector) %>% 
  summarise(
    Revenue = mean(Revenue, na.rm = TRUE),
    EPS = mean(EPS, na.rm = TRUE),
    EBITDA = mean(EBITDA, na.rm = TRUE),
    NetDebt = mean(NetDebt, na.rm = TRUE),
    MarketCap = mean(MarketCap, na.rm = TRUE),
    
    .groups = "drop"
  )

# Selecting stock(s)

df1 <- filter(df1,Ticker %in% c("A","ABT"))

#################VISUALISATIONS PLOTS & CHART##########################################################################

#1 High-Low Close Chart (Candlestick Chart) summary of each trading range (open, high, low, close)
# IMPROVE Y AXIS BY LIMITING THE PRICE RANGE

candle1 <- merged_data %>% 
  filter(Ticker %in% c("AAPL"))

dfc <- data.frame(candle1)

dfc <- tail(dfc,30)

plot_ly(dfc, x= ~Date, type = "candlestick",
        open = ~Open, close = ~Close,
        high = ~High, low = ~Low ) %>% 
  layout(title= "Open-High-Low-Close Chart\n Apple Stock",
         xaxis = list(title = "Date"),
         yaxix = list(title = "Price"))

#2 Treemap

ggplot(summary_df2, aes(area = MarketCap, fill = Revenue, label= Sector)) +
  geom_treemap() + geom_treemap_text(colour="white", place="centre") +
  labs(title="Distribution of Sectors by MarketCap",
       fill="Sector\nRevenue",
       caption="Stock Market Data")

#3 Botplot

ggplot(sector_df2, aes(Sector, EPS, fill = Sector)) + geom_boxplot(show.legend = FALSE)

ggplot(sector_df2, aes(Sector, EPS, fill = Sector)) + geom_violin(show.legend = FALSE)+geom_boxplot(width =.4, show.legend = FALSE)+
  theme(axis.text.x = element_text(angle = 90))+ labs(caption = "Stock Market Data")

#4 Histogram faceting

ggplot(sector_df2, aes(x= EPS,
                       fill = Sector))+
  geom_histogram(bins = 15,show.legend = FALSE)+
  facet_wrap(~Sector)+
  scale_color_brewer(palette = "Dark2")







