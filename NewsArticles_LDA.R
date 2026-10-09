library(tm)
library(textstem)
library(topicmodels)
library(tidytext)
library(proxy)
library(colorspace)
library(RColorBrewer)
library(tidyverse)
library(wordcloud2)

#Get files directory and convert to corpus
article_files <- DirSource("C:/Users/adria/Desktop/Aaron DS master folder/STQD6114 Unstructured Data Analysis/Project 1/news_articles")
article_corpus <- VCorpus(article_files)

#Text pre-processing
##Step 0: Remove dynamic titles, locations, and dates for all 80 files
article_corpus <- tm_map(article_corpus, content_transformer(function(x) {
  # Collapse into a single string if the document was read as multiple lines
  x <- paste(x, collapse = "\n") 
  
  # Remove everything from the start of the file up to the end of the dateline.
  # We use sub() instead of gsub() to only target the very first match at the top of the file.
  x <- sub("(?s)^.*?[A-Z\\s-]+(?: \\([^)]+\\))?, [A-Za-z]+ \\d{1,2}\\s*[—-]\\s*", "", x, perl = TRUE)
  
  return(x)
}))

##Step 1: Remove contractions
article_corpus <- tm_map(article_corpus, content_transformer(function(x)
  gsub("n't", " not", x)))
article_corpus <- tm_map(article_corpus, content_transformer(function(x)
  gsub("'s|'re|'ve|'ll|'d|'m", "",x)))

##Step 2: Get rid of author name at end of article; remove emdash, hyphen, and author name (includes multiple words)
article_corpus <- tm_map(article_corpus, content_transformer(function(x)
  gsub("[-—]\\s*[\\w\\s]+$", "", x, perl = TRUE)))

##Step 3: lowercase, remove dash from content, punctuation, lemmatize, remove stopwords, strip whitespace
article_corpus <- tm_map(article_corpus, content_transformer(tolower))
article_corpus <- tm_map(article_corpus,content_transformer(function(x)
  gsub("-"," ",x)))
article_corpus <- tm_map(article_corpus, removePunctuation)

article_corpus <- tm_map(article_corpus, content_transformer(lemmatize_strings))

###Remove these words to get better distinction between topics
custom_words <- c("say","much","will","can","time","good")
all_stopwords <- c(stopwords("en"), custom_words)
article_corpus <- tm_map(article_corpus, removeWords, all_stopwords)
article_corpus <- tm_map(article_corpus, stripWhitespace)

#View sample and convert to document term matrix
content(article_corpus[[14]])
article_dtm <- DocumentTermMatrix(article_corpus)

#Perform LDA analysis
article_LDA <- LDA(article_dtm, k=2, control = list(seed = 1234))
article_LDA

#Extract per-topic-per-word probabilities
article_topics <- tidy(article_LDA, matrix="beta")
article_topics

#Find the top 15 most common terms for each topic
article_top_terms <- article_topics %>% 
  group_by(topic) %>%
  top_n(15, beta)  %>%
  ungroup() %>%
  arrange(topic, -beta)

article_top_terms %>%
  mutate(term = reorder(term, beta))%>%
  ggplot(aes(term,beta,fill = factor(topic))) +
  geom_col(show.legend = FALSE) + 
  facet_wrap(~ topic, scales = "free") + 
  coord_flip()

#Get the beta spread for each topic
beta_spread <- article_topics %>%
  mutate(topic = paste0("topic",topic)) %>%
  spread(topic, beta) %>%
  filter(topic1 > .003 | topic2 > .003) %>%
  mutate(log_ratio = log2(topic2/topic1))

beta_spread

beta_spread%>% 
  mutate(term=reorder(term,log_ratio))%>%
  ggplot(aes(term,log_ratio))+geom_col(show.legend=FALSE)+coord_flip()

#Estimate the document-topic probabilities
article_prob <- tidy(article_LDA, matrix="gamma")
article_prob

#write.csv(article_prob, "article_prob.csv", row.names = FALSE)

#[---WordCloud---]
#Get most frequent words
freq <- colSums(as.matrix(article_dtm))
length(freq)
ord <- order(freq, decreasing = TRUE)
freq[head(ord)]

#Get word frequency and convert to dataframe
word_freq <- tidy(article_dtm) %>%
  group_by(term) %>%
  summarise(Frequency = sum(count)) %>%
  #Filter for the top 50 most common words
  slice_max(Frequency, n = 50, with_ties = FALSE) %>%
  arrange(desc(Frequency)) %>%
  #Rename the column to match wordcloud2's expected format
  rename(Term = term)

head(word_freq)

wordcloud2(word_freq,size=0.5,color="random-light",backgroundColor="black")

#[---Confusion Matrix---]

#Determine the predicted topic for each document based on the highest gamma
lda_predictions <- article_prob %>%
  group_by(document) %>%
  slice_max(gamma, n = 1) %>% 
  ungroup() %>%
  #Convert document to numeric to easily map true categories
  mutate(document = parse_number(document)) %>%
  #Assign actual categories based on document topic split
  mutate(Actual = ifelse(document <= 40, "Sports", "Tech")) %>%
  #Map topic numbers to predicted names
  mutate(Predicted = ifelse(topic == 1, "Tech", "Sports")) #Topic 1 -> tech, topic 2 -> sports

#Count the frequencies for the confusion matrix
cm_data <- lda_predictions %>%
  count(Actual, Predicted) %>%
  #Fill in zero if any combination is missing
  complete(Actual, Predicted, fill = list(n = 0))

#Calculate overall accuracy to display in the plot subtitle
accuracy <- sum(cm_data$n[cm_data$Actual == cm_data$Predicted]) / sum(cm_data$n) * 100

#Plot the confusion matrix as a tile heatmap
ggplot(cm_data, aes(x = Predicted, y = Actual, fill = n)) +
  geom_tile(color = "white", lwd = 1.5, linetype = 1) +
  #Add the counts right in the middle of the tiles
  geom_text(aes(label = n), color = "black", size = 6, fontface = "bold") +
  #Use a clean color gradient (lighter colors for higher accuracy)
  scale_fill_gradient(low = "#e0f2fe", high = "#38bdf8", name = "Article Count") +
  theme_minimal(base_size = 14) +
  labs(
    title = "LDA Model Confusion Matrix",
    subtitle = paste0("Overall Classification Accuracy: ", round(accuracy, 2), "%"),
    x = "Predicted Category (by LDA Model)",
    y = "Actual Category (True Label)"
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    axis.text = element_text(face = "bold"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
  )

#head(article_prob$document)
