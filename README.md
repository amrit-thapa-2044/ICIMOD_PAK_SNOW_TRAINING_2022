# ICIMOD_PAK_SNOW_TRAINING_2022
This code is developed for a training entitled "Remote sensing and field-based glacier and snow monitoring in Pakistan".

Make sure that you have installed following R packages before you execute the script.

# R code starts from here (copy following code and run in R to install all packages required)

list.of.packages <- c("lubridate","ggplot2","rgdal","raster", "stringr","rstudioapi","MODIStsp")

new.packages <- list.of.packages[!(list.of.packages %in% 
                                     installed.packages()[,"Package"])] 

if(length(new.packages)) install.packages(new.packages, dependencies=TRUE)

# R code ends here
