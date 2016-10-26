#! /bin/bash

[ -z "$1" ] || [ -z "$2" ] && echo "Usage: parsetoken.sh <token-csv-path> <token-field>" && exit 1

cat $1 | grep $2 | cut -d ',' -f 1
