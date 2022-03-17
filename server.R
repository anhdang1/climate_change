library(ggplot2)
library(plotly)
library(dplyr)
library("rbokeh")
library(tidyverse)



climate_data <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv")

data_range <- climate_data %>% group_by(year) %>% select(year,oil_co2_per_capita)

#Which year has the highest consumption of Co2 around the world from 1970 to 2020
highest_year <- climate_data %>% filter(year>=1970) %>%group_by(year) %>% summarize(total_co2 = sum(oil_co2,na.rm=T)) %>%  filter(total_co2 == max(total_co2, na.rm=T)) %>% pull(year)

#which year has the lowest consumption of Co2 around the world from 1970 to 2020
lowest_year <- climate_data %>% filter(year>=1970) %>% group_by(year) %>% summarize(total_co2 = sum(oil_co2,na.rm=T))%>%filter(total_co2 == min(total_co2, na.rm=T)) %>% pull(year)

#which country has the highest oil co2 consumed per capita 
highest_country <- climate_data %>%
  filter(year>=1970) %>%
  filter(oil_co2_per_capita == max(oil_co2_per_capita,na.rm=T))%>%
  pull(country)


#which country has the lowest oil co2 consumed per capita
lowest_country <- climate_data %>%
  filter(year>=1970) %>%
  filter(oil_co2_per_capita == min(oil_co2_per_capita,na.rm=T))%>%
  pull(country)

#Location (country abd its iso_code) that is the highest net importer (highest positive trade_co2_share)
climate_data <- climate_data %>% mutate(location = paste(country,'-', iso_code))

highest_location <- climate_data %>% group_by(location) %>% filter(trade_co2_share > 0) %>% 
  summarize(trade_share = sum(trade_co2_share, na.rm = T)) %>% filter(trade_share == min(trade_share)) %>% pull(location)



custom_legend_titles <- reactiveValues("year" = "Year", "country" = "Country", "oil_co2_per_capita" = "Oil Comsumption Per Capita")

server <- function(input, output) {
  
  output$climatePlot <- renderPlotly({
    
    # Allow user to filter by multiple countries
    climate_data <- climate_data %>% filter(country %in% input$user_category) %>% filter(year <= input$year[2],
                                                                                         year >= input$year[1])
    # Make a line plot of oil per capita over time by country
    
    oil_consumption <- ggplot(data = climate_data) +
      geom_line(mapping = aes(x=year, y = oil_co2_per_capita, color = country)) +
      labs(title = 'Oil Per Capita Over Time By Country',
           x = "Year",
           y = "Oil Co2 Consumption")
    ggplotly(oil_consumption)
    
  })
  
  
  output$Text01 <- renderText({"CO2 and Greenhouse Gas Emissions dataset is a collection of key metrics maintained by Our World in Data. This data has been collected, aggregated, and documented by Hannah Ritchie, Max Roser, Edouard Mathieu, Bobbie Macdonald and Pablo Rosado.
            It is updated regularly and includes data on CO2 emissions (annual, per capita, cumulative and consumption-based), 
            other greenhouse gases, energy mix, and other relevant metrics. The dataset was collected from different sources including Global Carbon Project, Climate Watch Portal, and more.
            The data was collected to make data and research on Climate Change/ CO2 and Greenhous Gas Emissions. Greenhouse gas emissions from human activities are the main driver of the climate change and global warming. Therefore,
            making this dataset accessible and available online will help the public aware of how differently this warming is distributed across the world. In some regions, warming is much more extreme.
            The possible limitation of this data is that it's so large, there are a lot of NA values, 
            which will make it challenging to create visualizations and possibly inaccurate demonstrations. 
            On top of that, it's overwhelming and takes up a significant amount of time to understand the data because there are many columns and variables to do analysis on. 
            Another problem would be the inconsistency in the dataset. It runs from 1949 to 2020; however, several variables collected was not conducted until 1980. This creates a gap of inconsistency in the dataset. 
            
            An approach to minimize problems working with the dataset is to read through the data description and codebook to understand the meaning of each variable. 
            Then narrow down our focus on several variables to analyze and create visualizations on. It would also be helpful to clean the data by removing unused columns and eliminating NA values."})
  output$Value <- renderText({
    paste0("There are 5 values that I'm interested in. The first value is which year has the highest/ lowest consumption of CO2 around the world from 1970 to 2020. I found ",highest_year," to be the highest and ",lowest_year," to be the lowest. Next is which country has the highest/lowest oil co2 consumed per capita and they were ",highest_country," and ",lowest_country," respectively. I also found the location (country and its iso_code) that is the highest net importer (highest positive trade_co2_share), which was ",highest_location,"")
  })
  output$Text03 <- renderText({"This chart let users compare the amount of Oil CO2 per capita across different countries in the world.  There is also a range wideget that allows users to specify the timeframe that they want to look at. There are some preiod of time that there is no data (so there is a gap in the line). For example, when the user choose Australia, there is no data till 1900. Then there is a gap between 1910 to 1950, the graphs continue after 1950. It's also interesting when you look at Bahrain. It has a dramatically high oil co2 consumption in the 90s but significantly drop right after 1950"})

}






