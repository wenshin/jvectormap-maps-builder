#!/bin/sh

# Generates jVectorMap maps from shapefiles.
# 
# Shapefiles files (i.e. dbf, shp and shx) must be available in a sub-folder
# under the source folder, e.g. source/ne_10m_admin_0_countries/ne_10m_admin_0_countries.shp
# Maps files will be saved in a sub-folder under 'maps', test files in a sub-folder under 'tests'.
# Use Quantum GIS to find out the indexes in the attribute tables.
# The source files must follow the <map type>/<map type>.<ext> format.
# This Use to generate maps with stats or provinces.

USAGE="Usage: pbuild.sh <map type> <country name index> <country code index> <country code> <中央经纬度>\n\
Example: ./pbuild.sh ne_10m_admin_1_states_provinces 12 5 us -97"

if [ $# -le 2 ]; then
  echo $USAGE
  exit 1
fi

MAP_TYPE=$1
COUNTRY_NAME_INDEX=$2
COUNTRY_CODE_INDEX=$3
FILTER=$4

rm -rf ../tests/$MAP_TYPE && rm -rf ../maps/$MAP_TYPE
mkdir -p ../tests/$MAP_TYPE && mkdir -p ../maps/$MAP_TYPE

# while read code; do
#   echo $code
#   ISO_CODE="$code"
#   python converter.py \
#   --width 900 \
#   --country_name_index $COUNTRY_NAME_INDEX \
#   --country_code_index $COUNTRY_CODE_INDEX \
#   --where "iso_a2='$ISO_CODE'" \
#   --name $ISO_CODE\
#   --language en \
#   ../source/$MAP_TYPE/$MAP_TYPE.shp \
#   ../maps/$MAP_TYPE/${MAP_TYPE}_${ISO_CODE}.js
#   
#   cat testProvinceCountry.html | sed "s/ISO_CODE/$ISO_CODE/g" | sed "s/MAP_TYPE/$MAP_TYPE/g" > ../tests/$MAP_TYPE/${MAP_TYPE}_${ISO_CODE}.html
# done < iso-codes.txt

ISO_CODE=$4
lng0=$5
lang=en
python converter.py \
    --width 900 \
    --country_name_index $COUNTRY_NAME_INDEX \
    --country_code_index $COUNTRY_CODE_INDEX \
    --where "iso_a2='$ISO_CODE'" \
    --name $ISO_CODE \
    --longitude0 $lng0 \
    --language $lang \
    ../source/$MAP_TYPE/$MAP_TYPE.shp \
    ../maps/dist/jquery-jvectormap-${ISO_CODE}-mill-${lang}.js

cat testProvinceCountry.html | sed "s/ISO_CODE/$ISO_CODE/g" | sed "s/MAP_TYPE/$MAP_TYPE/g" | sed "s/LANG/$lang/g" > ../tests/$MAP_TYPE/${ISO_CODE}.html
