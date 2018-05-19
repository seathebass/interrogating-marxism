library(shiny)
library(tidyverse)
library(ggalluvial)
library(ggthemes)

completedata <- read_csv(file = file.path("data/LDAmodel.csv"))

ui <- fluidPage(includeCSS("webpage.css"),
                tags$h1(tags$a(href="https://dhmarx.commons.gc.cuny.edu/instructions/", "Interrogating Marx(ism)")),
                              tags$h2("Alluvial Graph"),
                sidebarPanel(tags$p("The Topic Flow app produces a visual comparison of words appearing within two selected corpus texts,
                                    based on their classifications within topic groups identified using", 
                                    tags$a(href = "https://en.wikipedia.org/wiki/Latent_Dirichlet_allocation", "Latent Dirichlet Allocation"),"."),
                             tags$br(),
                  selectInput("var",
                                label = "First Document:",
                              choices = completedata$document,
                                               selected = NULL),
                                   textOutput("selected_var1"),
                                   selectInput("vars",
                                               label = "Second document:",
                                               choices = completedata$document,
                                               selected = NULL),
                                   textOutput("selected_var2"),
                  actionButton("button", label = "Compare"),
                              br(),
                              tags$a(href = "https://dhmarx.commons.gc.cuny.edu/instructions/topic-flow-instructions/", "Topic Flow Instructions"),
                  tags$br(),
                  tags$a(href="https://dhmarx.commons.gc.cuny.edu/instructions/", "Back to main page")),
                            mainPanel(plotOutput("plot1")))
?selectInput       
server <- function(input,output){
                              all1<- reactive({completedata})
                              alls <- eventReactive(input$button,
                                {all1() %>% filter(
                                  str_detect(document,pattern = c(input$var, input$vars)))})
                              output$plot1<- renderPlot({
                                print(ggplot(alls(),aes(axis1 = alls()$document, axis2 = alls()$term))+
                                        geom_alluvium(aes(fill = factor(alls()$topic)),show.legend = FALSE)+
                                        geom_stratum(fill = "darkgrey") +
                                        geom_text(stat = "stratum",label.strata = TRUE)+
                                        theme_void()+
                                        theme(strip.text = element_text(color = "white"),
                                              legend.text = element_blank(),
                                              axis.text = element_blank(),
                                              plot.background = element_rect(colour = "black")))})}



shinyApp(ui = ui, server = server)

  