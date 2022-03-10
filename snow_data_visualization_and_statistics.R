# TASK: Derive snow statistics and visualize snow cover data
# Date: 2022-02-15
# Coded by amrit THAPA (amrit.thapa@icimod.org, aamrijnu@gmail.com)

#------------------------------------------------------------------------------------------------

# clean working environment
rm(list=ls())

# load required library and their dependencies
# if you still get library errro after installation, plese install all dependencies
library(raster)
library(rstudioapi)
setwd(dirname(getActiveDocumentContext()$path)) ;getwd()

# define path and make list of all tif data to be analyzed
data_path="./final_combined_product_after_5t_3s/"
tif_list=list.files(data_path,pattern='.tif$',full.names=T);tif_list

# load library to convert modis date to calender date
library(stringr)
modis_doy=as.numeric(str_sub(tif_list,-7,-5))
modis_year=as.numeric(str_sub(tif_list,-11,-8))
calender_date=(as.Date(modis_doy, origin = paste0(modis_year,"-01-01")))-1

# make stack of all tif images
rts_snow=stack(tif_list)
plot(rts_snow)

# derive frequencies of each class in tif image
snow_stat=freq(rts_snow,value=200,merge=T)
no_snow_stat=freq(rts_snow,value=25,merge=T)
cloud_stat=freq(rts_snow,value=50,merge=T)
snow_to_nosnow_cloud_stat=freq(rts_snow,value=-200,merge=T)

# count total pixels in raster to derive snow cover in percentage of total basin area
total_pixel_count=sum(!is.na(as.matrix(rts_snow[[1]])))

# store data in new dataframe.
df_export=data.frame(Date=calender_date,Snow_percent=snow_stat/total_pixel_count*100,
                     Nosnow_percent=no_snow_stat/total_pixel_count*100,
                     Cloud_percent=cloud_stat/total_pixel_count*100,
                     Snow2NosnowCloud_percent=snow_to_nosnow_cloud_stat/total_pixel_count*100)

# visualize output dataframe
print(df_export)

#ecport output dataframe as csv inside root/working directory
write.csv(df_export,'snow_statistics.csv',row.names=F)

# let's make a nice plot using ggplot and rasterVis and their dependencies
# make sure you have installed these libraries

# load required packages
library(ggplot2)
library(rasterVis)

# get first image from snow stack
r_i=rts_snow[[1]]

# reclassify raster to snow and no snow
r_i[r_i==200]=1
r_i[r_i!=1]=0

# quick check to see class in r_i, (this should have 0 and 1)
freq(r_i)

# make a nice plot
plot_combined_snow=gplot(r_i) + 
  geom_tile(aes(fill = as.factor(value))) +
  theme_bw()+
  ylab(NULL)+xlab(NULL)+
  theme(legend.position = 'bottom')+
  scale_fill_manual(name='Class',breaks = c(0,1),
                    values = c("grey", "dark blue"),labels=c('No Snow','Snow'))

# visualize plot
print(plot_combined_snow)

# export image in root directory
jpeg(file="sample_snow_plot.jpg",width=10, height=10, units="cm", res=500)
print(plot_combined_snow)
dev.off()

#---------------------good luck --------------------------------------------------


