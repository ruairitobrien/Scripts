#!/bin/ksh


rm -rf testFiles
mkdir testFiles

function createFilesOver25MB {
	size=30        

        for i in $(eval echo "{1..10}"); do            
            currentFile="testFiles/over25mb-$i"         

            dd if=/dev/zero of=$currentFile bs=1M count=$size
           
        done    
}

function createAccessedAndModifiedWithin15Days {
	 for i in $(eval echo "{1..5}"); do 
        currentFile="testFiles/15days-$i"         
        touch -d "1 days ago" $currentFile        
    done
    for i in $(eval echo "{6..10}"); do 
        currentFile="testFiles/15days-$i"         
        touch -d "15 days ago" $currentFile        
    done
}

function createAccessedAndModifiedWithin16And30DaysAgo {
	 for i in $(eval echo "{1..10}"); do 
        currentFile="testFiles/16-30days-$i"         
        touch -d "16 days ago" $currentFile        
    done
    for i in $(eval echo "{11..20}"); do 
        currentFile="testFiles/16-30days-$i"         
        touch -d "30 days ago" $currentFile        
    done
}

function createAccessedAndModifiedWithin31And90DaysAgo {
	 for i in $(eval echo "{1..10}"); do 
        currentFile="testFiles/31-90days-$i"         
        touch -d "31 days ago" $currentFile        
    done
    for i in $(eval echo "{11..20}"); do 
        currentFile="testFiles/31-90days-$i"         
        touch -d "90 days ago" $currentFile        
    done
}

function createAccessedAndModifiedWithin3And6MonthsAgo {
	 for i in $(eval echo "{1..10}"); do 
        currentFile="testFiles/3-6months-$i"         
        touch -d "3 months ago" $currentFile        
    done
    for i in $(eval echo "{11..20}"); do 
        currentFile="testFiles/3-6months-$i"         
        touch -d "6 months ago" $currentFile        
    done
}

function createAccessedAndModifiedWithin6And12MonthsAgo {
	 for i in $(eval echo "{1..10}"); do 
        currentFile="testFiles/6-12months-$i"         
        touch -d "7 months ago" $currentFile        
    done
    for i in $(eval echo "{11..20}"); do 
        currentFile="testFiles/6-12months-$i"         
        touch -d "12 months ago" $currentFile        
    done
}

function createAccessedAndModifiedOver12MonthsAgo {
	 for i in $(eval echo "{1..10}"); do 
        currentFile="testFiles/over-12months-$i"         
        touch -d "13 months ago" $currentFile        
    done
    for i in $(eval echo "{11..20}"); do 
        currentFile="testFiles/over-12months-$i"         
        touch -d "36 months ago" $currentFile        
    done
}

createFilesOver25MB
createAccessedAndModifiedWithin15Days
createAccessedAndModifiedWithin16And30DaysAgo
createAccessedAndModifiedWithin31And90DaysAgo
createAccessedAndModifiedWithin3And6MonthsAgo
createAccessedAndModifiedWithin6And12MonthsAgo
createAccessedAndModifiedOver12MonthsAgo

rm reports/*
rm testFiles.dtl
	
./fsscan testFiles -dtl testFiles.dtl

./fsReport -dtl testFiles.dtl -cfg NFS_ed2.cfg -rdir reports
