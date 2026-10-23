Analysis of Physical Activity Monitoring and Body Measures Documentation from the NHANES 2005-2006 cycle

This project involves 2 datasets from the 2005-2006 NHANES cohort study.
Contains 7455 data points from the Body Measures Documentation and 9951 Accelerometer files, which measures physical activity of participants.
This project aims to merge the 2 files together to create a list of particpants with both Acceleromete and Body Measures data.

Creating and activating the Conda environemnt:
1 - Install miniconda3 - check using:
 conda version
2- Activate Conda
conda activate
3- Create a new Conda envrionment 
conda create -n formative_assessment 
4- Activate the Conda environment made
conda activate formative_assessment
5- Install packages
conda install r-base=4.4.1
conda install r-tidyverse=2.0.0
6- export the current environment
conda export -- from history > formative_assessment.yml
7- return to the base environment
conda activate
8- Check the environment is available
conda env list 

