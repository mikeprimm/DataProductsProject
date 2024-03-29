
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)
library(ggplot2)

setClass("myNumeric")
setAs("character","myNumeric", function(from) as.numeric(from) )
colnames <- c("numeric", "numeric", "myNumeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "factor", "factor", "factor")
# Data from JPL Small-Body Database
# Load data from NASA (stored locally)
#   Data acquired via two requests from http://ssd.jpl.nasa.gov/sbdb_query.cgi#x
#   1) for asteroids.csv.gz, based on Object Kind = "Asteroids"
#   2) for comets.csv.gz, based on Object Kind = "Comets"
#  In both cases, a consistent column set is requested for the output fields (so that the tables combine properly)
#   1) H (mag)
#   2) M1 (mag)
#   3) diameter (km)
#   4) albedo
#   5) rot_per (h)
#   6) e
#   7) a (AU)
#   8) q (AU)
#   9) i (deg)
#   10) Q (AU)
#   11) period (d)
#   12) NEO (Y/N)
#   13) PHA (Y/N)
#   14) orbit class
# In both cases, the received files are renamed and compressed using gzip
#
print("Load asteroids")
asteroids <- read.csv("asteroids.csv.gz", colClasses = colnames)
print("Load comets")
comets <- read.csv("comets.csv.gz", colClasses = colnames)
asteroids$type <- "Asteroid"
comets$type <- "Comet"
# Map total magnitude column to absolute magnitude (same as asteroids)
comets$H <- comets$M1
asteroids$M1 <- asteroids$H

print("Combine asteroids and comets")
combined <- rbind(asteroids, comets)
combined$type <- factor(combined$type)
combined$class <- factor(combined$class)
combined$neo <- combined$neo == "Y"
combined$pha <- combined$pha == "Y"
combined$a <- abs(combined$a)
print("Finish data preparation")

logchoices <- c("diameter", "a", "q", "ad")
cols <- c("H", "diameter", "albedo", "rot_per", "e", "a", "q", "i", "om", "w", "ma", "ad", "per", "per_y", "class", "popdensity")
labels <- c("Absolute Magnitude", "Diameter (km)", "Albedo", "Rotation Period (hr)", "Eccentricity", "Semi-Major Axis (AU)", "Perihelion (AU)", "Inclination (deg)", "Longiture of ascending node (deg)", "Argument of perihelion (deg)", "Mean anomaly (deg)", "Aphelion (AU)", "Period (days)", "Period (years)", "Class", "Population Density")
choices <- data.frame(id=cols, name=labels)

print("Start Shiny Server")
shinyServer(function(input, output) {

  selectedConf <- reactive({
      r <- combined
      if (input$pop == "NEO")
          r <- combined[combined$neo,]
      else if (input$pop == "PHA")
          r <- combined[combined$pha,]
      else if (input$pop == "Comet")
          r <- combined[combined$type == "Comet",]
      else if (input$pop == "Asteroid")
          r <- combined[combined$type == "Asteroid",]
      else if (input$pop == "Both")
          r <- combined
      else # Class
          r <- combined[combined$class == input$pop,]
      r
    })
    
  output$confPlot <- renderPlot({
      dat <- selectedConf();
      if (input$confY == "popdensity") {
          p <- ggplot(dat, aes_string(x = input$confX, color="class", fill="class")) + geom_density(alpha=0.5, trim=TRUE);
          if (input$confX %in% logchoices) {
              p <- p + scale_x_log10();
          }
          p <- p + ylab("Density")
      }
      else if (input$confY == "pophist") {
          p <- ggplot(dat, aes_string(x = input$confX, color="class", fill="class")) + geom_histogram(position="dodge", trim=TRUE);
          if (input$confX %in% logchoices) {
              p <- p + scale_x_log10();
          }
          p <- p + ylab("Population")
      }
      else {
          p <- ggplot(dat, aes_string(x = input$confX, y = input$confY, color="class")) + geom_point();
          if (input$model == "LINEAR") {
              p <- p + geom_smooth(method="lm")
          }
          else if (input$model == "LINEAR2") {
              p <- p + geom_smooth(method="lm", aes_string(x = input$confX, y = input$confY, color=NULL))
          }
          else if (input$model == "LOESS") {
              p <- p + geom_smooth(method="loess")
          }
          else if (input$model == "LOESS2") {
              p <- p + geom_smooth(method="loess", aes_string(x = input$confX, y = input$confY, color=NULL))
          }
          if (input$confX %in% logchoices) {
              p <- p + scale_x_log10();
          }
          if (input$confY %in% logchoices) {
              p <- p + scale_y_log10();
          }
          p <- p + ylab(choices[choices$id == input$confY,]$name)
      }
      p <- p + xlab(choices[choices$id == input$confX,]$name)
      p
  })
  
})
print("Shiny Server Started")
