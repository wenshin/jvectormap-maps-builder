#!/bin/sh

# 使用说明：
# * converter.py 的参数说明：
#   http://stackoverflow.com/questions/11068645/how-to-generate-a-new-map-for-jvectormap-jquery-plugin/13520307#13520307
# * 测试，程序会自动生成测试html并保存到../tests/目录下

# 地图Polygon数据资源下载:
# http://www.naturalearthdata.com/downloads/
# http://www.gadm.org/country


USAGE="Usage: pbuild.sh <map type> <country name index> <country code index> <country code> <中央经纬度> <where conditions>\n\
Example: ./pbuild.sh ne_10m_admin_1_states_provinces 12 5 cn 105 \"iso_a2='cn' or iso_a2='tw'\""

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

# NAME 通常使用国家的ISO两位数字编码
# http://userpage.chemie.fu-berlin.de/diverse/doc/ISO_3166.html
NAME=$4

# 要生成居中的局部地图，需要提供中央经纬度（--longitude0 地图中心经度值）
# 数据来确定如何把地图居中。
# 可在 http://www.travelmath.com/country/United+States 网站查询
lng0=$5

# WHERE 同SQL语句中的WHERE，用于筛选要转换成 jVectormap 地图数据的地图范围
# 如拼接中国和台湾：--where "iso_a2='cn' or iso_a2='tw'"
WHERE=$6

# 使用的语言，TODO：如何支持cn？
lang=en

echo 'Start Convert'

python converter.py \
    --width 900 \
    --country_name_index $COUNTRY_NAME_INDEX \
    --country_code_index $COUNTRY_CODE_INDEX \
    --where "$WHERE" \
    --name $NAME \
    --longitude0 $lng0 \
    --language $lang \
    ../source/$MAP_TYPE/$MAP_TYPE.shp \
    ../maps/dist/jquery-jvectormap-${NAME}-mill-${lang}.js

echo 'Finished Convert'

TEST_FILE="../tests/$MAP_TYPE/${NAME}.html"
cat testProvinceCountry.html | sed "s/NAME/$NAME/g" | sed "s/MAP_TYPE/$MAP_TYPE/g" | sed "s/LANG/$lang/g" > $TEST_FILE

echo "Test file in $TEST_FILE"
