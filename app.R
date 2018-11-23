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
              selectInput("varX", h5("Select var for X axis"), 
                          choices = car_variables),
              selectInput("varY", h5("Select var for Y axis"), 
                          choices = car_variables)
              )
  )
)

server <- function(input, output) {
  
  
  selectedData <- reactive({
    mtcars[, c(input$varX, input$varY)]
  })
  
  waitForClick <- eventReactive(input$displayBtn, {
    selectedData()
  })
  
  output$mytable = DT::renderDataTable({
    data <- mtcars
    data <- data[data$cyl == input$radio,]
    data
  })
  
  output$plot1 <- renderPlot({
    plot(selectedData())
      
  })
}

shinyApp(ui = ui, server = server)
