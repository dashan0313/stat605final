#!/bin/bash
sed 's/^.*","business_id":"//g' review.json | sed 's/","stars":/\t/g' | sed 's/"useful":.*,"text":/\t/g' | sed 's/","date":/"\t/g' | sed 's/}$//g' > review_clean.tsv

