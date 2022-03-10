rm(list=ls())

set.seed(123) 
#for creating simulations or random objects that can be reproduced

library(raster);library(rstudioapi)
setwd(dirname(getActiveDocumentContext()$path)) ;getwd()

#------------------ spatial 1st time-------------------------------------------------------------------------------

dir.create("spatial_filter_1_MOD10A2");dir.create("spatial_filter_1_MYD10A2")

#location for output
output_dir_spatial_1=c("./spatial_filter_1_MOD10A2/","./spatial_filter_1_MYD10A2/")
data_path=c('./temporal_filter_MOD10A2','./temporal_filter_MYD10A2/')

for_file_name_MOD10A2=list.files(data_path[1],pattern='t_5img_MOD10_A2_',full.names=F)
for_file_name_MYD10A2=list.files(data_path[2],pattern='t_5img_MYD10_A2_',full.names=F)

MOD_list=list.files(data_path[1],pattern='t_5img_MOD10_A2_',full.names=T)
MYD_list=list.files(data_path[2],pattern='t_5img_MYD10_A2_',full.names=T)


for (j in 1:length(output_dir_spatial_1)){
  
  if(j==1){output_dir_spatial_1_j=output_dir_spatial_1[j];new_filename=for_file_name_MOD10A2;r_loop=MOD_list
  }else{output_dir_spatial_1_j=output_dir_spatial_1[2];new_filename=for_file_name_MYD10A2;r_loop=MYD_list}
  #print(output_dir_spatial_1_j)
  #print(j)
  
  for (i in 1:length(r_loop))
  {
    snow_for_spatial=raster(r_loop[i])
    snow_for_spatial[snow_for_spatial == 50]<-NA
    s_filter <- focal(snow_for_spatial, w=matrix(1,3,3), fun=modal, na.rm=TRUE, NAonly=TRUE, pad=TRUE)
    # NAonly (logical). If TRUE, only cell values that are NA are replaced with the computed focal values
    # na.rm (logical). If TRUE, NA will be removed from focal computations. The result will only be NA if all focal cells are NA.
    # pad (logical). If TRUE, additional 'virtual' rows and columns are padded to x such that there are no edge effects. This can be useful when a function needs to have access to the central cell of the filter
    
    s_filter[is.na(s_filter)]<-50
    writeRaster(s_filter,filename=paste0(output_dir_spatial_1_j,"s_",new_filename[i]),format="GTiff",overwrite=T,datatype='INT1U')
    print(paste0('1st spatial filter completed for image ',new_filename[i]))
  }
}

#------------------ spatial 2nd time-------------------------------------------------------------------------------

rm(list=ls())
set.seed(123) 
#for creating simulations or random objects that can be reproduced

library(raster)
library(rstudioapi)
setwd(dirname(getActiveDocumentContext()$path)) ;getwd()

dir.create("spatial_filter_2_MOD10A2");dir.create("spatial_filter_2_MYD10A2")

#location for output
output_dir_spatial_2=c("./spatial_filter_2_MOD10A2/","./spatial_filter_2_MYD10A2/")
data_path=c('./spatial_filter_1_MOD10A2','./spatial_filter_1_MYD10A2/')

for_file_name_MOD10A2=list.files(data_path[1],pattern='s_t_5img_MOD10_A2_',full.names=F)
for_file_name_MYD10A2=list.files(data_path[2],pattern='s_t_5img_MYD10_A2_',full.names=F)

MOD_list=list.files(data_path[1],pattern='s_t_5img_MOD10_A2_',full.names=T)
MYD_list=list.files(data_path[2],pattern='s_t_5img_MYD10_A2_',full.names=T)


for (j in 1:length(output_dir_spatial_2)){
  
  if(j==1){output_dir_spatial_2_j=output_dir_spatial_2[j];new_filename=for_file_name_MOD10A2;r_loop=MOD_list
  }else{output_dir_spatial_2_j=output_dir_spatial_2[2];new_filename=for_file_name_MYD10A2;r_loop=MYD_list}
  #print(output_dir_spatial_2_j)
  #print(j)
  
  for (i in 1:length(r_loop))
  {
    snow_for_spatial=raster(r_loop[i])
    snow_for_spatial[snow_for_spatial == 50]<-NA
    s_filter <- focal(snow_for_spatial, w=matrix(1,3,3), fun=modal, na.rm=TRUE, NAonly=TRUE, pad=TRUE)
    # NAonly (logical). If TRUE, only cell values that are NA are replaced with the computed focal values
    # na.rm (logical). If TRUE, NA will be removed from focal computations. The result will only be NA if all focal cells are NA.
    # pad (logical). If TRUE, additional 'virtual' rows and columns are padded to x such that there are no edge effects. This can be useful when a function needs to have access to the central cell of the filter
    
    s_filter[is.na(s_filter)]<-50
    writeRaster(s_filter,filename=paste0(output_dir_spatial_2_j,"s_",new_filename[i]),format="GTiff",overwrite=T,datatype='INT1U')
    print(paste0('2nd spatial filter completed for image ',new_filename[i]))
  }
}

#-------------------------- spatial filter 3rd --------------------------------------------------------------------------
rm(list=ls())
set.seed(123) 
#for creating simulations or random objects that can be reproduced

library(raster)
library(rstudioapi)
setwd(dirname(getActiveDocumentContext()$path)) ;getwd()

dir.create("spatial_filter_3_MOD10A2");dir.create("spatial_filter_3_MYD10A2")

#location for output
output_dir_spatial_3=c("./spatial_filter_3_MOD10A2/","./spatial_filter_3_MYD10A2/")
data_path=c('./spatial_filter_2_MOD10A2','./spatial_filter_2_MYD10A2/')

for_file_name_MOD10A2=list.files(data_path[1],pattern='s_s_t_5img_MOD10_A2_',full.names=F)
for_file_name_MYD10A2=list.files(data_path[2],pattern='s_s_t_5img_MYD10_A2_',full.names=F)

MOD_list=list.files(data_path[1],pattern='s_s_t_5img_MOD10_A2_',full.names=T)
MYD_list=list.files(data_path[2],pattern='s_s_t_5img_MYD10_A2_',full.names=T)

for (j in 1:length(output_dir_spatial_3)){
  
  if(j==1){output_dir_spatial_3_j=output_dir_spatial_3[j];new_filename=for_file_name_MOD10A2;r_loop=MOD_list
  }else{output_dir_spatial_3_j=output_dir_spatial_3[2];new_filename=for_file_name_MYD10A2;r_loop=MYD_list}
  #print(output_dir_spatial_3_j)
  #print(j)
  
  for (i in 1:length(r_loop))
  {
    snow_for_spatial=raster(r_loop[i])
    snow_for_spatial[snow_for_spatial == 50]<-NA
    s_filter <- focal(snow_for_spatial, w=matrix(1,3,3), fun=modal, na.rm=TRUE, NAonly=TRUE, pad=TRUE)
    # NAonly (logical). If TRUE, only cell values that are NA are replaced with the computed focal values
    # na.rm (logical). If TRUE, NA will be removed from focal computations. The result will only be NA if all focal cells are NA.
    # pad (logical). If TRUE, additional 'virtual' rows and columns are padded to x such that there are no edge effects. This can be useful when a function needs to have access to the central cell of the filter
    
    s_filter[is.na(s_filter)]<-50
    writeRaster(s_filter,filename=paste0(output_dir_spatial_3_j,"s_",new_filename[i]),format="GTiff",overwrite=T,datatype='INT1U')
    print(paste0('3rd spatial filter completed for image ',new_filename[i]))
  }
}
  





