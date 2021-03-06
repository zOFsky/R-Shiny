library(shiny)
library(DT)
library(ggplot2)

cylinders = sort(unique(mtcars$cyl))
car_variables = names(mtcars)

# See above for the definitions of ui and server
ui <- fluidPage(
  titlePanel("title panel"),
  
  sidebarLayout(
    sidebarPanel("sidebar panel",
                 radioButtons("radio", h4("Choose number of cylinders"),
                              choices = cylinders
                              ),
                 actionButton("displayBtn", "Display Plot")
                 
                 ),
    mainPanel("main panel",
              DT::dataTableOutput("mytable"),
              plotOutput("plot1"),
              uiOutput("ui1"),
              uiOutput("ui2")
              # selectInput("varX", h5("Select var for X axis"), 
              #             choices = car_variables),
              # selectInput("varY", h5("Select var for Y axis"), 
              #             choices = car_variables)
              )
  )
)

server <- function(input, output) {
  
  
  selectedData <- reactive({
    mtcars[, c(input$varX, input$varY)]
  })
  
  
  output$mytable = DT::renderDataTable({
    data <- mtcars
    data <- data[data$cyl == input$radio,]
    data
  })
  
  
  
  observeEvent(input$displayBtn, {
    
    output$plot1 <- renderPlot({
      plot(selectedData())
    })
    
    output$ui1 <- renderUI({
      
      selectInput("varX", h5("Select var for X axis"), 
                  choices = car_variables)
    })
    
    output$ui2 <- renderUI({
      
      selectInput("varY", h5("Select var for Y axis"), 
                  choices = car_variables)
    })
    
  })
  
}

shinyApp(ui = ui, server = server)
