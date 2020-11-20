# Stat605 Final Project
UW-Madison Stat605 final group project.

# Group Members:

* Jingshan Huang
* Xiangyu Wang
* Zijin Wang
* Yicen Liu
* Yuan Cao

# Prime Goal

Analyse Yelp dataset

# join review.json with business_use.csv
## 1.transfer them to .tsv file with code/clean_review_tsv.sh code/business_to_tsv.sh
## 2.split review_clean.tsv into 3 subfiles with code: split -d -n 3 review_clean.tsv
## 3.for each subfiles review_0x, do 'join -j 1 <(sort review_0x) <(sort business_use.tsv) > review_join_0x'
## 4.cat review_join_00 review_join_01 review_join_02 > review_join.tsv


# useful tips for files in code/

## clean_review.sh

usage: ./clean_review.sh

change file review.json to review_clean.csv with 4 cols: business_id,stars,text,date
