# Title: Combine AQUA and TERRA images after applying tempotal and spatial filters
# Writer: amrit THAPA (amrit.thapa@icimod.org)
# Affiliation:  International Centre for Integrated Mountain Development (ICIMOD,http://www.icimod.org/)
# Date; 2019-01-01
# Disclamier: Use at your own risk
# Before proceeding make sure that you have run the script: (1.modis_8_day_snow_temporal_n_spatial_filter.R)


rm(list=ls())

library(raster);library(rstudioapi)
setwd(dirname(getActiveDocumentContext()$path)) ;getwd()

#------------------ combine aqua and terra after spatial (three times)-------------------------------------------------------------------------------

set.seed(123) 
#for creating simulations or random objects that can be reproduced

dir.create("final_combined_product_after_5t_3s")

#location for output
output_dir_combined=c("./final_combined_product_after_5t_3s/")
data_path=c('./spatial_filter_3_MOD10A2','./spatial_filter_3_MYD10A2/')

input_terra_after_3s=list.files(data_path[1],pattern='s_s_s_t_5img_MOD10_A2_',full.names=T)
input_aqua_after_3s=list.files(data_path[2],pattern='s_s_s_t_5img_MYD10_A2_',full.names=T)

library(stringr)
doy_terra=as.numeric(paste0(str_sub(input_terra_after_3s,-12,-9),str_sub(input_terra_after_3s,-7,-5)));head(doy_terra)
doy_aqua=as.numeric(paste0(str_sub(input_aqua_after_3s,-12,-9),str_sub(input_aqua_after_3s,-7,-5)));head(doy_aqua)

#make sure these (doy_terra and doy_aqua) are same

new_filename=paste0("AQUA_TERRA_8day_combined_5t_3s_",doy_aqua,".tif");head(new_filename)


for(i in 1:length(doy_aqua))
{  
  
  aqua=raster(input_terra_after_3s[i])
  terra=raster(input_aqua_after_3s[i])
  
  # we have 25, 50, and 200 in the terra and aqua products? if 200 in both then final 200, 
  # if 200 in one and 25 or 50 then final -200, and 25 and 50 as 25. what do you think
  
  # create empty raster 
  combined_aqua_terra=terra;combined_aqua_terra[]=NA
  
  # snow-snow combination results to snow
  idx_S_S<- values(aqua)==200 & values(terra)==200  #;table(idx_S_S)
  values(combined_aqua_terra)[idx_S_S]<-200
  
  # snow, no snow/cloud combination to -200
  idx_S_aqua_C_NS_terra<- values(aqua)==200 & ( values(terra)==50 |values(terra)==25 )  #;table(idx_S_aqua_C_NS_terra)
  values(combined_aqua_terra)[idx_S_aqua_C_NS_terra]<-(-200)
  
  # snow, no snow/cloud combination to -200
  idx_S_terra_C_NS_aqua<- values(terra)==200 & ( values(aqua)==50 |values(aqua)==25 ) #;table(idx_S_terra_C_NS_aqua)
  values(combined_aqua_terra)[idx_S_terra_C_NS_aqua]<-(-200)
  
  # cloud cloud combination result to cloud
  idx_CC<- values(aqua)==50 & values(terra)==50 #;table(idx_CC)
  values(combined_aqua_terra)[idx_CC]<-50
  
  #rest is no snow
  combined_aqua_terra[is.na(combined_aqua_terra)]=25
  
  writeRaster(combined_aqua_terra,filename=paste0(output_dir_combined,new_filename[i]),format="GTiff",overwrite=T,datatype='INT2S')
  print(paste0('improved aqua-terra combined for  ',doy_terra[i]))
}

######### THE END
# you may visualize the final output in any GIS software.Final images are inside folder "combined_product_after_5t_3s"

