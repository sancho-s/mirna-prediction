#!/bin/bash

dir_sas=/group/im-lab/nas40t2/santiago/data/gtex/gtex-grms
dir_hw=/group/im-lab/nas40t2/hwheeler/cross-tissue/gtex-grms

for ichr in `seq 1 22`; do
  for f in ${dir_sas}/GTEx.chr$ichr.* ; do
    base=$(basename $f)
	f2=${dir_hw}/$base
	#echo diff $f2 $f ;
	#diff $f2 $f ;
	cmp -s $f2 $f ;
	if [ $? == 0 ] ; then
	  echo "Files $f2 and $f are equal"
	else
	  echo "FILES $f2 and $f DIFFER"
	fi
  done ;
done
for f in ${dir_sas}/GTEx.global.* ; do
base=$(basename $f)
f2=${dir_hw}/$base
#echo diff $f2 $f ;
#diff $f2 $f ;
cmp -s $f2 $f ;
if [ $? == 0 ] ; then
	echo "Files $f2 and $f are equal"
else
	echo "FILES $f2 and $f DIFFER"
fi
done ;
