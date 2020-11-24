rm(list=ls())

args = (commandArgs(trailingOnly=TRUE))
if (length(args) == 1){
  review_file = args[1]
} else {
  cat('usage: Rscript count_bigrams.R <review_file.tsv>')
  stop()
}

# load packages
if (require("tidytext")) {
  print("Loaded package tidytext")
} else {
  print("Failed to load package tidytext")
}

if (require("dplyr")) {
  print("Loaded package dplyr")
} else {
  print("Failed to load package dplyr")
}

# read review file
review = read.table(review_file, skip = 1, col.names = c("text", "category"))

################ bigrams #######################

# tokenization bigrams
review_bigrams = review %>%
  unnest_tokens(bigram, text, token = "ngrams", n=2)

# filter stopwords
filtered_bigrams = strsplit(review_bigrams$bigram, " ") %>%
  unlist() %>%
  matrix(ncol=2, byrow=TRUE) %>%
  as.data.frame() %>%
  filter(!V1 %in% stop_words$word) %>%
  filter(!V2 %in% stop_words$word) %>%
  mutate(bigram=paste(V1,V2))

# count
popular_bigrams = filtered_bigrams %>% 
  count(bigram, sort = TRUE) %>%
  slice(seq_len(10)) %>%
  select("bigram")

write.csv(popular_bigrams, file = paste(review_file, "_top10.csv", sep = ""), row.names = F)