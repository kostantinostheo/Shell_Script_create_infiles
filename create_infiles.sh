#!/bin/bash
set -e

function string_to_write()
{
  orio_gramatosiras_RID=$((RANDOM%5+1))
  orio_gramatosiras_names=$((RANDOM%11+1))
  dice=$(cat /dev/urandom | tr -dc '0-1' | fold -w 256 | head -n 1 | head --bytes 1)
  
  if [ $dice -ge 1 ];then #if>=1 
    label=EXIT
  else
    label=ENTER
  fi

  recordID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $orio_gramatosiras_RID | head -n 1)
  fname=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $orio_gramatosiras_names | head -n 1)
  lname=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $orio_gramatosiras_names | head -n 1)
  age=$((RANDOM%99+1))

  rand_disease_cell=$(cat /dev/urandom | tr -dc '0-4' | fold -w 256 | head -n 1 | head --bytes 1)
  disease=${d[rand_disease_cell]}

  final_string="${recordID} ${label} ${fname} ${lname} ${disease} ${age}"
  
}

function date_create()
{
  date="$((RANDOM%28+1))-$((RANDOM%12+1))-$((RANDOM%1+2010))"
}


one=1
args=("$@")
arg_1=${args[0]} #diseaseFile
arg_2=${args[1]} #countriesFile
arg_3=${args[2]} #dir_ name
arg_4=${args[3]} #numFilesPerDirectory
arg_5=${args[4]} #numRecordsFile

if [ ! -f countriesFile ]; then
  echo "File doesn't exist"
  exit 
fi

if [ ! -f diseaseFile ]; then
  echo "File doesn't exist"
  exit 
fi

if [ -z "$arg_1" ] || [ -z "$arg_2" ] || [ -z "$arg_3" ] || [ -z "$arg_4" ] || [ -z "$arg_5" ]; then
  echo "Argument missing"
  exit
fi 


echo "Please wait.."


input_country=$arg_1 #reading country file. part1
readarray -t c <$input_country #reading country file. par2

input_disease=$arg_2
readarray -t d <$input_disease

c_length=${#c[@]} #countries array length
len=$(($c_length-$one))

d_length=${#d[@]}
len_d=$(($d_length-$one))



for i in `seq 0 $len` #creating main folder with subfolders, each with countries name. 
do 
  
  mkdir -p $arg_3/${c[i]} #directories creation..!!  
  for j in `seq 1 $arg_4`
  do
    date_create #calling random date function
    touch $arg_3/${c[i]}/$date #creating file with random date name.
    for k in `seq 1 $arg_5`
    do
      string_to_write
      echo $final_string >> "$arg_3/${c[i]}/$date"
    done
  done
done

echo "Finished"
