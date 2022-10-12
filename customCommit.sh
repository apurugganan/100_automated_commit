#!/usr/bin/env bash

echo "program starts"
read -ep "Enter a year or not(YYYY): " year
read -ep "Enter a month or not(MM): " month 
read -ep "Enter a day or not(DD): " day 

#  no entered values for date
if [[ -z $year ]] 
then 
  year=`date +%Y`
fi 

if [[ -z $month ]]
then 
  month=`date +%m`
fi 

if [[ -z $day ]] 
then 
  day=`date +%d`
fi 

# make a record
if [[ ! -d ./record ]]
then 
  touch ./record
fi

# check last line of file
if [[ -z $(tail -n 1 ./record) ]]
then 
  last=
else
  last=$(tail -n 1 ./record)
fi

# get value
declare -i value=$(node.exe ./binary.js $last)
printf "%08d\n" $value >> record

# check if there is a repo
if [[ ! -d ./.git ]]
then 
  echo "git repo not found"
  echo "initializing repository..."
  sleep 2
  git init
fi

# let's git
git status
git add . 
git status
git commit -m $(printf "%08d\n" "$value") --date="$year-$month-$day"
git log --oneline

read -p "press enter to proceed"

# must have repository online
git push 