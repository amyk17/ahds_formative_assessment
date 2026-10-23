#!/bin/bash

###this script is used to process the data file within the specified directory and perform necessary checks on the file 

datadir="${1:-"../data/original"}"
echo "datadir is: [$datadir]"

#Checking the number of lines in the file
echo "number of lines in the body measures file:"
wc -l ${datadir}/BMX_D.csv

# checking the first 10 lines of the body measures file
echo "Checking the first 10 lines of the body measures file:"
head ${datadir}/BMX_D.csv

###Outputting the titles of the body measures file into a list
echo "Titles of the body measures file:"
head -n 1 ${datadir}/BMX_D.csv | tr -d '\r' | tr ',' '\n'

####Checking the number of fields in the body measures file
echo "The number of fields in the body measures file:"
head -n 1 ${datadir}/BMX_D.csv | tr -d '\r' | tr ',' '\n' | wc -l

##Check the number of feilds all the way down the file

rows=$(awk -F, '{print NF}' ${datadir}/BMX_D.csv | grep -vx 28 | wc -l | tr -d ' ')
if [ $rows -eq 0 ]; then
    echo "All rows have 28 fields."
else
    echo "There are $rows rows that don't have 28 fields."
fi
