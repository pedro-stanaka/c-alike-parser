#!/bin/sh

rm out.txt
touch out.txt

for filename in *
do
  echo -------- $filename ------------- | tee -a out.log
  ./$1 <  $filename | tee -a out.log
  echo 0000000 $filename 0000000000000 | tee -a out.log
  echo  | tee -a out.log
  echo  | tee -a out.log
  echo  | tee -a out.log
done;
