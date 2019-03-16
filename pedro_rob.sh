#!/bin/sh

# Input arguments year month day
#
# Usage:
#   $bash pedro_rob.sh 2015 10 11
year=$1
month=$2
day=$3
echo -ne "\n\n Start scrap data for ${year}-${month}-${day} \n\n"

DATA_DIR=data
mkdir -p $DATA_DIR

baseurl=http://www.data.jma.go.jp/obd/stats/etrn/view/10min_a1.php
url=${baseurl}\?prec_no\=11\&block_no\=1284\&year\=${year}\&month\=${month}\&day\=${day}\&elm\=minutes\&view\=

echo -ne "\n\n Download html and scrap data \n Showing first 10 lines scrapped...\n"
echo -ne '------------------------------\n\n'
data=$(curl $url | \
          tail -n180 | \
          head -n160 | \
          grep "tr class=\"mtx\"" | \
          grep td | \
          sed 's/<[^>]*[>]/,/g' | \
          sed 's/,*,/,/g' | \
          awk -F, '{print year$0final}'  year="${year}-${month}-${day}" final="__breakline__" | \
          sed 's/,__breakline__/\\n/g' | \
          sed 's/ //g')

echo -ne $data | head -n10

file_output=$DATA_DIR/${year}_${month}_${day}.csv

echo -ne '------------------------------'
echo -ne "\n\n Persist data on file ${file_output} \n"
echo -ne '------------------------------\n\n'
echo -ne "day,time,precipitation,temperature,mean_wind_speed,mean_wind_speed,mean_wind_dir,max_wind_speed,max_wind_dir,sunshine\n" > $file_output
echo -ne $data >> $file_output


echo -ne "\n\n Finish\n"
echo -ne '------------------------------\n\n'