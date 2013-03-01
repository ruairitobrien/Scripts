#!/bin/bash

# Author: Ruairi O Brien
# 20-February-2013
# Script to sync scripts to staging server. Only works for my user.

rsync -azvv -e ssh /home/ruairi/Scripts/FSUtilsTests/ ruairi@10.73.66.99:/home/ruairi/fsUtilsTest

rsync -azvv -e ssh ruairi@10.73.66.99:/home/ruairi/fsUtilsTest/OUTPUTS /home/ruairi/TestOutputs/ 
