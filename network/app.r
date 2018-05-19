library(shiny)
library(tidyverse)
library(networkD3)
library(igraph)
library(shinyjs)
library(tidygraph)

cordocument <- read_csv(file = file.path("data/doccor.csv"))

ui <- fluidPage(includeCSS("webpage.css"),
                tabPanel("Interrogating Marx(ism)"),
                tags$h1(tags$a(href="https://dhmarx.commons.gc.cuny.edu/instructions/", "Interrogating Marx(ism)")), 
                        tags$h2("Correlation Network"),
        sidebarPanel(tags$p("The Correlation Network displays a network graph indicating the term frequency correlations between texts in the corpus. 
                            It allows manipulation of the level of correlation to examine connections between works.
                            Note, if the slider is moved above 0.7, a network graph is not generated"),
                     tags$br(),
          sliderInput("networkfilter",
                                         label = "Correlation level:",
                                         min = 0, max = 1,
                                         value = 0.5,
                                         step = 0.05),
                                        br(),
                     tags$a(href = "https://dhmarx.commons.gc.cuny.edu/instructions/correlation-network-instructions/", "Correlation Network Instructions"),
                     tags$br(),
                     tags$a(href="https://dhmarx.commons.gc.cuny.edu/instructions/", "Back to main page")),
                             mainPanel(conditionalPanel(condition = "input.networkfilter <= 0.68", 
                               forceNetworkOutput("network1"))))

server <- function(input,output){
  networkdata <- reactive(
    {igraph_to_networkD3(
      as.igraph(
        as_tbl_graph(
          filter(cordocument,correlation > input$networkfilter))))})
  MyNodes <- reactive(
    {data.frame(c(networkdata()$nodes,group = seq(1)))})
  output$network1 <- renderForceNetwork(
    {forceNetwork(Links = networkdata()$links, Nodes = MyNodes(),
                  Source = "source", Target = "target",
                  Value = "value", NodeID = "name",
                  Group = "group", opacity = 0.8,
                  charge = -80,
                  opacityNoHover = 0.5,
                  linkDistance = 200,
                  linkWidth = JS(" function(d) { return d.value/1; }"),
                  zoom = T, 
                  linkColour = "red",
                  fontSize = 18,
                  height = 1000,
                  width = 1000,
                  colourScale = JS("d3.scaleOrdinal(d3.schemeCategory20);"),
                  bounded = TRUE
    )})}


shinyApp(ui = ui, server = server)


