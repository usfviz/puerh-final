rm(list = ls())
cat("\014")

if (!("plotly" %in% rownames(installed.packages()))) {
  install.packages("plotly")
}
if (!("GGally" %in% rownames(installed.packages()))) {
  install.packages("GGally")
}
if (!("tm" %in% rownames(installed.packages()))) {
  install.packages("tm")
}
if (!("ggrepel" %in% rownames(installed.packages()))) {
  install.packages("ggrepel")
}
if (!("RColorBrewer" %in% rownames(installed.packages()))) {
  install.packages("RColorBrewer")
}
if (!("magrittr" %in% rownames(installed.packages()))) {
  install.packages("magrittr")
}
if (!("radarchart" %in% rownames(installed.packages()))) {
  install.packages("radarchart")
}
if (!("wordcloud" %in% rownames(installed.packages()))) {
  install.packages("wordcloud")
}
if (!("parcoords" %in% rownames(installed.packages()))) {
  install.packages("parcoords")
}
if (!("githubinstall" %in% rownames(installed.packages()))) {
  install.packages("githubinstall")
}
options(unzip = 'internal')
devtools::install_github("timelyportfolio/parcoords")
library("parcoords")
library("shiny")
library("ggplot2")
library("tm")
library("ggrepel")
library("magrittr")
library("radarchart")
library("GGally")
library("plotly")
library("RColorBrewer")
library("wordcloud")

#setwd("/Users/Elise/DataViz/Project/project-prototype/app")

