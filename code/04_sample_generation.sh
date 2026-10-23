#!/bin/bash

###This script is being used generate the sample file for this study from the accelerometer files and the body measures file

##Setting the working directory
derived_data = "${1:-../data/derived}"
echo "The working directory is: $derived_data"

##Make a copy of the body measures data and move to the derived folder
cp -R ../data/original/BMX_D.csv ../data/derived

###Finding where the particpant ID is located in accel files
head -n3 "$derived_data/accel/$(ls "$derived_data/accel" | head -n1)" 

##count the number of files to check that its the same at the body measures data
bm_number=$( wc -l < "${derived_data}/BMX_D.csv")
echo "number of lines in the body measures file: $bm_number"

accel_number=$(ls "${derived_data}/accel/" | wc -l | tr -d '')
echo "the number of participants with accel files: $accel_number"

##