#!/bin/bash

source $HOME/bin/no-commit-secrets.sh

LATLNG="34.2116,-118.2322"
KEY=$DARKSKY_API_KEY

JSON=`curl https://api.darksky.net/forecast/$KEY/$LATLNG?units=si 2> /dev/null`
TEMP=`echo $JSON | jq '.currently.temperature'`
SUMM=`echo $JSON | jq -r '.currently.summary'`

echo ${TEMP}C/$SUMM

