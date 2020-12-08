# library packages
library(dplyr)
library(ggplot2)

# read review data
active_life = read.table("output22/Active Life.tsv", col.names = c("stars", "text"))
# combine our output into one dataframe
active_lists = list.files('my_output',pattern = "Active\ Life")
active_df = data.frame(stars=c(), text=c())
for (i in 1:20) {
  active_bigram = read.csv(paste("my_output/", active_lists[i], sep = ""))
  star = strsplit(active_lists[i], split = "_")[[1]][3]
  active_bigram$stars = rep(star, 100)
  active_df = rbind(active_df, active_bigram)
}
# sum words in different years
active_count = aggregate(n ~ bigram + stars, data = active_df, FUN = sum)
# add word frequency
active_prob = active_count %>% 
  group_by(stars) %>%
  mutate(prob = n/sum(n)) %>%
  arrange(desc(prob)) %>%
  slice(seq_len(20)) %>%
  ungroup() %>%
  arrange(stars, prob) %>%
  mutate(row = row_number())

# word frequency plot by stars
active_prob %>%
  ggplot(aes(row, prob, fill = stars)) +
  geom_bar(show.legend = F, stat = "identity") +
  labs(x = NULL, y = "Word Frequency") +
  ggtitle("Popular Words of Active Life") + 
  facet_wrap(~stars, scales = "free") + 
  scale_x_continuous(  # This handles replacement of row 
    breaks = active_prob$row, # notice need to reuse data frame
    labels = active_prob$bigram) +
  coord_flip() #+ ggsave("Activelife_fre.png")

#
active_prob %>%
  arrange(bigram, star) %>%
  ggplot(aes(fill=as.factor(stars), y=prob, x=stars)) + 
  geom_bar(position="dodge", stat="identity") +
  ggtitle("Probability") +
  facet_wrap(~bigram) +
  theme(plot.title = element_text(color = "black", size = 12, face = "bold"), legend.position="none") +
  xlab("Star") +
  ylab("Probability")

# add logical variables based on presence of bigram
active_life$customer_service = grepl("customer service", active_life$text)
active_life$front_desk = grepl("front desk", active_life$text)
active_life$credit_card = grepl("credit card", active_life$text)
active_life$minutes = grepl("minutes", active_life$text)
active_life$parking_lot = grepl("parking lot", active_life$text)
active_life$free_weights = grepl("free weithgts", active_life$text)
active_life$staff = grepl("staff", active_life$text)
active_life$yoga_studio = grepl("yoga studio", active_life$text)
active_life$mini_golf = grepl("mini golf", active_life$text)

active_life %>%
  ggplot(aes(x=customer_service, y=stars, fill=customer_service)) + 
  geom_boxplot(alpha=0.8) + 
  theme(plot.title = element_text(color = "black", size = 12, face = "bold"), legend.position = "none") +
  labs(x = "", y = "Stars") +
  ggtitle("Boxplot of ")

model = lm(stars~credit_card+minutes+parking_lot+
             yoga_studio+mini_golf+customer_service+staff+
             customer_service:staff,
           data = active_life)
summary(model)

model = MASS::polr(factor(stars, ordered = T)~.-text, data = active_life, Hess = T)
summary(model)
ctable <- coef(summary(model))
p <- pnorm(abs(ctable[, "t value"]), lower.tail = FALSE) * 2
ctable <- cbind(ctable, "p value" = p)
ctable
coef(model) %>% exp()
