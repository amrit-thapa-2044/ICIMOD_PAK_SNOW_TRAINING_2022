#clean the working environment of RStudio
rm(list=ls())

# Load required library. Make sure that following packages are already installed.
library(raster)
library(rstudioapi)
setwd(dirname(getActiveDocumentContext()$path)) ;getwd()

data_path='./downloaded_data/Snow_Cov_8-Day_500m_v6/MAX_SNW'

MOD_list=list.files(data_path,pattern='MOD10_A2_',full.names=T)
#MOD_list
MYD_list=list.files(data_path,pattern='MYD10_A2_',full.names=T)
#MYD_list

r1_MOD10A2=raster(MOD_list[1])
#plot(r1_MOD10A2,main=names(r1_MOD10A2))
#freq(r1_MOD10A2)

r1_MYD10A2=raster(MYD_list[1])
#plot(r1_MYD10A2,main=names(r1_MYD10A2))
#freq(r1_MYD10A2)

#length(MOD_list)
#length(MYD_list)

dir.create("temporal_filter_MOD10A2");dir.create("temporal_filter_MYD10A2")
for_file_name_MOD10A2=list.files(data_path,pattern='MOD10_A2_',full.names=F)
for_file_name_MYD10A2=list.files(data_path,pattern='MYD10_A2_',full.names=F)

#location for output
output_dir_temporal=c("./temporal_filter_MOD10A2/","./temporal_filter_MYD10A2/")


for (j in 1:length(output_dir_temporal)){
  
  if(j==1){output_dir_temporal_j=output_dir_temporal[j];new_filename=for_file_name_MOD10A2;r_loop=MOD_list
  }else{output_dir_temporal_j=output_dir_temporal[2];new_filename=for_file_name_MYD10A2;r_loop=MYD_list}
  #print(output_dir_temporal_j)
  #print(j)
  
  #temporal_filter: maximum five images
  for (i in 3:(length(r_loop)-2)){
    
    t0=raster(r_loop[i-2])
    t1=raster(r_loop[i-1])
    t2=raster(r_loop[i])
    t3=raster(r_loop[i+1])
    t4=raster(r_loop[i+2])
    
    t0[t0==0 | t0==1 | t0==11 | t0==254 | t0==255]<-50 #cloud https://nsidc.org/data/MOD10A2 
    t0[t0==100]<-200 #snow 
    t0[t0==37 | t0==39]<-25 #no snow / land
    
    t1[t1==0 | t1==1 | t1==11 | t1==254 | t1==255]<-50 #cloud 
    t1[t1==100]<-200 #snow 
    t1[t1==37 | t1==39]<-25 #no snow / land
    
    t2[t2==0 | t2==1 | t2==11 | t2==254 | t2==255]<-50 #cloud 
    t2[t2==100]<-200 #snow 
    t2[t2==37 | t2==39]<-25 #no snow / land
    
    t3[t3==0 | t3==1 | t3==11 | t3==254 | t3==255]<-50 #cloud 
    t3[t3==100]<-200 #snow 
    t3[t3==37 | t3==39]<-25 #no snow / land
    
    t4[t4==0 | t4==1 | t4==11 | t4==254 | t4==255]<-50 #cloud 
    t4[t4==100]<-200 #snow 
    t4[t4==37 | t4==39]<-25 #no snow / land
    
    idx_SCS<- values(t2)==50 & values(t3)==200 & values(t1) == 200
    values(t2)[idx_SCS]<-200
    
    idx_LCL<- values(t2)==50 & values(t3)==25 & values(t1) == 25
    values(t2)[idx_LCL]<-25
    
    idx_SCL<- values(t2)==50 & values(t3)==25 & values(t1) == 200
    values(t2)[idx_SCL]<-25
    
    idx_LCS<- values(t2)==50 & values(t3)==200 & values(t1) == 25
    values(t2)[idx_LCS]<-200
    
    idx_CCL<- values(t2)==50 & values(t3)==25 & values(t1) == 50
    values(t2)[idx_CCL]<-25
    
    idx_CCS<- values(t2)==50 & values(t3)==200 & values(t1) == 50
    values(t2)[idx_CCS]<-200
    
    idx_LCC<- values(t2)==50 & values(t3)==50 & values(t1) == 25
    values(t2)[idx_LCC]<-25
    
    idx_SCC<- values(t2)==50 & values(t3)==50 & values(t1) == 200
    values(t2)[idx_SCC]<-200
    
    idx_CCC<- values(t2)==50 & values(t3)==50 & values(t1) == 50
    values(t2)[idx_CCC]<-values(t4)[idx_CCC]
    
    idx_CCCC<-values(t2)==50
    values(t2)[idx_CCCC]<-values(t0)[idx_CCCC]
    
    writeRaster(t2,filename=paste0(output_dir_temporal_j,"t_5img_",new_filename[i]),format="GTiff",overwrite=T,datatype='INT1U')
    print(paste0('temporal filter applied for image ',new_filename[i]))
  }
  
}

