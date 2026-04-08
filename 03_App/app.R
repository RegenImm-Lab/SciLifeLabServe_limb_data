######################################################################
# 001: Loading Necessary Packages
######################################################################

library(shiny)
library(shinyhelper)
library(DT)
library(data.table)
library(ggdendro)
library(ggpubr)
library(Matrix)
library(magrittr)
library(ggplot2)
library(ggrepel)
library(hdf5r)
library(gridExtra)

######################################################################
# 002: Loading in UI and Server Scripts
######################################################################

source("ui.R") 
source("server.R")

# launch the app
shiny::runApp(".", launch.browser = TRUE)

