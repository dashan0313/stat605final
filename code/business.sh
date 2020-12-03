cd ../data
tar -xf business_csv.tar
cd cdata/
for file in *
do 
  Rscript ../../code/business.r "$file"
done