#!bin/bash

## Correcting any issues identified within the Accelerometer files so that they are all in a standard format

##Setting the directory
datadir=${1:-"../data/original/accel"}
echo "datadir is: [$datadir]"

##Finding the name of the first file in the accel folder
file_name=$(ls $datadir | head -n 1)
echo "Name of the first file in the accel folder: $file_name"

##Find what line the field names are on in the first accel file
echo "The first 10 lines of the first accel file:"
head -n 10 ${datadir}/${file_name}

###Finding the fields in the first accel folder
echo "The fields of the first accel file:"
head -n 2 ${datadir}/${file_name} | tr -d '\r' | tr -s ' ' '\n' | tail -n 1

### Checking all files have the same fields 
line2count=$(find "$datadir" -maxdepth 1 -name "*.txt" -exec awk 'FNR==2' {} + | tr -d '\r' | sort -u | wc -l )
echo " The number of unique header lines in all accel files : $line2count"

##Checking all files in accel have the same number of lines
linenumber=$(find "$datadir" -maxdepth 1 -name "*.txt" -exec wc -l {} + | awk '{print $1}' | sort -u | wc -l)
echo "The number of unique line counts in all accel files: $linenumber"

##Making a copy of the accel files before editing 
cp -R  ../data/original/accel ../data/derived/

##Changing directory to the derived folder
derdatadir=${1:-"../data/derived/accel"}

##Remove the ID line (first line) from all accel files
find "$derdatadir" -maxdepth 1 -name "*.txt" -exec sed -i '' '1d' {} +

###Creating new variable for first accel file of derived data
checking_file=$(ls $derdatadir | head -n 1)

###Print the first line to check ID has been removed in the first accel file
newline1=$(head -n 1 ${derdatadir}/${checking_file} | tr -d '\r')
echo "New first line of accel files: $newline1"

###Count the number of files with different headers
headers=$(find "$derdatadir" -maxdepth 1 -name "*.txt" -exec awk 'FNR==1' {} + | tr -d '\r' | sort -u | wc -l )
echo "The number of files with a unique header: $headers"

###Counting the number of files with NA as a value
num_na=$(find "$derdatadir" -maxdepth 1 -name "*.txt" -exec grep -lw "NA" {} + | wc -l | tr -d '')
echo "The number of accel files containing NA as a data point: $num_na"

###Removing all the lines that contain 3 NA in a row
find "$derdatadir" -maxdepth 1 -name "*.txt" -exec sed -i '' $'/NA\tNA\tNA/d' {} +

##Check files to see if NA rows have been removed correctly
num_na=$(find "$derdatadir" -maxdepth 1 -name "*.txt" -exec grep -lw "NA" {} + | wc -l | tr -d '')
echo "The number of accel files containing NA as a data point: $num_na"




