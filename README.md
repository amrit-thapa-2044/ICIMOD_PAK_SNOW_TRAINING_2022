# ICIMOD_PAK_SNOW_TRAINING_2022
This code is developed for a training entitled "Remote sensing and field-based glacier and snow monitoring in Pakistan".

Make sure that you have installed following R packages before you execute the script.

# R code starts from here (copy following code and run in R/RStudio to install all packages required)

list.of.packages <- c("lubridate","ggplot2","rgdal","raster", "stringr","rstudioapi","MODIStsp")

new.packages <- list.of.packages[!(list.of.packages %in% 
                                     installed.packages()[,"Package"])] 

if(length(new.packages)) install.packages(new.packages, dependencies=TRUE)

# R code ends here
Once above package sis installed you need to run MAIN_my_aoi_snow_modis_8_day_wgs84.R script to generate improved 8-day maximum snow cover product from MODIS 8-day standard
product (M*D10A2) for you area of interest

- user need to define start and end date
- provide extent of your area
- provide Earthdata login ID and password
