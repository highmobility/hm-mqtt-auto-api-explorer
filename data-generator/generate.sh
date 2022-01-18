#!/bin/sh
set -x
BASE_DIR=./test
CAPABILITIES_DIR=/data-example
TIMESTAMP=$(date '+%FT%H:%M:%SZ')



# Cleanup any existing data
rm -rf $BASE_DIR

# Create base directory
mkdir -p $BASE_DIR


for i in \
   1GCRCSEA4CZ1397 \
   1GCRCSEA4CZ1398 \
   1GCRCSEA4CZ1399 \
   1GCRCSEA4CZ1396 \
; do
  LONG=$(shuf -i 684776-687776 -n 1)
  LATI=$(shuf -i 408384-409384 -n 1)
  mkdir -p $BASE_DIR/$i
  cp $CAPABILITIES_DIR/* $BASE_DIR/$i
  sed -i "s/__TIMESTAMP__/$TIMESTAMP/g" $BASE_DIR/$i/*.json
  sed -i "s/__LONG__/$LONG/g" $BASE_DIR/$i/*.json
  sed -i "s/__LATI__/$LATI/g" $BASE_DIR/$i/*.json
  sed -i "s/__VIN__/$i/g" $BASE_DIR/$i/*.json
  search_dir=$BASE_DIR/$i
  for entry in "$search_dir"/*
  do
    echo $entry
    mosquitto_pub -h localhost -f $entry  -t "live/l13/87BAAAAAAAAAAAAAAAAA/$i/$(echo $entry | cut -d '.' -f2 | cut -d '/' -f4 )/get/$(echo $entry | cut -d'.' -f3)"
  done
done