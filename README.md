GettingAndCleaningData
======================
The R script run_analysis.R asumes that Samsung data is available in a directory named **dataset** which is at the same level as the script. For example in this GIT repo the script run_analysis is inside the top level directory. Right beside it is a directory named **dataset** that contains all raw data as downloaded from the project's page. The script prform step 1-5 described on the project's page as below. 

Step1:
------
The script reads feature data, subject IDs and feature IDs from respective filesin the sub-directories *test* and *train* of **dataset** directory.
It then merges the *test* and *train* data by stacking one data set above the other. The dataset created in this step has 2 additional columns for subject IDs and activity IDs.

Step2:
------
The script loads column names and numbers data from the file **features.txt** inside the **dataset** directory. The column names and numbers are adjusted to account for the two columns added in step1.
Column names are then filtered and only *mean* and *standard deviation* columns are retained. 

Step3:
------
The script loads activity names and IDs from **activity_labels.txt** inside the **dataset** directory and replaces activity IDs with their names in the dataset of step2.

Step4:
------   
In this step column names are set using the filtered out column names from step
2.


Step5:
------
In this step the script calculates the mean of all coulmns containing data. The mean is calculated for every pair of *Subject ID* and *Activity*. This tidy dataset is then written out to the file **tidydata.txt**.

Note:
-----
The source code is liberally commented. Steps 1 to 5 are carried out in differenrt functions called from *runAnalysis()*
 
   
