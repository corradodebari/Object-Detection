#!/bin/bash
if [ -z "$1" ]
then
   docker build --no-cache -t objdetect .
   #docker build  -t objdetect .
else
   docker build --no-cache -t $1 .
fi
