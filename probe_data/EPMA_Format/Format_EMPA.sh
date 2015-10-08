#!/bin/bash

# ###########################################################################

# A script to process and format data from the SX100 Electron Probe
echo -en "\n**** Format_EMPA.sh v0.1 ****\n\nReformatting SX100 probe data to a standard format\n\n"

# ###########################################################################

# Determine the filename stem for input files


if [[ -n $1 ]] ; then
    filename_stem=$1
else
    read -p "Filename stem: " filename_stem
fi

# Manual Switch
#filename_stem=


# Store oxide data file location
oxide_input="${filename_stem}"oxide.txt
errors_input="${filename_stem}"error.txt
detlim_input="${filename_stem}"detlim.txt
metadata_input=EMPA_Metadata.txt

echo -en "Oxide Filename:            \n    ${oxide_input}\n"
echo -en "Errors Filename:           \n    ${errors_input}\n"
echo -en "Detection Limits Filename: \n    ${detlim_input}\n"
echo -en "Metadata File:             \n    ${metadata_input}\n\n"

# Store metadata in shell variables
echo -en "Reading in metadata\n\n"
Ref_number=$(awk '
    BEGIN{FS=","}
    NR==1 {print $2}
    ' $metadata_input)
Sample_number=$(awk '
    BEGIN{FS=","}
    NR==2 {print $2}
    ' $metadata_input)
Volcanic_zone=$(awk '
    BEGIN{FS=","}
    NR==3 {print $2}
    ' $metadata_input)
System=$(awk '
    BEGIN{FS=","}
    NR==4 {print $2}
    ' $metadata_input)
Eruption=$(awk '
    BEGIN{FS=","}
    NR==5 {print $2}
    ' $metadata_input)
Location=$(awk '
    BEGIN{FS=","}
    NR==6 {print $2}
    ' $metadata_input)
Phase=$(awk '
    BEGIN{FS=","}
    NR==7 {print $2}
    ' $metadata_input)
Phase_number=$(awk '
    BEGIN{FS=","}
    NR==8 {print $2}
    ' $metadata_input)
Point_number=$(awk '
    BEGIN{FS=","}
    NR==9 {print $2}
    ' $metadata_input)
Core_rim=$(awk '
    BEGIN{FS=","}
    NR==10 {print $2}
    ' $metadata_input)
Profile_distance=$(awk '
    BEGIN{FS=","}
    NR==11 {print $2}
    ' $metadata_input)
Pheno_xeno_nod_gm=$(awk '
    BEGIN{FS=","}
    NR==12 {print $2}
    ' $metadata_input)
Texture=$(awk '
    BEGIN{FS=","}
    NR==13 {print $2}
    ' $metadata_input)
Inclusion=$(awk '
    BEGIN{FS=","}
    NR==14 {print $2}
    ' $metadata_input)
Hostref=$(awk '
    BEGIN{FS=","}
    NR==15 {print $2}
    ' $metadata_input)
Machine=$(awk '
    BEGIN{FS=","}
    NR==16 {print $2}
    ' $metadata_input)
Lab=$(awk '
    BEGIN{FS=","}
    NR==17 {print $2}
    ' $metadata_input)
Analyst=$(awk '
    BEGIN{FS=","}
    NR==18 {print $2}
    ' $metadata_input)

# Extract data only for each of Oxides, Errors and Detection Limits
echo -en "Extracting data from Quanti files\n\n"
for input in oxides errors detlims ; do

    if [[ $input = "oxides" ]] ; then
	data=$oxide_input
    elif [[ $input = "errors" ]] ; then
	data=$errors_input
    elif [[ $input = "detlims" ]]; then
	data=$detlim_input
    fi
    
    awk '
        BEGIN{OFS","}
	{if ($1 == "DataSet/Point") {
	    start=NR}
	}
	{if (NR == FNR) {
	    end=FNR}
	}
	i=start
	{while (i < end) {	
	    if (NR == i) {
	         print $0}
	    i++
            }
	}
	' $data > $input.tmp
done

# Check that the length of all the files is the same. If not then exit
echo -en "Checking files are same length\n\n"
lines_oxides=$(wc -l oxides.tmp | awk '{print $1}')
lines_errors=$(wc -l errors.tmp | awk '{print $1}')
lines_detlims=$(wc -l detlims.tmp | awk '{print $1}')

if [[ $lines_oxides != $lines_errors && $lines_errors != $lines_detlims ]] ; then
    echo "Input Files are not the same size - Something is wrong - EXITING"
    exit
fi



# Create Headers for Oxide Data
echo "Ref_number,Sample_number,Volcanic_zone,System,Eruption,Location,Phase,Phase_number,Point_number,Core_rim,Profile_distance,Pheno_xeno_nod_gm,Texture,Inclusion,Hostref,Machine,Lab,Analyst,Comment,Point,Date,Notes,SiO2,TiO2,Al203,Cr2O3,V2O3,Fe2O3,FeO,MnO,MgO,CaO,Na2O,K2O,P2O5,NiO,SO2,F,Cl,Total," > formatted_oxides.tmp
echo "SiO2_err,TiO2_err,Al2O3_err,Cr2O3_err,V2O3_err,Fe2O3_err,FeO_err,MnO_err,MgO_err,CaO_err,Na2O_err,K2O_err,P2O5_err,NiO_err,SO2_err,F_err,Cl_err," > formatted_errors.tmp
echo "SiO2_dl,TiO2_dl,Al203_dl,Cr2O3_dl,V2O3_dl,Fe2O3_dl,FeO_dl,MnO_dl,MgO_dl,CaO_dl,Na2O_dl,K2O_dl,P2O5_dl,NiO_dl,SO2_dl,F_dl,Cl_dl," > formatted_detlims.tmp


# Arrange oxides into the correct order
#  Scan file for each header then print out in order, replacing $1 values for
#  NANs with "NAN".
echo -en "Formatting data\n\n"
awk '
    BEGIN{FS="\t";OFS=","}
    NR==1
        {for (i=1;i<=NF;i++) {
            if ($i~/SiO2/) {
                e1[n1++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/TiO2/) {
                e2[n2++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/Al2O3/) {
                e3[n3++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/Cr2O3/) {
                e4[n4++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/V2O3/) {
                e5[n5++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/Fe2O3/) {
                e6[n6++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/FeO/) {
                e7[n7++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/MnO/) {
                e8[n8++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/MgO/) {
                e9[n9++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/CaO/) {
                e10[n10++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/Na2O/) {
                e11[n11++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/K2O/) {
                e12[n12++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/P2O5/) {
                e13[n13++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/NiO/) {
                e14[n14++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/SO2/) {
                e15[n15++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/Fl/) {
                e16[n16++]=i}
            }
        }
	{for (i=1;i<=NF;i++) {
            if ($i~/Cl/) {
                e17[n17++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/Total/) {
                e18[n18++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/Comment/) {
                e19[n19++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/Point#/) {
                e20[n20++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/Date/) {
                e21[n21++]=i}
            }
        }
        
    {for (i=0;i<n1;i++) 
        {printf"%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%3.4f,%s,%s,%s\n",$1,$e1[i],$e2[i],$e3[i],$e4[i],$e5[i],$e6[i],$e7[i],$e8[i],$e9[i],$e10[i],$e11[i],$e12[i],$e13[i],$e14[i],$e15[i],$e16[i],$e17[i],$e18[i],$e19[i],$e20[i],$e21[i]}
    }
    ' oxides.tmp|\
awk '
    BEGIN{FS=",";OFS=","}
    {for (i=0;i<=NR;i++) {
        nan[i]=$1; {
        for (j=0;j<=NF;j++) {
            sub(nan[i],"NAN")}
        }}
    }
    NR>2 {
        printf"%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%3.4f,\n","'${Ref_number}'","'${Sample_number}'","'${Volcanic_zone}'","'${System}'","'${Eruption}'","'${Location}'","'${Phase}'","'${Phase_number}'","'${Point_number}'","'${Core_rim}'","'${Profile_distance}'","'${Pheno_xeno_nod_gm}'","'${Texture}'","'${Inclusion}'","'${Hostref}'","'${Machine}'","'${Lab}'","'${Analyst}'",$20,$21,$22,"",$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19}
    ' >> formatted_oxides.tmp

# Arrange errors into the correct order
#  Scan file for each header then print out in order, replacing $1 values for
#  NANs with "NAN". 
awk '
    BEGIN{FS="\t";OFS=","}
    NR==1
        {for (i=1;i<=NF;i++) {
            if ($i~/Si/) {
                e1[n1++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/Ti/) {
                e2[n2++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/Al/) {
                e3[n3++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/Cr/) {
                e4[n4++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/V/) {
                e5[n5++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/Fe2/) {
                e6[n6++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/Fe/) {
                e7[n7++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/Mn/) {
                e8[n8++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/Mg/) {
                e9[n9++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/Ca/) {
                e10[n10++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/Na/) {
                e11[n11++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/K/) {
                e12[n12++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/P/) {
                e13[n13++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/Ni/) {
                e14[n14++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i=="S") {
                e15[n15++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i=="F") {
                e16[n16++]=i}
            }
        }
	{for (i=1;i<=NF;i++) {
            if ($i=="Cl") {
                e17[n17++]=i}
            }
        }      
    {for (i=0;i<n1;i++) 
        {printf"%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f\n",$1,$e1[i],$e2[i],$e3[i],$e4[i],$e5[i],$e6[i],$e7[i],$e8[i],$e9[i],$e10[i],$e11[i],$e12[i],$e13[i],$e14[i],$e15[i],$e16[i],$e17[i]}
    }
    ' errors.tmp |\
awk '
    BEGIN{FS=",";OFS","}
    {for (i=0;i<=NR;i++) {
        nan[i]=$1; {
        for (j=0;j<=NF;j++) {
            sub(nan[i],"NAN")}
        }}
    }
    NR>2 {
        printf"%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,\n", $2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18}
    ' >> formatted_errors.tmp

# Arrange detecion limits into the correct order
#  Scan file for each header then print out in order, replacing $1 values for
#  NANs with "NAN". 
awk '
    BEGIN{FS="\t";OFS=","}
    NR==1
        {for (i=1;i<=NF;i++) {
            if ($i~/Si/) {
                e1[n1++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/Ti/) {
                e2[n2++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/Al/) {
                e3[n3++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/Cr/) {
                e4[n4++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/V/) {
                e5[n5++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/Fe2/) {
                e6[n6++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/Fe/) {
                e7[n7++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/Mn/) {
                e8[n8++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/Mg/) {
                e9[n9++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/Ca/) {
                e10[n10++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/Na/) {
                e11[n11++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/K/) {
                e12[n12++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/P/) {
                e13[n13++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i~/Ni/) {
                e14[n14++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i=="S") {
                e15[n15++]=i}
            }
        }
        {for (i=1;i<=NF;i++) {
            if ($i=="F") {
                e16[n16++]=i}
            }
        }
		{for (i=1;i<=NF;i++) {
            if ($i=="Cl") {
                e17[n17++]=i}
            }
        }      
    {for (i=0;i<n1;i++) 
        {printf"%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f\n",$1,$e1[i],$e2[i],$e3[i],$e4[i],$e5[i],$e6[i],$e7[i],$e8[i],$e9[i],$e10[i],$e11[i],$e12[i],$e13[i],$e14[i],$e15[i],$e16[i],$e17[i]}
    }
    ' detlims.tmp|\
awk '
    BEGIN{FS=",";OFS","}
    {for (i=0;i<=NR;i++) {
        nan[i]=$1; {
        for (j=0;j<=NF;j++) {
            sub(nan[i],"NAN")}
        }}
    }
    NR>2 {
        printf"%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,%2.4f,\n", $2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18}
    ' >> formatted_detlims.tmp

# Horizontally concatenate formatted oxide data with errors and detection limits 


format_stem=$(echo ${filename_stem} | awk -F/ '{print $NF'})


echo -en "Stitching all the data together\n\n"
paste -d '\0' formatted_oxides.tmp formatted_errors.tmp formatted_detlims.tmp > "${format_stem}"formatted.csv

mv *.tmp ~/.trash/.

exit
