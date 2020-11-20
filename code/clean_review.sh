#!/bin/bash
sed 's/^.*","business_id":"//g' review.json | sed 's/","stars":/,/g' | sed 's/"useful":.*,"text"://g' | sed 's/","date":/",/g' | sed 's/}$//g' > review_clean.csv

