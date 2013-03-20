#!/bin/bash

# Author: Ruairi O Brien
# 20-February-2013
# Script to sync scripts to staging server. Only works for my user.

RHEL564=10.73.66.99
RHEL532=10.73.66.100

HPUX=10.73.37.108



rsync --recursive -azvv -e ssh ~/Scripts/FSUtilsTests/ root@$HPUX:/test/fsUtilsTest

#rsync -azvv -e ssh ruairi@$RHEL564:~/fsUtilsTest/WORKING ~/RHEL564Working
#rsync -azvv -e ssh ruairi@$RHEL532:~/fsUtilsTest/WORKING ~/RHEL532Working


#rsync -azvv -e ssh ~/Scripts/FSUtilsTests/ ruairi@$RHEL564:~/fsUtilsTest

#rsync -azvv -e ssh ruairi@$RHEL564:~/fsUtilsTest/OUTPUTS ~/TestOutputs/OUTPUTS-64

#rsync -azvv -e ssh ruairi@$RHEL564:~/fsUtilsTest/WORKING/fsscan ~/TestOutputs/OUTPUTS-64/fsscan

#rsync -azvv -e ssh ruairi@$RHEL564:~/fsUtilsTest/WORKING/fsReport ~/TestOutputs/OUTPUTS-64/fsReport



#rsync -azvv -e ssh ~/Scripts/FSUtilsTests/ ruairi@$RHEL532:~/fsUtilsTest

#rsync -azvv -e ssh ruairi@$RHEL532:~/fsUtilsTest/OUTPUTS ~/TestOutputs/OUTPUTS-32

#rsync -azvv -e ssh ruairi@$RHEL532:~/fsUtilsTest/WORKING/fsscan ~/TestOutputs/OUTPUTS-64/fsscan

#rsync -azvv -e ssh ruairi@$RHEL532:~/fsUtilsTest/WORKING/fsReport ~/TestOutputs/OUTPUTS-32/fsReport


#rsync -azvv -e ssh ~/Scripts/gcc-4.7.2.tar.gz ruairi@$RHEL532:~/fsUtilsTest/gcc-4.7.2.tar.gz 

