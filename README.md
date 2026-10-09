# 📰 Latent Dirichlet Analysis of News Articles

A compact R-based project for exploring topic modeling on a collection of news articles using Latent Dirichlet Allocation (LDA). The repository preprocesses text, builds a document-term matrix, fits an LDA model, and visualizes topic distributions and classification results.

## ✨ What this project does

- Cleans and normalizes raw news article text
- Removes boilerplate metadata such as dates, author naming patterns, and punctuation
- Lemmatizes words and removes stopwords
- Builds a term-document matrix for topic modeling
- Fits LDA models to discover latent topics
- Generates topic-term plots, word clouds, and confusion matrices
- Compares the model's predicted topic labels with article categories

## 🗂️ Repository contents

- `NewsArticles_LDA.R` — LDA implementation using the standard method
- `NewsArticles_LDA_Gibbs.R` — LDA implementation using Gibbs sampling
- `News Articles.zip` — archive containing the source article dataset
- `README.md` — project overview and instructions

## 🧠 Project objective

This project analyzes a set of news articles and groups them into latent themes using LDA. In particular, the workflow separates article content into broad topic groups and evaluates how well the model aligns with known article categories such as sports and technology.

## 🛠️ Requirements

This project is built in R and relies on the following packages:

- `tm`
- `textstem`
- `topicmodels`
- `tidytext`
- `proxy`
- `colorspace`
- `RColorBrewer`
- `tidyverse`
- `wordcloud2`

Install them with:

```r
install.packages(c(
  "tm", "textstem", "topicmodels", "tidytext", "proxy",
  "colorspace", "RColorBrewer", "tidyverse", "wordcloud2"
))
```

## ▶️ How to run

1. Extract `News Articles.zip` to a local folder.
2. Open either `NewsArticles_LDA.R` or `NewsArticles_LDA_Gibbs.R` in RStudio.
3. Update the dataset folder path in this line:

```r
article_files <- DirSource("C:/path/to/your/news_articles")
```

4. Run the script.

The script will:

- build the corpus,
- preprocess the text,
- create the document-term matrix,
- fit the LDA model,
- display topic terms, word cloud, and confusion matrix outputs.

## 📊 Example outputs

The analysis produces:

- topic distributions by term
- beta spread plots for topic differences
- word cloud visualizations
- confusion matrix for classification performance

## 📌 Notes

- The scripts currently use a hardcoded Windows-style directory path, so you will need to replace it with your own local file location.
- The code is designed for a dataset with article categories split roughly across sports and technology topics.
- This project is a good example of applying LDA for unsupervised text mining and document clustering.

## ⭐ Acknowledgements

This project demonstrates a workflow for text preprocessing, topic modeling, and exploratory analysis in R using LDA and the `tm`/`tidytext` ecosystem.

---

If you want, I can also make this README more polished for GitHub by adding a project banner, badges, and a screenshot section.
