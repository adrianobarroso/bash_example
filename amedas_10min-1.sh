#!/bin/sh
date_today_1ago=`date '+%Y%m%d' --date '1 day ago'`
date_1ago_year=`date '+%Y' --date '1 day ago'` 
date_1ago_month=`date '+%m' --date '1 day ago' | sed 's/^\(0\)\([1-9]\)$/\2/'` 
date_1ago_day=`date '+%d' --date '1 day ago' | sed 's/^\(0\)\([1-9]\)$/\2/'`

yyyy=2013
mm=09
#i=1
echo '------------------------------' > run_sh1018.log
for dd in 14 15 16 17
#for dd in 01 02 03
do
echo "Reading $yyyy$mm$dd " >> run_sh1018.log
date >> run_sh1018.log
#
AMEDAS_DATA=/home/dat/AMEDAS_10MIN
cat hoge.dat | while read line
do
prec=`echo $line | cut -c-2`
site=`echo $line | cut -c4-8`
sitecheck=`echo $line | cut -c4`
site_number=`echo ${sitecheck}`
#
echo $prec $site
echo $site_number
if [  $site_number -eq "0" ]; then
echo oooooooooooooo
site=`echo $line | cut -c5-8`
echo $site >> run_sh1018.log
if [ ! -d /TAKAYASU/wendi/GPV/amedas/data/${site} ];then
       mkdir /TAKAYASU/wendi/GPV/amedas/data/${site}
fi
#amedas_url="http://www.data.jma.go.jp/obd/stats/etrn/view/10min_a1.php?prec_no=$prec&block_no=$site&year=$date_1ago_year&month=$date_1ago_month&day=$date_1ago_day&elm=minutes&view="
amedas_url="http://www.data.jma.go.jp/obd/stats/etrn/view/10min_a1.php?prec_no=$prec&block_no=$site&year=$yyyy&month=$mm&day=$dd&elm=minutes&view="
         w3m $amedas_url | \
                tail -n149 | \
                head -n144 | \
                sed 's/^[[:space:]]\{12\}//g;' > /TAKAYASU/wendi/GPV/amedas/data/${site}/$yyyy$mm$dd.dat
else
if [ ! -d /TAKAYASU/wendi/GPV/amedas/data/${site} ];then
       mkdir /TAKAYASU/wendi/GPV/amedas/data/${site}
fi
echo $site >> run_sh1018.log
amedas_url="http://www.data.jma.go.jp/obd/stats/etrn/view/10min_s1.php?prec_no=$prec&block_no=$site&year=$yyyy&month=$mm&day=$dd&elm=minutes&view="
#amedas_url="http://www.data.jma.go.jp/obd/stats/etrn/view/10min_s1.php?prec_no=$prec&block_no=$site&year=$date_1ago_year&month=$date_1ago_month&day=$date_1ago_day&elm=minutes&view="
#echo $amedas_url
	w3m $amedas_url | \
		tail -n150 | \
		head -n144 | \
		sed 's/^[[:space:]]\{12\}//g;' > /TAKAYASU/wendi/GPV/amedas/data/${site}/$yyyy$mm$dd.dat
fi
done

done
