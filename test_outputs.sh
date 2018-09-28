#!/bin/bash

#cd to the example_data folder; $1 is the path to this directory

#TODO check to see if this works and exit immediately if it doesn't; same with other cd
cd "$1"

#unpack the test files
tar -xzf exome_workflow.tgz

#cd into the newly unpacked directory
cd exome_workflow

# unpack vcf | remove all header lines | extract columns 1-5; $2 refers to the final output vcf
/opt/htslib/bin/bgzip -cd expected.annotated.coding_variant_filtered.vcf.gz | /bin/grep -v "#" | /usr/bin/cut -f "1-5" > filtered_expected.txt
/opt/htslib/bin/bgzip -cd "$2" | /bin/grep -v "#" | /usr/bin/cut -f "1-5" > filtered_output.txt

#following structure is suggested from https://stackoverflow.com/a/7067911
diff filtered_expected.txt filtered_output.txt > /dev/null 2>&1
error=$?

#cleanup
rm filtered_expected.txt
rm filtered_output.txt
cd ..
rm -rf exome_workflow

if [ $error -eq 0 ]
then
    #no different, no major changes in workflow processing results
    exit 0
elif [ $error -eq 1 ]
then
    #different, major/breaking changes made to workflow
    exit 1
else
    #something is wrong with diff
    exit 2
fi
