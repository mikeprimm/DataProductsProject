
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)

cols <- c("H", "diameter", "albedo", "rot_per", "e", "a", "q", "i", "om", "w", "ma", "ad", "per", "per_y")
labels <- c("Absolute Magnitude", "Diameter (km)", "Albedo", "Rotation Period (hr)", "Eccentricity", "Semi-Major Axis (AU)", "Perihelion (AU)", "Inclination (deg)", "Longiture of ascending node (deg)", "Argument of perihelion (deg)", "Mean anomaly (deg)", "Aphelion (AU)", "Period (days)", "Period (years)")
choicesX <- list("Absolute Magnitude" = "H", "Diameter (km)" = "diameter", "Albedo" = "albedo", "Rotation Period (hr)" = "rot_per", "Eccentricity" = "e", "Semi-Major Axis (AU)" = "a", "Perihelion (AU)" = "q", "Inclination (deg)" = "i", "Longiture of ascending node (deg)" = "om", "Argument of perihelion (deg)" = "w", "Mean anomaly (deg)" = "na", "Aphelion (AU)" = "ad", "Period (days)" = "per", "Period (years)" = "per_y", "Orbital Class" = "class")
choicesY <- append(list("Population Density" = "popdensity", "Population Histogram" = "pophist"), choicesX)
population <- list("All Comets and Asterods" = "Both", "All Asteroids" = "Asteroid", "All Comets" = "Comet", "Near-Earth Objects" = "NEO", "Potentially Hazardous Asteroids" = "PHA",
       "Main Belt Asteroids (MBA)" = "MBA", 
       "Outer Main Belt Asteroids (OMB)" = "OMB", 
       "Mars-crossing Asteroids (MCA)" = "MCA", 
       "Amor Asteroids (AMO)" = "AMO", 
       "Inner Main Belt Asteroids (IMB)" = "IMB", 
       "Jupiter Trojan Asteroids (TJN)" = "TJN", 
       "Centaur Asteroids (CEN)" = "CEN", 
       "Apollo Asteroids (APO)" = "APO", 
       "Aten Asteroids (ATE)" = "ATE", 
       "Other Asteroids (AST)" = "AST", 
       "Trans-Neptunian Asteroids (TNO)" = "TNO", 
       "Atira Asteroids (IEO)" = "IEO", 
       "Halley-type Comets (HTC)" = "HTC", 
       "Encke-type Comets (ETc)" = "ETc", 
       "Jupiter-family Comets (JFc)" = "JFc", 
       "Classic Jupiter-family Comets (JFC)" = "JFC", 
       "Chiron-type Comets (CTc)" = "CTc", 
       "Other Comets (COM)" = "COM", 
       "Parabolic Comets (PAR)" = "PAR", 
       "Hyperbolic Comets (HYP)" = "HYP")

models <- list("None" = "NONE", "Linear Regression per Orbital Class" = "LINEAR", "Linear Regression (overall)" = "LINEAR2", "Polynomial Regression by Orbital Class" = "LOESS", "Polynomial Regression (overall)" = "LOESS2")

shinyUI(
  fluidPage(
    # Application title
    titlePanel("JPL Asteroids and Comets Data Explorer"),
    
    sidebarLayout(
        # Sidebar with a slider input for number of bins
        sidebarPanel(
            tags$p(tags$b("Initial panel may take several seconds to load, as the data set contains data on over 700,000 asteroids and comets!")),
            tags$p("Select values for presentation on X (horizontal) axis, and on Y (vertical) axis.  Y includes options for population density and histograms based on the number of objects with given values of the X axis attribute."),
            tags$p("Use the Population value to select from various subsets of asteroid and comet types"),
            tags$p("Use the Model value (not available for histogram and density) to select between different regression models for the data presented"),
            tags$p("For more help, see ", tags$a(href="Help.html","here")),
            selectInput("confX", "X Axis", choicesX, selected = "q"),
            selectInput("confY", "Y Axis", choicesY, selected = "popdensity"),
            selectInput("pop", "Population", population, selected = "Comet"),
            conditionalPanel(condition = "(input.confY != 'popdensity') && (input.confY != 'pophist')",
                 selectInput("model", "Regression Model", models, "LINEAR"))
        ),
        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("confPlot", height = "600px")
        )
    )
  )
)
