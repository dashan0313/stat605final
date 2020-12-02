rm(list=ls())

args = (commandArgs(trailingOnly=TRUE))
if (length(args) == 2){
  review_file = args[1]
  category_list = args[2]
} else {
  cat('usage: Rscript count_bigrams.R <review_file> <category list>')
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
all_category = readLines(category_list)

################ bigrams #######################

for (i in 1:22) {
  review_category = filter(review, grepl(all_category[i], category))
  # tokenization bigrams
  review_category_bigrams = review_category %>%
    unnest_tokens(bigram, text, token = "ngrams", n=2)
  # filter stopwords
  filtered_bigrams = strsplit(review_category_bigrams$bigram, " ") %>%
    unlist() %>%
    matrix(ncol=2, byrow=TRUE) %>%
    as.data.frame() %>%
    filter(!V1 %in% stop_words$word) %>%
    filter(!V2 %in% stop_words$word) %>%
    mutate(bigram=paste(V1,V2))
  # count
  popular_bigrams = filtered_bigrams %>% 
    count(bigram, sort = TRUE) %>%
    slice(seq_len(100)) %>%
  
  write.csv(popular_bigrams, file = paste(gsub(".tsv", "_", review_file), all_category[i], "_top10.csv", sep = ""), row.names = F)
}
