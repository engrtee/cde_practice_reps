
#!/bin/bash

# Create folders for incoming and all
mkdir -p incoming/
mkdir -p ready/
mkdir -p quarantine/


# To create a new file in the incoming folder, run the following command:
echo "transaction_id, customer_name, amount, date, type, status
1,John, 5000,17/05/1987,Savings,FullyActive
2,James,5001,17/06/1989,Current,Active" > incoming/testfile.csv




# To test that the file created successfully and has data
if [ -s incoming/testfile.csv ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] File created successfully and has data." >> logfile.txt
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] File creation failed or file is empty." >> logfile.txt
fi

# Transform 
# I need to log all the test output to a log file and if anyone fails it should stay but if they all succeed, it should move the final test file to quarantine folder


quality_pass=true
# I need to be able to confirm that the number of columns on the testfile equal six
if awk -F',' 'NR>1 && NF!=6 {fail=1} END {exit fail}' incoming/testfile.csv; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Column count check passed." >> logfile.txt
    quality_pass=true
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Column count check failed." >> logfile.txt
    quality_pass=false
fi


# To find blank lines or spaces
if grep "^$" incoming/testfile.csv; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Blank line check failed." >> logfile.txt
    quality_pass=false
else
   
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Blank line check passed." >> logfile.txt
    quality_pass=true
fi





if [ "$quality_pass" = "true" ]; then
    echo "All quality checks passed. Moving testfile.csv to Ready folder." >> logfile.txt
    mv incoming/testfile.csv ready/
else
    mv incoming/testfile.csv quarantine/
    echo "Quality checks failed. testfile.csv moved to quarantine folder." >> logfile.txt
fi