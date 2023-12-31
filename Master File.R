##This file acts as a master file that organizes and loads the other R files necessary to conduct this analysis

#Load libraries (packages necessary for the analysis)
source("Libraries.R")

#Import the data necessary to calculate the amounts received by each specialty and the top 25 drugs/devices
source("Import & Clean Data.R")

#Get top earners per specialty (placed in a different file due to memory constraints,
#as determining the top earners requires the saving of a data.table containing 2013-2022
#data into a single object, which would is quite memory-intensive).
source("Top earners per specialty (Import & Clean Data).R")


#Designate a folder to save the output (Table & Figure)
folder <- your_folder #Please replace "your_folder" with the required directory
#Create the figures
#Table 1 (Specialties)
source("Table 1 (Specialties).R")
#Figure 2A (top drugs)
source("Figure 1A (Drugs).R")
#Figure 2A (top devices)
source("Figure 1B (Devices).R")
#Combine them into 2-panel figures
source("Create Figure 1.R")
