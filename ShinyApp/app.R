library(shiny)
library(ggplot2)
library(GGally)
library(patchwork)
library(dplyr)
library(plotly)
library(shinythemes)
load("../Data/Winter_games.Rdata")
load("../Data/Summer_games.Rdata")
load("../Data/sports_wise_medals_winter.Rdata")
load("../Data/sports_wise_medals_summer.Rdata")
load("../Data/year_sports_wise_medals_winter.Rdata")
load("../Data/year_sports_wise_medals_summer.Rdata")
load('../Data/trimmed_data.Rdata')
load('../Data/GDP_Medals_final_data.Rdata')
load('../Data/full_Data.Rdata')
load('../Data/GDP_Countries.Rdata')

# Olympic data constants
host_cities <- c("Los Angeles", "Seoul", "Barcelona", "Atlanta", "Sydney",
                 "Athina", "Beijing", "London", "Rio De Janeiro", "Tokyo")
years_olympics <- c("1984", "1988", "1992", "1996", "2000", "2004", "2008", "2012", "2016", "2020")

team_sports_excluded <- c("Artistic Swimming", "Basketball", "Equestrian Dressage", "Equestrian Eventing",
                          "Equestrian Jumping", "Football", "Handball", "Hockey", "Modern Pentathlon", 
                          "Rhythmic Gymnastics", "Volleyball", "Water Polo")

# Adjust for country name consistency
world_data <- map_data("world")
renamed_GDP_data <- GDP_data
renamed_GDP_data$Country_Name[renamed_GDP_data$Country_Name == 'United States'] <- 'USA'
renamed_GDP_data$Country_Name[renamed_GDP_data$Country_Name == 'Great Britain'] <- 'UK'

