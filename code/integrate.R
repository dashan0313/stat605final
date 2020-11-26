library(plyr)

# combine all 2018_3 files
all_2018_files = list.files("results", pattern = "review_2018_3", full.names = T)
for (i in 1:22) {
  df1 = read.csv(all_files[i])
  df2 = read.csv(all_files[i+22])
  year = strsplit(all_files[i], split = "_")[[1]][2]
  score = strsplit(all_files[i], split = "_")[[1]][3]
  cate = strsplit(all_files[i], split = "_")[[1]][5]
  review = rbind(df1, df2)
  final = aggregate(.~ bigram, data = review, FUN = sum)
  final = final[order(-final$n), ]
  final = final[1:100, ]
  write.csv(final, file = paste("review",year,score,cate,"top100.csv", sep = "_"), row.names = F)
}

# add year, score and category to each file
all_files = list.files("results")
for (i in 1:length(all_files)) {
  df = read.csv(paste("results/", all_files[i], sep = ""))
  year = strsplit(all_files[i], split = "_")[[1]][2]
  score = strsplit(all_files[i], split = "_")[[1]][3]
  cate = strsplit(all_files[i], split = "_")[[1]][4]
  df$year = rep(year, 100)
  df$score = rep(score, 100)
  df$category = rep(cate, 100)
  write.csv(df, file = paste("results/", all_files[i], sep = ""), row.names = F)
}

# combine all files to a big one
final_count = ldply(list.files("results", full.names = T), read.csv)
write.csv(final_count, file = "final_bigram_counts.csv", row.names = F)
