#required libraries
library(htmltools)
library(shiny)
library(tidyverse)
library(shinyjs)
library(tidytext)
#read cleaned csv of text files
completedata <- read_csv("data/marxtextdata.csv")

ui <- fluidPage(includeCSS("webpage.css"),
                tags$h1(tags$a(href="https://dhmarx.commons.gc.cuny.edu/instructions/", "Interrogating Marx(ism)"), 
                        tags$h2("Context Search"),
                        tags$br(),
                        sidebarPanel(tags$p("The Context Search app retrieves occurrences of any user-generated terms within individual works, combinations of texts, or the entire collection. 
                                            The results are displayed within the originating sentence or the surrounding paragraph, as selected."),
                                     tags$br(),
                                     #input selections
                                     selectInput("var1",
                                                 label = "Select one or more documents:",
                                                 choices = completedata$id,
                                                 selected = 1,
                                                 multiple = TRUE,
                                                 selectize = TRUE),
                                     br(),
                                     selectInput("var2",
                                                 label = "Output level:",
                                                 choices = list("sentences", "paragraphs")),
                                     br(),
                                     textInput("key", label = "Keyword:", value = ""),
                                     br(),
                                     actionButton("button", label = "Search"),
                                     br(),
                                     #links
                                     tags$a(href = "https://dhmarx.commons.gc.cuny.edu/instructions/context-search-instructions/", "Context Search Instructions"),
                                     tags$br(),
                                     tags$a(href="https://dhmarx.commons.gc.cuny.edu/instructions/", "Back to main page")),
                        mainPanel(
                          uiOutput("para1"))))
#changing some of the characteristics of str_view_all to generate desired output
strings <- function (title ,string, pattern, match = NA) 
{
  if (identical(match, TRUE)) {
    string <- string[str_detect(string, pattern)]
  }
  else if (identical(match, FALSE)) {
    string <- string[!str_detect(string, pattern)]
  }
  loc <- str_locate_all(string, pattern)
  string_list <- Map(loc = loc, string = string, function(loc, 
                                                          string) {
    if (nrow(loc) == 0) 
      return(string)
    for (i in rev(seq_len(nrow(loc)))) {
      str_sub(string, loc[i, , drop = FALSE]) <- paste0("<span class='match'>", 
                                                        str_sub(string, loc[i, , drop = FALSE]), "</span>")
    }
    string
  })
  string <- unlist(string_list)
  #this line of code adds appropriate html tags to the output 
  bullets <- HTML(str_c("<ul>\n", str_c("<br>","<li>", 
                                        string, "</li>","<i> ",paste("-",title),"</i>","</br>",collapse = "\n"), "\n</ul>"))}                         

#server function
server <- function(input,output){
  #importing dataset and making it a reactive function
  textdata <- reactive({completedata})
  #making the filter respond to the action button
  textdata1 <-eventReactive(input$button,{
    textdata() %>% 
      unnest_tokens(text,token =input$var2,text, to_lower = FALSE) %>% 
      filter(id %in% input$var1,
             str_detect(text, pattern = fixed(paste(input$key), ignore_case = TRUE)))
  })
  output$para1 <- renderUI({
    input$button
    #isolating input to ensure that output only charnges when user clicks button.
    isolate(
      if(!is.na(str_length(textdata1()$text[1])) == TRUE){
        HTML(
          strings(title = textdata1()$id,string = textdata1()$text, pattern = fixed(paste(input$key),ignore_case = TRUE), match = TRUE))
      }else 
        #generating a "no matches found" statement when no keywords are found
        HTML("<li>","No matches found","</li>"))
  })
}

shinyApp(ui = ui, server = server)

