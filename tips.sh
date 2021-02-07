#!/bin/bash

# Configuration - set to 1, if tips are loaded from the server...
TOTD_HTTP=0

# Default tips directory
TIPREPO=~/tips

# If no tips folder found in users home directory,
# use folder in current working directory
if [ ! -d $TIPREPO ] ; then
  TIPREPO=./tips
fi

TIPS=()

# Loop through files in a folder and
# save them to $TIPS array
for file in "$TIPREPO"/*
do
  # Capture file name only without path
  TIPS+=( "${file##*/}" )
done
# Get a random index 
rand=$[$RANDOM % ${#TIPS[@]}]

# Select tip file
SELECTED_TIP=${TIPS[$rand]}

# Create label
if [ $TOTD_HTTP -eq 1 ] ; then
  TIPLABEL="HTTP $SELECTED_TIP"
else
  TIPLABEL="$TIPREPO/$SELECTED_TIP"
fi

# Print out the tip
echo
echo "================================================"
echo " TIP OF TODAY ($TIPLABEL) "
echo "------------------------------------------------"
if [ $TOTD_HTTP -eq 1 ] ; then
  curl http://192.168.3.16/tips/$SELECTED_TIP 2>/dev/null
else
  if [ "$SELECTED_TIP" == lista.txt ] ; then 	
	# For some reason tr -d '\r' is needed, second shuf command will override 
	# first ones data otherwise
	FIRST_WORD=$(shuf -n 1 $TIPREPO/"lista.txt" | tr -d '\r')
	SECOND_WORD=$(shuf -n 1 $TIPREPO/"lista.txt" | tr -d '\r')
	echo "$FIRST_WORD on $SECOND_WORD"
  else
	cat $TIPREPO/$SELECTED_TIP
  fi
  
fi
echo "================================================"
echo
