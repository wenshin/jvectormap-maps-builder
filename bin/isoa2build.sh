#!/bin/sh

USAGE="Usage: build.sh <map type> <country name index> <country code index>\n\
Example: ./build.sh ne_10m_admin_0_countries 10 11\n\
Example: ./build.sh ne_10m_admin_1_states_provinces 4 0"

if [ $# -le 2 ]; then
  echo $USAGE
  exit 1
fi

MAP_TYPE=$1
COUNTRY_NAME_INDEX=$2
COUNTRY_CODE_INDEX=$3

rm -rf ../tests/$MAP_TYPE && rm -rf ../maps/$MAP_TYPE
mkdir -p ../tests/$MAP_TYPE && mkdir -p ../maps/$MAP_TYPE

while read code; do
    ISO_CODE=`echo $code | awk '{print tolower($0)}'`
  # ISO_CODE=$4
  python converter.py \
  --width 900 \
  --country_name_index $COUNTRY_NAME_INDEX \
  --country_code_index $COUNTRY_CODE_INDEX \
  --where "ISO_A2='$ISO_CODE'" \
  ../source/$MAP_TYPE/$MAP_TYPE.shp \
  ../maps/$MAP_TYPE/jquery-jvectormap-$ISO_CODE-mill-en.js

  cat isoa2-testfile.html | sed "s/ISO_CODE/$ISO_CODE/g" | sed "s/MAP_TYPE/$MAP_TYPE/g" > ../tests/$MAP_TYPE/$ISO_CODE.html
  echo "$ISO_CODE"
done < iso-a2-codes.txt
