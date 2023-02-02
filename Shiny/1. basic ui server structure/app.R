# Libraries we need
library(shiny)
library(tidyverse)

# UI
# Define UI using a base function from shiny
ui <- fluidPage( 
  # add title to our app 
  # Note the comma at the end of the nested functions.
  # You are basically stringing together UI components that fluidPage will process to create the layout. 
  # Forgetting the comma can make for a troubleshooting nightmare!
  titlePanel('EH&E Shiny training module'), 
  
  # Sidebar panel for inputs
  sidebarPanel(
    
    'Put input modules like dropdown menus, checkboxes, etc.' 
  ), 
  
  
  # Main panel to contain outputs
  mainPanel(
    
    # one "row" for the plot output. 
    # Shiny uses Bootstrap structure from Twitter. 
    # It is based on flexible grid system. Look up the docs. 
    # Can take some time to learn. 
    fluidRow(
      # Plot output
      plotOutput(outputId = 'irisPlot') # <--- 
    ), 
    
    # Below the plot, we'll show the data in another "row". 
    fluidRow(
      # Table output
      tableOutput(outputId = 'irisTable')  # <--- outputId is whatever we assigned our output in server
    )
  )
)

# Server
server <- function (input, output, session) { 
  
  # Data table. We can name this anything we want, but remember what you call it. This is what we'll eventually use in our UI.
  # Note the curly brackets inside parentheses.
  output$irisTable <- renderTable({ 
    # All we are doing is showing the entire iris data for now. So just a call to `iris` will do. Suuuuper simple. 
    iris
  })
  
  # Plot. Again, we can name it whatever we want.
  output$irisPlot <- renderPlot({ 
    # This will look familiar as well. Just comparing sepal length to sepal width colored by species type. 
    # Your typical ggplot -- however complicated you want it to be. 
    ggplot(iris, aes(x = Sepal.Length, y = Petal.Length, color = Species)) + 
      geom_point(size = 3, alpha = 0.7) + 
      theme_bw()
  })
  
}

shinyApp(ui = ui, server = server) # <---- IMPORTANT!