# TASK: generate improved MODIS 8-day snow cover product as explained in Muhammad and Sher (2020)
# Date: 2022-02-01
# Coded by amrit THAPA (amrit.thapa@icimod.org, aamrijnu@gmail.com)

#-------------------------------------------------------------------------------------------------

# clean working environment
rm(list=ls())

#import MODIStsp library to download data
library(MODIStsp)

# get details of all product that can be downloaded using MODIStsp package
MODIStsp_get_prodnames()

# get detail of MODIS snow cover product that we  are interested in
MODIStsp_get_prodlayers("M*D10_A2")

# the following library helps to set working directly automatically or you
# can also set the working directory manually using setwd command
library(rstudioapi)
setwd(dirname(getActiveDocumentContext()$path)) ;getwd() # automatic
#setwd('path to folder ICIMOD_PAK_SNOW_TRAINING_2022') # manual

# create a new directory inside root directory to store downloaded data
dir.create('downloaded_data')

# define variable to store path and call later on from main function
out_path='./downloaded_data'

# manual date selection, select the time period for which you want to download the data
s_date='2022.01.01'
e_date='2022.02.10'

# define extent of your area to crop output image
my_extent=c(74,35.8,76,37.1) # x1,y1,x2,y2

# provide your userID and password of earthdata login to download data. Without this you can not download the data
my_Earthdata_Login_userID="amrit2044"
my_Earthdata_Login_password="@mriT2044524"

# let's set the main function to download product using credentials that we defined in earlier steps
MODIStsp(gui             = FALSE, 
         out_folder      = out_path, 
         selprod         = "Snow_Cov_8-Day_500m (M*D10_A2)",
         sensor          = 'Both',
         bandsel         = c("MAX_SNW"),
         quality_bandsel = NULL,
         indexes_bandsel = NULL,
         user            = my_Earthdata_Login_userID ,
         password        = my_Earthdata_Login_password,
         start_date      = s_date, 
         end_date        = e_date, 
         spatmeth        = "bbox",
         out_format      = "GTiff",
         out_projsel     = "User Defined",
         output_proj     = 4326,
         out_res_sel     ="Native",
         resampling      ="near",
         bbox            = my_extent,
         verbose         = TRUE,
         compress        = "LZW",
         reprocess       = TRUE,
         delete_hdf      = TRUE,
         ts_format       = FALSE
)

# this compels the data download, the data will be there inside folder ./downloaded_data/Snow_Cov_8-Day_500m_v6/MAX_SNW 

# Now we implement different filters one by one

# the following code call temporal folder that is provided to you, 
# Output images are stored inside folder
source('./step_1_temporal_filter_8_day_product.R')

# this step call spatial algorithm and act on output created by temporal filter, 
# Output images are inside
source('./step_2_spatial_filter_8_day_product.R')

# finally we combine Aqua and Terra product to produce combined improved product
source('./step_3_modis_8_day_snow_combine_modified_2021_05_06.R')

# This completes the data download and its improvement. 
# The final product can be visualized and analyzed in any GIS software

#-------------------BEST WISHES -------------------------------------------------------
