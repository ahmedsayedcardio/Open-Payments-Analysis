These files, in combination with the freely and publicly available Open Payments files (https://openpaymentsdata.cms.gov/datasets), can be used to recreate the results presented in "Industry Payments to US Clinicians, 2013-2022".

**A Brief Overview of the Files & Their Structure:**

1) The master file acts to organize and call the code from the other files.
2) The "Import & Clean Data.R" file will import the Open Payments data needed to calculate the specialties receiving the greatest payments (Figure 1A) and the top 25 drugs/devices (Figures 2A/B).
3) The "Top earners per specialty (Import & Clean Data).R" will import the Open Payments data needed to calculate the top-earning and median-earning physicians per specialty (Figure 1B).
4) The other files are named after their respective figures, and the "Create Figures 1 & 2.R" file simply merges them into 2 panel figures.
5) The "Unify Drugs.R" and "Unify Devices.R" files (which are called as part of the scripts which create the figures) serve to merge together records which refer to the same object in different ways.
6) The "Categories" file contains the data needed to categorize the top 25 drugs & devices.
7) The "Specialties Mapping" file contains the data needed to match the CMS-provided taxonomy listing to a given specialty.

If you have any questions related to the analysis or the code, please feel free to contact me (Ahmed Sayed) at the following email: asu.ahmed.sayed@gmail.com