ui <- fluidPage(
  tags$head(
    tags$style(HTML("
                    @import url('//fonts.googleapis.com/css?family=Marcellus|Cabin:400,700');
                    @import url('//fonts.googleapis.com/css?family=Shadows Into Light Two|Cabin:400,700');
                    @import url('//fonts.googleapis.com/css?family=Give You Glory|Cabin:400,700');
                    @import url('//fonts.googleapis.com/css?family=Calligraffitti|Cabin:400,700');

                    h1 {
                    font-family: 'Calligraffitti';
                    font-weight: 1000;
                    line-height: 1.6;
                    color: #FF3399;
                    }
                    h2 {
                    font-family: 'Give You Glory';
                    font-weight: 800;
                    line-height: 1.6;
                    color: #339900;
                    }
                    h3 {
                    font-family: 'Shadows Into Light Two';
                    font-weight: 800;
                    line-height: 1.6;
                    color: #fd8d3c;
                    }
                    body {
                    font-family: 'Marcellus';
                    font-weight: 600;
                    line-height: 1.6;
                    color: #666666;
                    }
                    "))
    ),
 headerPanel(strong('World Food Facts Visualization')),
  fluidRow(
           column(12, mainPanel(checkboxGroupInput("category", h2("Select One or More Categories of Food"),choices=c("Cheese", "Soups", "Processed Meat", "Biscuits and cakes", "Alcoholic beverages"), selected = "Cheese", inline = T))),
           column(12, tabsetPanel(
             tabPanel(h3("Parallel Coordinates Plot"), 
                      sidebarPanel(sliderInput("size", "Sample Size", 0.1, 1, 0.1, animate = T, value = 0.3),
                      checkboxGroupInput("parallel_countries", "Select One or More Countries",choices=c("Other", "UK", "France", "USA", "Germany", "Spain", "Switzerland"), selected = "USA"), width = 3),
                      mainPanel(parcoordsOutput("parcoords", width = "900px", height = "600px" ))), 
             tabPanel(h3("Word Cloud"),
                      sidebarPanel(sliderInput("num_words", "Number of Words to Display", 20, 200, 20, animate = T,value = 100),
                      selectInput("palette", "Select a Color Palette", choices = c("Pink", "Blue", "Colorful", "Rainbow"), selected = "Pink"),
                      checkboxGroupInput("wordcloud_countries", "Select One or More Countries",choices=c("Other", "UK", "France", "USA", "Germany", "Spain", "Switzerland"), selected = "USA"), width = 3), 
                      mainPanel(plotOutput("wordcloud", width = "1000px", height = "850px"))),
             tabPanel(h3("Scatterplot Matrix"), 
                      sidebarPanel(checkboxGroupInput("scatter_countries", "Select One or More Countries",choices=c("Other", "UK", "France", "USA", "Germany", "Spain", "Switzerland"), selected = "USA"), width = 3), 
                      mainPanel(plotlyOutput("scatterplot", width = "900px", height = "600px"))),
             tabPanel(h3("Radar Plot"), 
                      sidebarPanel(checkboxGroupInput("radar_countries", "Countries to Compare", choices = c("Other", "UK", "France", "USA", "Germany", "Spain", "Switzerland"), 
                      selected = c("Other", "UK", "France", "USA", "Germany", "Spain", "Switzerland"), width = 1)),
                      mainPanel(chartJSRadarOutput("radar", width = "1000px", height = "900px")))
           )))
)


server <- function(input, output, session) {
  ourfood <- read.csv("ourfood.csv", na.strings=c(""," ","NA"))
  colnames(ourfood) <- c("product_name", "countries_en", "Additives","categories", "Energy", "Fat", "SaturatedFat", "Carbohydrates", "Proteins", "Sodium", "nutrition_score_fr", "nutrition_score_uk")
  francerows <- ourfood[ourfood$countries_en=="France",]
  samplefrance <- francerows[sample(nrow(francerows), size = nrow(francerows) * 0.1),]
  ourfood <- ourfood[!ourfood$countries_en=="France",]
  ourfood <- rbind(samplefrance, ourfood)
  observe({
    if(length(input$category) == 0)
    {
      updateCheckboxGroupInput(session, "category", selected= "Cheese")
    }
    if(length(input$wordcloud_countries) == 0)
    {
      updateCheckboxGroupInput(session, "wordcloud_countries", selected = "USA")
    }
    if(length(input$parallel_countries) == 0)
    {
      updateCheckboxGroupInput(session, "parallel_countries", selected= "USA")
    }
    if(length(input$radar_countries) < 3)
    {
      updateCheckboxGroupInput(session, "radar_countries", selected= c("France", "USA", "UK"))
    }
    if(length(input$scatter_countries) ==0)
    {
      updateCheckboxGroupInput(session, "scatter_countries", selected= "USA")
    }
  })
  output$parcoords <- renderParcoords({
    samplefood <- ourfood[sample(nrow(ourfood), size = nrow(ourfood) * input$size),]
    samplefood <- samplefood[samplefood$categories%in%input$category&samplefood$countries_en%in%input$parallel_countries,c("countries_en", "Additives","Energy", "Fat", "SaturatedFat", "Carbohydrates", "Proteins", "Sodium")]
    parcoords(
      samplefood
      , rownames=F
      , brushMode="2d"
      , color = list(
        colorScale = htmlwidgets::JS(sprintf(
          'd3.scale.ordinal().range(%s).domain(%s)'
          ,jsonlite::toJSON(RColorBrewer::brewer.pal(7,'Set2'))
          ,jsonlite::toJSON(as.character(unique(ourfood$countries_en)))
        ))
        ,colorBy = 'countries_en'
      )
    )
  })
  output$wordcloud <- renderPlot({
    productText <- paste(ourfood[ourfood$countries_en%in%input$wordcloud_countries&ourfood$categories%in%input$category,1], collapse = " ")
    productSource <- VectorSource(productText)
    productCorpus <- Corpus(productSource)
    productCorpus <- tm_map(productCorpus, content_transformer(tolower))
    productCorpus <- tm_map(productCorpus, content_transformer(removePunctuation))
    productCorpus <- tm_map(productCorpus, content_transformer(stripWhitespace))
    productCorpus <- tm_map(productCorpus, removeWords, c(stopwords("english"), stopwords("french"), stopwords("german"), stopwords("spanish")))
    productMatrix <- DocumentTermMatrix(productCorpus)
    productMatrix <- as.matrix(productMatrix)
    productFrequencies <- sort(colSums(productMatrix), decreasing=TRUE)
    wordCloudDF <- data.frame(word = names(productFrequencies),freq=productFrequencies)
    wordCloudDF <- wordCloudDF[1:input$num_words,]
    pinkPalette <- c("#d4b9da", "#fcc5c0", "#fa9fb5", "#c994c7", "#f768a1","#df65b0", "#dd3497", "#e7298a", "#ae017e")
    colorfulPalette <- c(brewer.pal(8,"Set2"),"#c994c7", "#f768a1","#df65b0")
    bluePalette <- c("#6baed6", "#4292c6", "#2171b5","#0570b0","#08519c", "#023858")
    if (input$palette=="Pink"){
      wordcloud(names(productFrequencies), productFrequencies, family="serif",scale=c(10,0.7),min.freq=1,
                max.words=Inf, random.order=T, rot.per=0.3,colors =pinkPalette)
    }
    if (input$palette=="Colorful"){
      wordcloud(names(productFrequencies), productFrequencies,family="serif", scale=c(10,0.7),min.freq=1,
                max.words=Inf, random.order=T, rot.per=0.3,colors =colorfulPalette)
    }
    if (input$palette=="Rainbow"){
      wordcloud(names(productFrequencies), productFrequencies,family="serif", scale=c(10,0.7),min.freq=1,
                max.words=Inf, random.order=T, rot.per=0.3,colors =rainbow(30))
    }
    if (input$palette=="Blue"){
      wordcloud(names(productFrequencies), productFrequencies,family="serif", scale=c(10,0.7),min.freq=1,
                max.words=Inf, random.order=T, rot.per=0.3,colors =bluePalette)
    }
  })
  
  output$scatterplot <- renderPlotly({
    scatter_data <- ourfood[ourfood$categories%in%input$category&ourfood$countries_en%in%input$scatter_countries,c(3,5:10,2)]
    ggplotly(ggpairs(scatter_data, 1:6, mapping = ggplot2::aes(alpha = 0.6, color=countries_en))+ theme_bw() + theme(legend.position = "none"))
  })
  output$radar <-renderChartJSRadar({
    typefood <- ourfood[ourfood$categories%in%input$category&ourfood$countries_en%in%input$radar_countries,c(2:3,5:10)]
    avfood <- aggregate(. ~ countries_en, data = typefood, mean)
    normed <- as.data.frame(lapply(avfood[2:8], function(x) x/max(x)), row.names = avfood[[1]])
    transposed = setNames(data.frame(t(normed)), avfood[,1])
    chartJSRadar(transposed,showToolTipLabel=TRUE, labs = rownames(transposed))
  })
}
shinyApp(ui, server)

