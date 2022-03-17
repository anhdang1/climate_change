library(ggplot2)
library(plotly)
library(bslib)
library("rbokeh")
library(dplyr)



climate_data <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv")
#grouped_data <- climate_data %>% group_by(year) #%>% summarize(total_co2 = sum(cumulative_co2,na.rm=T))
count_range <- range(climate_data$year)



intro_tab <- tabPanel(
  "Introduction",
  fluidPage(theme = bs_theme(bootswatch = "minty"),
            p("Welcome to my climate change app!"),
            mainPanel(
              textOutput("Text01"),
              textOutput("Value")
            )
  )
)

rboke_sidebar <- sidebarPanel(
  selectInput(
    inputId = "user_category",
    label = "Select Country",
    choices = climate_data$country,
    selected = "United States",
    multiple = TRUE),
  sliderInput("year", "Choose year range:",
              min = count_range[1],
              max = count_range[2],
              value = count_range,
              step = 1)
)

 
# plot_sidebar <- sidebarPanel(
#   sliderInput("year", "Choose year range:",
#               min = count_range[1],
#               max = count_range[2],
#               value = count_range,
#               step = 1)
# )
#                 

             
       
# plot_main <- mainPanel(
#   plotlyOutput(outputId = "co2_comsumption", width = "100%", height = "auto"),
#   textOutput("Text02")
# )

rboke_main <- mainPanel(
  textOutput("Text03"),
  rbokehOutput(outputId = "climatePlot", width = "100%", height = "auto")
)


plot_tab <- tabPanel(
  "Envisioning Card",
  p("Welcome to the envisioning tab"),
  mainPanel(
    textOutput("Text04"),
    textOutput("Text05")
  )
)


rboke_tab <- tabPanel(
  "Country Oil Consumption",
  sidebarLayout(
    rboke_sidebar,
    rboke_main
  )
)



ui <- navbarPage(
  "Climate Change",
  intro_tab,
  rboke_tab,
  plot_tab
)
