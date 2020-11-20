#!/bin/bash

tail -n +2 business_use.csv | sed 's/,"/\t"/g' > business_use.tsv 
