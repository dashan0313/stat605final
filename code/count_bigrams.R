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

if (require("tidyr")) {
  print("Loaded package tidyr")
} else {
  print("Failed to load package tidyr")
}

# read review file
review = read.table(review_file, skip = 1, col.names = c("text", "category"))
all_category = readLines(category_list)

################ bigrams #######################

for (i in 1:22) {
  review_category = filter(review, grepl(all_category[i], category))
  # tokenization bigrams and filter stopwords
  review_category_bigrams = review_category %>%
    unnest_tokens(bigram, text, token = "ngrams", n=2) %>%
    separate(bigram, c("word1", "word2"), sep = " ") %>%
    filter(!word1 %in% stop_words$word) %>%
    filter(!word2 %in% stop_words$word) %>%
    unite(bigram, word1, word2, sep = " ")
  # count top 100 bigrams
  popular_bigrams = review_category_bigrams %>% 
    count(bigram, sort = TRUE) %>%
    slice(seq_len(100))
  write.csv(popular_bigrams, file = paste(review_file, all_category[i], "_top100.csv", sep = ""), row.names = F)
}
