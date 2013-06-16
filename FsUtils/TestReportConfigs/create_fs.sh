#!/bin/bash

mkdir f
touch fs.info

# Generate files given specific a and m times
# $1 time - e.g. "12 days ago"
# $2 beginning of filename - e.g. a_15d
# $3 variable name - e.g. fifteenDaysAgo
# $4 number of files

function generate {
    files=""
    for i in $(eval echo "{1..$4}"); do 
        fName="$2_$i"

        touch -d "$1" f/$fName

        if [[ $i -eq $4  ]]; then
            files+="\"$fName\""
        else
            files+="\"$fName\" "
        fi    
    done
     

    if [ "$3" = "fifteenDaysAgo" ]; then
        echo $3
        #######################
        # Add the files > 25MB 
        #######################
   
        size=30        
        number=50

        for i in $(eval echo "{1..$number}"); do            
            fName="$i"_s""

            dd if=/dev/zero of=f/$fName bs=1M count=$size

            if [[ $i -eq $number ]]; then
                files+="\"$fName\""
                gtTwentyFiveFiles+="\"$fName\""
            else
                files+="\"$fName\" "
                gtTwentyFiveFiles+="\"$fName\""
            fi
        done    

        echo "greaterThanTwentyFiveMB=$number" >> fs.info
        echo "greaterThanTwentyFiveMBFiles=($gtTwentyFiveFiles)" >> fs.info
                       
        echo "$3=$[4 + $number]" >> fs.info

    else
        echo $4
        echo "$3=$4" >> fs.info
    fi


    echo "$3Files=($files)" >> fs.info
}


times=("12 days ago" "25 days ago" "72 days ago" \ 
        "4 months ago" "9 months ago" "15 months ago")

fNames=("f_15d" "f_16d_30d" "f_31d_90d" \
        "f_3m_6m" "f_6m_12m" "f_12m")

vars=("fifteenDaysAgo" "sixteenAndThirtyTwoDaysAgo" "thirtyTwoAndNinetyDaysAgo" \
        "threeAndSixMonthsAgo" "sixAndTwelveMonthsAgo" "overTwelveMonthsAgo")

num=2


#################################################################
# Covers files with accessed and modified times and files > 25MB
#################################################################
for i in {0..5}; do
    num=$[num*2]
    generate "${times[$i]}" "${fNames[$i]}" "${vars[$i]}" $num
done



############################
# Get totals
############################
total=$(ls -l f | wc -l)
echo "totalNumberOfFiles=$total" >> fs.info

# ${totalSize%?} will remove the dir name "f" after the size
totalSize=$(du -s f)
echo "totalSize=${totalSize%?}" >> fs.info



