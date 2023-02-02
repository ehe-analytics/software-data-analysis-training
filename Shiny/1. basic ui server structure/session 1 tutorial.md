---
title: "Shiny session 1"
author: "Ankur Singhal"
date: "`r Sys.Date()`"
output: html_document
---

This document covers some basic concepts about Shiny. We'll create a simple ggplot using the iris data set. Later we will add interactivity to this dashboard and will eventually add a map. We'll hold off on creating a map for now since it requires a bit more UI manipulation in my opinion. Let's keep it simple for now.

There is a lot of good documentation available out there. Rather than repeat what's already out there, I will refer to appropriate tutorials. The focus of this will be to introduce you to the basics and leave it to you to dig into the nuances. Don't worry if some of the concepts below don't make a whole lot of sense right away. Once you start creating your own apps, the seeminglyt esoteric concepts will start to become clearer. 

So, let's get started. 

First of all, install the `shiny` package. Because, obvi. 

```
install.packages('shiny') 
```

## Shiny app structure

A typical Shiny app has two main components: a `ui` object and a `server` function. Both of these components can be contained into a single R script called *app.R*. More complex structures are available, which we will get into later. 

Let's take a look at each one-by-one. 

### UI

As you would expect, the `ui` component of your Shiny app controls the layout and appearance of the app in addition to containing user interactive elements. These are things like:

- General layout of your app like a typical website layout. This can be as simple to as complex you may want it to be. For example, you can take a basic structure provided by the package or modify HTML, embed CSS for styling preferences, or even include JavaScript to modify interactivity. 
- Interactive elements like dropdown menus, user input, etc. 
- Output of your tables, graphs, maps, etc. 

Consider the example below. First, we'll take a standard function from `shiny` package called `fluidPage` to create a blank canvas, so to speak. Then we'll start adding elements like adding a title to our page, a sidebar panel to contain a dropdown menu and other possible user-interactive elements. The main panel will contain outputs like the `iris` data and plot based on user's input(s).

```
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
       'This column will contain a plot output.'
      ), 
      
      # Below the plot, we'll show the data in another "row". 
      fluidRow(
          'This column will contain a table output.'
        ), 
        
       
    )
)
```
The code above doesn't do all that much except for creating a basic UI layout that you can start to fill in, but first let's take a quick look at the `server` function that will do all the backend processing. 

Note that application layouts can take some time to learn. Shiny layout is based on Bootstrap layout guide created by Twitter. See <https://shiny.rstudio.com/articles/layout-guide.html> for more information. This can sometimes take a few trials before the app looks the way you want it to. 


### Server 

This is where all the good stuff happens; well, for us anyway becuase this is where we get to process the data based on user input, create plots, and other insights that the user might be interested in. The structure of the `server` function is very different from UI.

We want to create two outputs based on user input -- one a table and the other a plot. So, what we will do is wrap the expression to create our table and plot in `renderTable` and `renderPlot`, respectively. These are like your standard R function objects. The only difference is that we will assign the function to `output`, which is simply a named list that will contain the return elements from `renderTable` and `renderPlot`.

```
# Standard server function call. I never change this. 
# This is where we will define server logic. 
server <- function (input, output, session) { 
  
  # Data table. We can name this anything we want, but remember what you call it. This is what we'll eventually use in our UI.
  # Note the curly brackets inside parentheses. 
  output$irisTable <- renderTable({ 
    # Put logic to show table
  })
  
  # Plot. Again, we can name it whatever we want.
  output$irisPlot <- renderPlot({ 
    # Put logic to show plot
  })
  
}
```

So far so good, but really boring. In the next section, we will create tables and plots. 


## Populate our basic app

We will start with server first this time because I think better that way. For now, we will just show all the iris data and create a scatter plot comparing sepal length to petal length by species type. I'm jittery with excitement...

### Server

Let's take the script from above and fill it in. This part should seem pretty obvious to you R experts. 

```
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
```

### UI

Now that we have created our table and plot, we need to actually show it. The UI doesn't know what to show yet. 

The complementary functions to `renderTable` and `renderPlot` are `tableOutput` and `plotOutput` respectively, which will go into your UI. And remember the names that we assigned to our functions in the `output` list? Well, look at the documentation for `tableOutput` and `plotOutput`. Each of those functions take `outputId` as their first argument, which is the name you assigned to your table and plot in the server chunk above. The functions simply pull the named output from the `output` list generated in the server and will show the desired output. Hopefully, this makes more sense in the code chunk below. 


```
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
```

You could combine the two chunks into one file called `app.R` like so. Remeber to load the libraries up top and add `shinyApp(ui = ui, server = server)` at the bottom; otherwise, you'll get an error. Point to your app using `runApp('...')` where "..." is the location of the file, e.g., `runApp('shiny/1. basic ui server structure/app.R')` to see your first functioning Shiny app!

You notice issues with the layout? Well, I leave it up to you to make it look the way you want it to. 

```
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
```

## Next steps

As usual, I recommend playing with the app using your own dataset. To do that all you'll need to do is load your dataset at the top of the app, as you would typically and then use the loaded data throughout the app, instead of the iris data. 

``` 
library(tidyverse)
library(shiny) 

df <- read_csv('your data goes here')
```

I think it'll also be worthwhile to play around with the UI layout and move components around. The docs should help you. I honestly find the UI to take the most amount of time for me. The server part is quick but getting things to look nice is a real PITA. 

Next session, we will add user interactivity using drop down menus, etc. to modify table and plots based on user input. 