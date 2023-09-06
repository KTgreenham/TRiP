# File to rename images


# Current directory
setwd(dirname(rstudioapi::getSourceEditorContext()$path))



# Rename C8 ----
# Rename images from camera 8 as they were saved in daily subfolders
## Cold 01 ----
cold01 <- "../ColdTrial01_Mar24/Metadata/C8/"  # Path
Cam08_cold01 <- list.files(cold01,recursive = TRUE) # List images
# Remove discarded images
id_discarded <- grep("discarded", Cam08_cold01)
Cam08_cold01 <- Cam08_cold01[-id_discarded]
# Sort list
Cam08_cold01 <- unlist(lapply(Cam08_cold01,sort,decreasing=FALSE))
# Add treatment
Cam08_cold01 <- paste0(cold01,Cam08_cold01)
Images_cold01 <- 1:length(Cam08_cold01) # Count
Images_cold01 <- sprintf("%04d", Images_cold01) # list them as 4digits
Images_cold01 <- paste0(cold01,"input/IMG_", Images_cold01,".JPG") # New names
# Create df with old and new names
df_cold01 <- data.frame(Cam08_cold01,Images_cold01) 
names(df_cold01) <- c("old_name","new_name")

## Cold 02 ----
cold02 <- "../ColdTrial02_Apr04/C8/"  # Path
Cam08_cold02 <- list.files(cold02,recursive = TRUE) # List images
# Remove discarded images
id_discarded <- grep("discarded", Cam08_cold02)
Cam08_cold02 <- Cam08_cold02[-id_discarded]
# Sort list
Cam08_cold02 <- unlist(lapply(Cam08_cold02,sort,decreasing=FALSE))
# Add treatment
Cam08_cold02 <- paste0(cold02,Cam08_cold02)
Images_cold02 <- 1:length(Cam08_cold02) # Count
Images_cold02 <- sprintf("%04d", Images_cold02) # list them as 4digits
Images_cold02 <- paste0(cold02,"input/IMG_", Images_cold02,".JPG") # New names
# Create df with old and new names
df_cold02 <- data.frame(Cam08_cold02,Images_cold02) 
names(df_cold02) <- c("old_name","new_name")

## Renaming ----
# CReate outpur dirs
Outcold01 <- "../ColdTrial01_Mar24/Metadata/C8/input/"
Outcold02 <- "../ColdTrial02_Apr04/C8/input/"
dir.create(Outcold01, recursive = TRUE, showWarnings = FALSE) 
dir.create(Outcold02, recursive = TRUE, showWarnings = FALSE)

# Combine both dfs
df_to_rename <- rbind(df_cold01,df_cold02)

# loop through each image file and rename it
for (i in 1:nrow(df_to_rename)) {
  
  # rename image file with sequential number and creation date
  old_name <- df_to_rename[i,"old_name"]
  new_name <- df_to_rename[i,"new_name"]
  file.rename(old_name, new_name)
}
