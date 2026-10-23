#!/bin/bash

#This script is used to process data files within the specified directory and perform necessary checks upon the files. 

#Usage: ./dataProcessing.sh <directory_path>
dir="${1:-../data/original}"
echo "dir is: [$dir]"

## Checking all txt files within accel have the same column headers
echo "Checking all accel files have the same headings"
headercount=$(find "$dir" -maxdepth 1 -name "*txt" -exec awk 'FNR==1'| tr -d '\r' | sort -u | wc -l)

## Checks that the folder is usable and that the user has provided a directory path
if [[ -z "$dir" || ! -d "$dir" ]]; then
    echo "Usage: $0 <directory_path>"
    exit 1
fi

## Outputting the number of unique headers in the accel txt files
echo "Number of unique headers in accel files: $headercount"

##Output of whether all files share the same header or are inconsisent

if [ "$headercount" -eq 1 ]; 
then
    echo "All accel files have the same header."
else
    echo "Accel files have inconsistent headers."
fi

## Outputting the unique headers found across the accel txt files - with how many files use each header
if [ "$headercount" -ne 1 ];
then 
    echo "Unique headers found across accel files:"
    find "$dir" -maxdepth 1 -name "*.txt" -exec awk 'FNR==1' {} + | tr -d '\r' | sort | uniq -c | sort -rn
fi 


