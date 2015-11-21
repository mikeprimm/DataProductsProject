
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)

cols <- c("H", "diameter", "albedo", "rot_per", "e", "a", "q", "i", "om", "w", "ma", "ad", "per", "per_y")
labels <- c("Absolute Magnitude", "Diameter (km)", "Albedo", "Rotation Period (hr)", "Eccentricity", "Semi-Major Axis (AU)", "Perihelion (AU)", "Inclination (deg)", "Longiture of ascending node (deg)", "Argument of perihelion (deg)", "Mean anomaly (deg)", "Aphelion (AU)", "Period (days)", "Period (years)")
choicesX <- list("Absolute Magnitude" = "H", "Diameter (km)" = "diameter", "Albedo" = "albedo", "Rotation Period (hr)" = "rot_per", "Eccentricity" = "e", "Semi-Major Axis (AU)" = "a", "Perihelion (AU)" = "q", "Inclination (deg)" = "i", "Longiture of ascending node (deg)" = "om", "Argument of perihelion (deg)" = "w", "Mean anomaly (deg)" = "na", "Aphelion (AU)" = "ad", "Period (days)" = "per", "Period (years)" = "per_y", "Class" = "class")
choicesY <- append(list("Population Density" = "popdensity"), choicesX)
population <- list("All Asteroids" = "Asteroid", "All Comets" = "Comet", "All Comets and Asterods" = "Both", "Near-Earth Objects" = "NEO", "Potentially Hazardous Asteroids" = "PHA",
       "Main Belt Asteroids" = "MBA", 
       "Outer Main Belt Asteroids" = "OMB", 
       "Mars-crossing Asteroids" = "MCA", 
       "Amor Asteroids" = "AMO", 
       "Inner Main Belt Asteroids" = "IMB", 
       "Jupiter Trojan Asteroids" = "TJN", 
       "Centaur Asteroids" = "CEN", 
       "Apollo Asteroids" = "APO", 
       "Aten Asteroids" = "ATE", 
       "Other Asteroids" = "AST", 
       "Trans-Neptunian Asteroids" = "TNO", 
       "Atira Asteroids" = "IEO", 
       "Halley-type Comets" = "HTC", 
       "Encke-type Comets" = "ETc", 
       "Jupiter-family Comets" = "JFc", 
       "Classic Jupiter-family Comets" = "JFC", 
       "Chiron-type Comets" = "CTc", 
       "Other Comets" = "COM", 
       "Parabolic Comets" = "PAR", 
       "Hyperbolic Comets" = "HYP")

models <- list("None" = "NONE", "Linear Regression per Orbital Class" = "LINEAR", "Linear Regression (overall)" = "LINEAR2", "Polynomial Regression by Orbital Class" = "LOESS", "Polynomial Regression (overall)" = "LOESS2")

shinyUI(
  fluidPage(
    # Application title
    titlePanel("JPL Asteroids and Comets Data Explorer"),
    
    sidebarLayout(
        # Sidebar with a slider input for number of bins
        sidebarPanel(
            tags$b("Initial panel may take several seconds to load, as the data set contains data on over 700,000 asteroids and comets!"),
            tags$br(),
            selectInput("confX", "X Values", choicesX, selected = "a"),
            selectInput("confY", "Y Values", choicesY, selected = "diameter"),
            selectInput("pop", "Population", population, selected = "Comet"),
            conditionalPanel(condition = "input.confY != 'popdensity'",
                 selectInput("model", "Model", models, "LINEAR"))
        ),
        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("confPlot")
        )
    )
  )
)
