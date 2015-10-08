#!/bin/bash

# #############################################################################

# This is a wrapper script to specify multiple locations to perform EMPA data 
#  formatting numerous times

# #############################################################################

filename_stems="Data/SKU_TS002_FSP_1_0_"

for filename_stem in "${filename_stems}" ; do

    ./Format_EMPA.sh "${filename_stem}"

    

done

mv *.tmp ~/.trash/.