# Define UI for application
ui <- fluidPage(
  
  tags$head(
    tags$style(HTML("
      table {
        border-collapse: collapse; /* Combine borders */
        width: 100%; /* Full width */
      }
      th, td {
        border: 2px solid black; /* Border color */
        padding: 8px; /* Cell padding */
        text-align: left; /* Text alignment */
      }
      th {
        background-color: #e0f7fa; /* Light background for headers */
      }
      body {
        background-color: #f0f8ff; /* Light cyan */
        font-family: 'Montserrat', sans-serif; /* Using Montserrat font */
      }
      h1 {
        color: #2e8b57; /* Dark green for headings */
        font-weight: 700; /* Bold heading */
      }
      p {
        color: #555; /* Dark gray for paragraphs */
        font-weight: 400; /* Regular paragraph text */
      }
      img {
      border: 1px solid #ffffff; /* Border color and width */
        padding: 5px; /* Padding inside the border */
        border-radius: 10px; /* Optional: Rounded corners */
        max-width: 100%; /* Make sure the image is responsive */
      }
    "))
  ),
  # Application title
  titlePanel("Olympics"),
  img(src="https://olympics.com/images/static/b2p-images/logo_color.svg", align = "right",height='100px',width='400px',alt = "not found"),
  
  # Sidebar with a slider input for number of bins 
  tabsetPanel(
    tabPanel("Introduction",
             mainPanel(
               h2("Welcome to the Olympics Data Explorer!"),
               p("The Olympic Games are a global multi-sport event that takes place every four years, featuring thousands of athletes from over 200 countries. The games include a variety of sports, from athletics to swimming, and are held in a different host city each time."),
               p("This application allows you to explore detailed statistics about the Olympic Games, including:"),
               tags$ul(
                 tags$li("Total medals won by each country"),
                 tags$li("Trends in medal counts over the years"),
                 tags$li("Top athletes in Olympic history"),
                 tags$li("Detailed statistics for each sport and event")
               ),
               p("Use the tabs above to navigate through the data and discover interesting insights about the Olympic Games!"),
               p("You can view data for both summer and winter games individually"),
               img(src="photo.png", style = "margin: 0; padding: 0;",align = "right",height='400px',width='100%',alt = "not found")
             )
    ),
    tabPanel("Countries",
             sidebarPanel(
               radioButtons("Season", label = h3("Select Season"),
                            choices = list(
                              "☀️ Summer" = "summer",  # Sun emoji for Summer
                              "❄️ Winter" = "winter"   # Snowflake emoji for Winter
                            ), 
                            selected = "winter"),
              sliderInput("year", "Select Year", min = 1896, max = 2022, value = 2022),
               selectInput("Country", label = h3("Select Country"), 
                           choices = NULL,selected = "United States"),
               
               hr(),
               fluidRow(column(3, verbatimTextOutput("value")))
               
             ),
             mainPanel(
               uiOutput("flag"),
               div(style = "display: flex; justify-content: center; align-items: center;",
                   tableOutput("performance")
               )
             )),
    tabPanel("Winners",
             sidebarPanel(
               radioButtons("Season_2", label = h3("Select Season"),
                            choices = list(
                              "☀️ Summer" = "summer",  # Sun emoji for Summer
                              "❄️ Winter" = "winter"   # Snowflake emoji for Winter
                            ), 
                            selected = "winter"),
               selectInput("year_2", label = h3("Select Year"),
                           choices = NULL, selected = 1988), 
               selectInput("sports", label = h3("Select Sports"), 
                           choices = NULL, selected = "United States")
             ),
             mainPanel(
               uiOutput("sport_img"),
               div(style = "display: flex; justify-content: center; align-items: center;",
                   tableOutput("winner")
               )
             )),
    tabPanel("Other Information", 
             theme = shinytheme('flatly'),  # Theme change
             
             sidebarLayout(
               sidebarPanel(
                 radioButtons("plot_type", "Choose type of plots:", 
                              choices = list("Plots for individual years" = 1,
                                             "Plots for individual events" = 2)),
                 selectInput("year_input", "Select year", choices = unique(data1$year)),
                 checkboxGroupInput('sport_category', 'Choose Type', 
                                    choices = c('team', 'individual'), 
                                    selected = 'individual'),
                 selectInput("event_choice", "Choose Event", choices = NULL)
               ),
               mainPanel(
                 conditionalPanel(
                   condition = 'input.plot_type == 1',
                   h3(textOutput('title_map_display')),
                   plotOutput('medal_map_display'),
                   h3(textOutput("title_medal_dist")),
                   plotOutput("medal_histogram_display"),
                   h3(textOutput("title_gender_dist")),
                   plotOutput("gender_histogram_display"),
                   h3(textOutput("title_gdp_influence")),
                   plotlyOutput("gdp_influence_plot")
                 ),
                 conditionalPanel(
                   condition = 'input.plot_type == 2',
                   h3(textOutput("title_age_height_weight_association")),
                   plotOutput("age_height_weight_plot"),
                   h3(textOutput('title_boxplot_display')),
                   plotOutput('medal_boxplot_display'),
                   h3(textOutput("title_medal_trend_display")),
                   plotOutput("medal_trend_plot")
                 )
               )
             ))
  )
)

# Define server logic
server <- function(input, output,session) {
  observeEvent(input$Season, {
    if (input$Season == "summer") {
      updateSelectInput(session, "Country", 
                        choices = unique(sports_wise_medals_summer$Team), selected = "United States")
      updateSliderInput(session, "year",
                        min = min(unique(year_sports_wise_medals_summer$Year)), max = max(unique(year_sports_wise_medals_summer$Year)), value = max(unique(year_sports_wise_medals_summer$Year)), step = NULL)
    } else if (input$Season == "winter") {
      updateSelectInput(session, "Country", 
                        choices = unique(sports_wise_medals_winter$Team), selected = "United States")
      updateSliderInput(session, "year",
                        min = min(unique(year_sports_wise_medals_winter$Year)), max = max(unique(year_sports_wise_medals_winter$Year)), value = max(unique(year_sports_wise_medals_winter$Year)), step = NULL)
    }
  })
  observeEvent(input$Season_2, {
    if (input$Season_2 == "summer") {
      updateSelectInput(session, "year_2", 
                        choices = unique(year_sports_wise_medals_summer$Year), selected = "1988")
      updateSelectInput(session, "sports", 
                        choices = unique(summer_games$Sport), selected = "Rowing")
      
      
    } else if (input$Season_2 == "winter") {
      updateSelectInput(session, "year_2", 
                        choices = unique(year_sports_wise_medals_winter$Year), selected = "1988")
      updateSelectInput(session, "sports", 
                        choices = unique(winter_games$Sport), selected = "Ice Hockey")
    }
  })
  output$flag <- renderUI({
    country_code <- switch(input$Country,
                           "Afghanistan" = "af",
                           "Algeria" = "dz",
                           "Argentina" = "ar",
                           "Armenia" = "am",
                           "Australia" = "au",
                           "Austria" = "at",
                           "Azerbaijan" = "az",
                           "Bahamas" = "bs",
                           "Bahrain" = "bh",
                           "Barbados" = "bb",
                           "Belarus" = "by",
                           "Belgium" = "be",
                           "Botswana" = "bw",
                           "Brazil" = "br",
                           "Bulgaria" = "bg",
                           "Burundi" = "bi",
                           "Cameroon" = "cm",
                           "Canada" = "ca",
                           "Chile" = "cl",
                           "China" = "cn",
                           "Chinese Taipei" = "tw",  # Taiwan
                           "Colombia" = "co",
                           "Costa Rica" = "cr",
                           "Cote d'Ivoire" = "ci",  # Ivory Coast
                           "Croatia" = "hr",
                           "Cuba" = "cu",
                           "Cyprus" = "cy",
                           "Czech Republic" = "cz",
                           "Denmark" = "dk",
                           "Djibouti" = "dj",
                           "Dominican Republic" = "do",
                           "East Germany" = "dd",  # Historical
                           "Ecuador" = "ec",
                           "Egypt" = "eg",
                           "Eritrea" = "er",
                           "Estonia" = "ee",
                           "Ethiopia" = "et",
                           "Fiji" = "fj",
                           "Finland" = "fi",
                           "France" = "fr",
                           "Gabon" = "ga",
                           "Georgia" = "ge",
                           "Germany" = "de",
                           "Ghana" = "gh",
                           "Great Britain" = "gb",
                           "Greece" = "gr",
                           "Grenada" = "gd",
                           "Guatemala" = "gt",
                           "Hong Kong" = "hk",
                           "Hungary" = "hu",
                           "Iceland" = "is",
                           "India" = "in",
                           "Indonesia" = "id",
                           "Iran" = "ir",
                           "Ireland" = "ie",
                           "Israel" = "il",
                           "Italy" = "it",
                           "Jamaica" = "jm",
                           "Japan" = "jp",
                           "Jordan" = "jo",
                           "Kazakhstan" = "kz",
                           "Kenya" = "ke",
                           "Kosovo" = "xk",
                           "Kuwait" = "kw",
                           "Kyrgyzstan" = "kg",
                           "Latvia" = "lv",
                           "Lithuania" = "lt",
                           "Macedonia" = "mk",
                           "Malaysia" = "my",
                           "Mauritius" = "mu",
                           "Mexico" = "mx",
                           "Moldova" = "md",
                           "Mongolia" = "mn",
                           "Montenegro" = "me",
                           "Morocco" = "ma",
                           "Namibia" = "na",
                           "Netherlands" = "nl",
                           "New Zealand" = "nz",
                           "Niger" = "ne",
                           "Nigeria" = "ng",
                           "North Korea" = "kp",
                           "Norway" = "no",
                           "Pakistan" = "pk",
                           "Panama" = "pa",
                           "Paraguay" = "py",
                           "Peru" = "pe",
                           "Philippines" = "ph",
                           "Poland" = "pl",
                           "Portugal" = "pt",
                           "Puerto Rico" = "pr",
                           "Qatar" = "qa",
                           "Romania" = "ro",
                           "Russia" = "ru",
                           "Saudi Arabia" = "sa",
                           "Senegal" = "sn",
                           "Serbia" = "rs",
                           "Singapore" = "sg",
                           "Slovakia" = "sk",
                           "Slovenia" = "si",
                           "South Africa" = "za",
                           "South Korea" = "kr",
                           "Soviet Union" = "su",  # Historical
                           "Spain" = "es",
                           "Sri Lanka" = "lk",
                           "Sudan" = "sd",
                           "Suriname" = "sr",
                           "Sweden" = "se",
                           "Switzerland" = "ch",
                           "Syria" = "sy",
                           "Tajikistan" = "tj",
                           "Thailand" = "th",
                           "Togo" = "tg",
                           "Tonga" = "to",
                           "Trinidad and Tobago" = "tt",
                           "Tunisia" = "tn",
                           "Turkey" = "tr",
                           "Uganda" = "ug",
                           "Ukraine" = "ua",
                           "United Arab Emirates" = "ae",
                           "United States" = "us",
                           "Uruguay" = "uy",
                           "Uzbekistan" = "uz",
                           "Venezuela" = "ve",
                           "Vietnam" = "vn",
                           "West Germany" = "de",  # Historical
                           "Yugoslavia" = "yu",  # Historical
                           "Zambia" = "zm",
                           "Zimbabwe" = "zw")
    if (!is.null(country_code)) {
      # Center the flag using a div
      div(style = "text-align: center;",
          tags$img(src = paste0("https://flagcdn.com/80x60/", country_code, ".png"), 
                   alt = input$country, 
                   height = "200px"))
    } else {
      "Country code not found."
    }
  }
  )
  datasetInput <- reactive({
    switch(input$Season,
           "summer" = year_sports_wise_medals_summer,
           "winter" = year_sports_wise_medals_winter
           )
  })
  sub <- reactive({
    dat <- datasetInput()
    subset(dat, (Year == input$year))
    
  })
  sub2 <- reactive({
    dat <- sub()
    subset(dat, (Team == input$Country))
  })
  
  output$performance <- renderTable(
    sub2(),
    striped = TRUE)
  
  
  datasetInput_2 <- reactive({
    switch(input$Season_2,
           "summer" = summer_games,
           "winter" = winter_games
    )
  })
  sub_2 <- reactive({
    datasetInput_2() %>%
      filter(Sport == input$sports, Year == input$year_2) %>%
      group_by(Team, Name) %>%
      summarize(Total_Medals = n()) %>%
      arrange(desc(Total_Medals)) %>%
      group_by(Team) %>%
      slice_max(order_by = Total_Medals, n = 1, with_ties = FALSE) %>%  # Top athlete per country, no ties
      ungroup() %>%
      arrange(desc(Total_Medals)) %>%
      slice_max(order_by = Total_Medals, n = 3, with_ties = FALSE) %>%  # Top 3 countries, no ties
      mutate(Position = row_number()) %>%  # Add position
      select(Team, Name, Position)  # Keep only relevant columns
  })
  
  output$winner <- renderTable(
    sub_2(),
    striped = TRUE)
  
  
  
  output$sport_img = renderUI({
    img_code <- switch(input$sports,
                       "Rowing" = "https://img.olympics.com/images/image/private/t_16-9_1560-880/f_auto/v1538355600/primary/rpkofo8xhebsq5vxhsqf",
                       "Football" = "https://img.olympics.com/images/image/private/t_16-9_1560-880/f_auto/v1538355600/primary/em6kjqm2bjgsrna1q4d5",
                       "Fencing" = "https://img.olympics.com/images/image/private/t_16-9_960/f_auto/v1538355600/primary/uh9d465if2xvbkobky6z",
                       "Taekwondo" = "https://img.olympics.com/images/image/private/t_16-9_960/f_auto/v1538355600/primary/sdy8qmrb9r9yxghh7i6l",
                       "Athletics" = "https://img.olympics.com/images/image/private/t_16-9_1560-880/f_auto/v1538355600/primary/bsmfc2ntllqw8djnxxtx",
                       "Canoeing" = "https://img.olympics.com/images/image/private/t_16-9_1560-880/f_auto/v1538355600/primary/kvwfgpudjn3zyisfktkb",
                       "Handball" = "https://img.olympics.com/images/image/private/t_16-9_1560-880/f_auto/v1538355600/primary/rk0dfbqyplwphx8j8iz3",
                       "Water Polo" = "https://img.olympics.com/images/image/private/t_16-9_960/f_auto/v1538355600/primary/aekyaflnkrns5yibq0xr",
                       "Wrestling" = "https://img.olympics.com/images/image/private/t_16-9_960/f_auto/v1538355600/primary/iyfgt6oddx7zkmuqz35v",
                       "Cycling" = "https://img.olympics.com/images/image/private/t_16-9_1560-880/f_auto/v1538355600/primary/pqhcpa7r8fkyze3kob1n",
                       "Hockey" = "https://img.olympics.com/images/image/private/t_16-9_960/f_auto/v1538355600/primary/hpxtwf7teiodoolxcwir",
                       "Softball" = "https://img.olympics.com/images/image/private/t_16-9_1560-880/f_auto/v1538355600/primary/v4v9xzel3oh5zycdo5pm",
                       "Boxing" = "https://img.olympics.com/images/image/private/t_16-9_1560-880/f_auto/v1538355600/primary/zvwfzjlgsum0ywmv1yyu",
                       "Basketball" = "https://img.olympics.com/images/image/private/t_16-9_960/f_auto/v1538355600/primary/i1hfk2awwhpojt2t7pcr",
                       "Diving" = "https://img.olympics.com/images/image/private/t_16-9_960/f_auto/v1538355600/primary/nrus2jfvcpwaa1yikn3j",
                       "Baseball" = "https://img.olympics.com/images/image/private/t_16-9_960/f_auto/v1538355600/primary/jdpfpl0o1ngo2dqclpdy",
                       "Gymnastics" = "https://img.olympics.com/images/image/private/t_16-9_1560-880/f_auto/v1538355600/primary/zrprhlccnbqjw581jjov",
                       "Swimming" = "https://img.olympics.com/images/image/private/t_16-9_960/f_auto/v1538355600/primary/exulfe8rgo3vys3wkdwo",
                       "Volleyball" = "https://img.olympics.com/images/image/private/t_16-9_1560-880/f_auto/v1538355600/primary/rk0dfbqyplwphx8j8iz3",
                       "Rugby Sevens" = "https://img.olympics.com/images/image/private/t_16-9_960/f_auto/v1726153541/primary/zc4jwzdxwpsmp5vooirv",
                       "Tennis" = "https://img.olympics.com/images/image/private/t_16-9_1560-880/f_auto/v1538355600/primary/gowd2nbxtuvok7neoisl",
                       "Judo" = "https://img.olympics.com/images/image/private/t_16-9_960/f_auto/v1538355600/primary/alu4b9dmd8rdvoz97baa",
                       "Rhythmic Gymnastics" = "https://img.olympics.com/images/image/private/t_16-9_960/f_auto/v1538355600/primary/lv6fkivycvqraa4m8omt",
                       "Weightlifting" = "https://img.olympics.com/images/image/private/t_16-9_960/f_auto/v1538355600/primary/u9w0z6olzjkdiw0asdpf",
                       "Equestrianism" = "https://img.olympics.com/images/image/private/t_16-9_960/f_auto/v1538355600/primary/e7fdvupibjjkf0vl8izy",
                       "Badminton" = "https://img.olympics.com/images/image/private/t_16-9_1560-880/f_auto/v1538355600/primary/akjenqtu2outol5actqv",
                       "Beach Volleyball" = "https://img.olympics.com/images/image/private/t_16-9_1560-880/f_auto/v1538355600/primary/akjenqtu2outol5actqv",
                       "Sailing" = "https://img.olympics.com/images/image/private/t_16-9_960/f_auto/v1538355600/primary/teyhgqaeg4hzdsotbh7q",
                       "Shooting" = "https://img.olympics.com/images/image/private/t_16-9_1560-880/f_auto/v1538355600/primary/nky6o7qasxves5skdtp3",
                       "Synchronized Swimming" = "https://img.olympics.com/images/image/private/t_16-9_960/f_auto/v1538355600/primary/k0l7olpchcltyxhrzlmz",
                       "Triathlon" = "https://img.olympics.com/images/image/private/t_16-9_1560-880/f_auto/v1538355600/primary/ezctfhme4i0ejbs1hqzv",
                       "Modern Pentathlon" = "https://img.olympics.com/images/image/private/t_16-9_1560-880/f_auto/v1538355600/primary/kuejvjo5aa75cr3cvprp",
                       "Table Tennis" = "https://img.olympics.com/images/image/private/t_16-9_960/f_auto/v1538355600/primary/d3gpelzdffyeks7bqjfy",
                       "Archery" = "https://img.olympics.com/images/image/private/t_16-9_960/f_auto/v1538355600/primary/tj6ky0gqnauwapvwxsii",
                       "Trampolining" = "https://img.olympics.com/images/image/private/t_16-9_1560-880/f_auto/v1538355600/primary/xoueuvktsaysai9fwrua",
                       "Golf" = "https://img.olympics.com/images/image/private/t_16-9_1560-880/f_auto/v1538355600/primary/xnxabbvqvezok55tyfxv",
                       "Ice Hockey" = "https://img.olympics.com/images/image/private/t_16-9_1560-880/f_auto/v1538355600/primary/sl71ndinhyusxtsbegae",
                       "Alpine Skiing" = "https://img.olympics.com/images/image/private/t_16-9_1560-880/f_auto/v1538355600/primary/yc1ljlh7onbdilt2zdms",
                       "Figure Skating" = "https://img.olympics.com/images/image/private/t_16-9_960/f_auto/v1538355600/primary/aj1uvazr86q9favlpaed",
                       "Nordic Combined" = "https://img.olympics.com/images/image/private/t_16-9_1560-880/f_auto/v1538355600/primary/r9vtvjqma7hamxfroptg",
                       "Speed Skating" = "https://img.olympics.com/images/image/private/t_16-9_1560-880/f_auto/v1538355600/primary/bqlhl11szc960zebvqjs",
                       "Bobsleigh" = "https://img.olympics.com/images/image/private/t_16-9_960/f_auto/v1538355600/primary/qhpxc2hnszqrq9kh0ndc",
                       "Curling" = "https://img.olympics.com/images/image/private/t_16-9_1560-880/f_auto/v1538355600/primary/dxcbvwrqwerbqxqoj1ao",
                       "Ski Jumping" = "https://img.olympics.com/images/image/private/t_16-9_960/f_auto/v1538355600/primary/zxwu1nkmlvzt84lzhbki",
                       "Short Track Speed Skating" = "https://img.olympics.com/images/image/private/t_16-9_960/f_auto/v1538355600/primary/uxliabcojtka9scobdve",
                       "Biathlon" = "https://img.olympics.com/images/image/private/t_16-9_1560-880/f_auto/v1538355600/primary/xgsa7h5tkayqs95fdzrc",
                       "Cross Country Skiing" = "https://img.olympics.com/images/image/private/t_16-9_1560-880/f_auto/v1538355600/primary/tfygxkitch1xshp4myqi",
                       "Freestyle Skiing" = "https://img.olympics.com/images/image/private/t_16-9_1560-880/f_auto/v1538355600/primary/cel6lsym11glwvpbrrk4",
                       "Snowboarding" = "https://img.olympics.com/images/image/private/t_16-9_1560-880/f_auto/v1538355600/primary/j5twg00rcrychphppsfk",
                       "Skeleton" = "https://img.olympics.com/images/image/private/t_16-9_1560-880/f_auto/v1538355600/primary/bbtxbjacdnjvtlc951xt",
                       "Luge" = "https://img.olympics.com/images/image/private/t_16-9_960/f_auto/v1538355600/primary/warlxucmetxjfibqpqsd")
    
    div(style = "text-align: center;",
        tags$img(src = img_code, 
                 alt = input$sports, 
                 height = "200px"))
  })
  year_data_selected <- reactive({
    subset(data1, year == input$year_input & Type == input$sport_category)
  })
  
  observeEvent(year_data_selected(), {
    events_available <- unique(year_data_selected()$Events)
    updateSelectInput(inputId = "event_choice", choices = events_available)
  })
  
  output$title_medal_dist <- renderText({
    year_selected <- input$year_input
    city <- host_cities[which(year_selected == years_olympics, arr.ind = TRUE)]
    paste("Medal distribution in", year_selected, "Olympics (", city, ")", sep = " ")
  })
  
  output$medal_histogram_display <- renderPlot({
    index_year <- which(input$year_input == years_olympics, arr.ind = TRUE)
    yearly_data <- all_data[[index_year]]
    
    ggplot(yearly_data, aes(Events)) +
      geom_histogram(aes(fill = Medal), binwidth = .1, stat = "count", 
                     color = "black", size = .1) +
      scale_fill_brewer(palette = "Spectral") +
      labs(y = "Medal Count", x = '') +
      theme(axis.text.x = element_text(angle = 30, vjust = 0.5, hjust = 1))
  })
  
  output$title_gender_dist <- renderText({
    year_selected <- input$year_input
    city <- host_cities[which(year_selected == years_olympics, arr.ind = TRUE)]
    paste("Gender distribution of events in", year_selected, "Olympics (", city, ")")
  })
  
  output$gender_histogram_display <- renderPlot({
    index_year <- which(input$year_input == years_olympics, arr.ind = TRUE)
    yearly_data <- all_data[[index_year]]
    
    ggplot(yearly_data[yearly_data$Type == 'individual' & !is.na(yearly_data$Gender),], aes(Events)) +
      geom_histogram(aes(fill = Gender), binwidth = .1, stat = "count", 
                     color = "black", size = .1) +
      scale_fill_brewer(palette = "Spectral") +
      labs(y = "Count", x = '') +
      theme(axis.text.x = element_text(angle = 30, vjust = 0.5, hjust = 1))
  })
  
  output$title_age_height_weight_association <- renderText({
    paste("Plot of age, height, and weight associations for medal winners in", input$event_choice)
  })
  
  output$age_height_weight_plot <- renderPlot({
    filtered_event_data <- subset(data1, Events == input$event_choice & Type == 'individual')
    ggpairs(filtered_event_data, columns = c("Age", "Height", "Weight"), mapping = aes(colour = Medal, alpha = 0.7))
  })
  
  output$title_boxplot_display <- renderText({
    paste("Boxplot of Age, Height, and Weight of medal winners in", input$event_choice)
  })
  
  output$medal_boxplot_display <- renderPlot({
    filtered_event_data <- subset(data1, Events == input$event_choice & Type == 'individual')
    height_plot <- ggplot(filtered_event_data) + geom_boxplot(aes(x = Medal, y = Height, fill = Medal)) + labs(title = 'Height')
    weight_plot <- ggplot(filtered_event_data) + geom_boxplot(aes(x = Medal, y = Weight, fill = Medal)) + labs(title = 'Weight')
    age_plot <- ggplot(filtered_event_data) + geom_boxplot(aes(x = Medal, y = Age, fill = Medal)) + labs(title = 'Age')
    
    height_plot + weight_plot + age_plot
  })
  
  output$title_medal_trend_display <- renderText({
    paste("Number of medals won by top 5 countries in", input$event_choice, "from 1984 to 2020")
  })
  
  output$medal_trend_plot <- renderPlot({
    filtered_event_data <- subset(data1, Events == input$event_choice)
    leading_countries <- names(sort(table(filtered_event_data$Country), decreasing = TRUE)[1:5])
    medal_trend <- filtered_event_data %>%
      filter(Country %in% leading_countries) %>%
      group_by(year, Country) %>%
      summarise(count = n())
    
    ggplot(medal_trend, aes(year, count, color = Country)) + geom_line(size = 1.5)
  })
  
  output$title_gdp_influence <- renderText({
    paste("Effect of GDP on Olympic Success in", input$year_input)
  })
  
  output$gdp_influence_plot <- renderPlotly({
    gdp_data_year <- subset(GDP_data, Year == input$year_input)
    gdp_effect_plot <- ggplot(gdp_data_year, aes(x = GDP, y = Medals, colour = Country)) +
      geom_point() + scale_x_log10() + scale_y_log10() + theme(legend.position = 'none')
    
    ggplotly(gdp_effect_plot)
  })
  
  output$title_map_display <- renderText({
    year_selected <- input$year_input
    city <- host_cities[which(year_selected == years_olympics, arr.ind = TRUE)]
    paste("Medals won by countries in", year_selected, "Olympics (", city, ")")
  })
  
  output$medal_map_display <- renderPlot({
    map_index <- match(world_data$region, renamed_GDP_data[renamed_GDP_data$Year == input$year_input,]$Country_Name)
    world_data$medal_count <- renamed_GDP_data[renamed_GDP_data$Year == input$year_input,]$Medals[map_index]
    
    ggplot(world_data, aes(long, lat, fill = medal_count, group = group)) +
      geom_polygon(color = 'gray') + 
      scale_fill_continuous(low = "#f2d340", high = "#6c1615", guide = "colorbar") +
      labs(fill = 'Number of Medals')
  })
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)
