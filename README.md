These files, in combination with the freely and publicly available Open Payments files (https://openpaymentsdata.cms.gov/datasets), can be used to recreate the results presented in Industry Payments to US Physicians by Specialty and Product Type", by Ahmed Sayed et al. (DOI: 10.1001/jama.2024.1989).

**A Brief Overview of the Files & Their Structure:**

1) The Quarto file in this directory contains all of the R code required to produce our results (text along with the corresponding table and figure).
2) The "Specialties Taxonomy" file contains the data needed to map the 231 provider specialties provided in the Open Payments file to a simplified 39-category classification.
3) Aside from these 2 files, we need a few others hosted by CMS:

    1) The Open Payments data:
                   

        1) 2013-2015 (Please rename to "General_Payments_XXXX", where XXXX is year (2013/2014/2015), once downloaded): https://www.cms.gov/priorities/key-initiatives/open-payments/data/archived-datasets
    
        2) 2016-2022 (Please rename to "General_Payments_XXXX", where XXXX is year (2016-2022), once downloaded): https://www.cms.gov/priorities/key-initiatives/open-payments/data/dataset-downloads
    
    3) The "Covered Recipient Supplement File for all Program Years" file. This file contains the data needed to match open payments IDs to National Provider Identifiers (NPIs) It can also be found at the same link as the 2016-2022 files (Please rename to "Provider_Info.csv" once downloaded): https://www.cms.gov/priorities/key-initiatives/open-payments/data/dataset-downloads
    
    2) The NPI files hosted by CMS, a registry of physcians in the US along with their corresponding NPI (please rename to "NPI File.csv" once downloaded): https://download.cms.gov/nppes/NPI_Files.html

The renaming of files is only necessary to allow the R code to run seamlessly without you having to change the file names in the Quarto file yourself.

If you have any questions related to the analysis or the code, please feel free to contact me (Ahmed Sayed) at the following email: asu.ahmed.sayed@gmail.com
