import glob
import re

##creating a vector of all the pid files
accel_files = glob.glob("data/original/accel/accel-*.txt")
ACC_PID = [int(re.search(r"accel-(\d+).txt", f).group(1)) for f in accel_files]

rule all:
    input:
        "logs/1.txt",
        "logs/2.txt",
        "logs/3.txt",
        "logs/4.txt",
        "logs/5.txt",
        "logs/6.txt"

rule check_bmx:
    input:
        "data/original/BMX_D.csv"
    output:
        "logs/1.txt"
    shell:
        """
        cd code
        bash 01_data_processing_bm.sh > ../logs/1.txt
        """

rule check_accel:
    input:
        "logs/1.txt",
        expand("data/original/accel/accel-{pid}.txt", pid=ACC_PID)
    output:
        "logs/2.txt"
    shell:
        """
        cd code
        bash 02_data_processing_accel.sh > ../logs/2.txt
        """
    
rule fix_accel:
    input:
        "logs/2.txt"
    output:
        "logs/3.txt"
    shell:
        """
        cd code
        bash 03_data_correcting_accel.sh. > ..logs/3.txt
        """

rule sample_gen:
    input:
        "log/3.txt"
    output:
        "log/4.txt"
    shell:
        """
        cd code
        bash 04_sample_generation.sh > ../logs/4.txt
        """

rule analysis_sample:
    input:
        "log/4.txt"
    output:
        "log/5.txt"
    shell:
        """
        cd code
        Rscript 05_merging_datasets.R > ../logs/5.txt
        """

rule demo_merge:
    input:
        "log/5.txt"
    output:
        "log/6.txt"
    shell:
        """
        cd code
        Rscript 06_demo_merge.R > ../logs/6.txt
        """





