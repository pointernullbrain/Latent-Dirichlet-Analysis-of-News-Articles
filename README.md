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

  
    <img width="787" height="422" alt="probs" src="https://github.com/user-attachments/assets/a00bebbf-967e-4773-81f9-5965642f8f6b" />
    
    *Without Gibbs method*
    
    <img width="741" height="428" alt="prob_gibbs" src="https://github.com/user-attachments/assets/b669800d-fdd0-4126-b1c1-c622ca6fece6" />
  
    *With Gibbs method*
  
- beta spread plots for topic differences

    <img width="787" height="422" alt="beta spread" src="https://github.com/user-attachments/assets/37511e88-1b37-4dd4-9fcf-49d12ff48456" />

    *Without Gibbs method*
    
    <img width="741" height="428" alt="beta_spread_gibbs" src="https://github.com/user-attachments/assets/e3fad481-d1f8-47ae-8381-9afb1b3ec40a" />
  
    *With Gibbs method*
  
- word cloud visualizations

    <img width="647" height="439" alt="wordcloud" src="https://github.com/user-attachments/assets/d01fd0b7-d0b8-4343-b830-3aa70459b65c" />
  
- confusion matrix for classification performance

    <img width="741" height="428" alt="conf matrix" src="https://github.com/user-attachments/assets/a1183378-9819-4b43-9ea1-6f520586845b" />

    *Without Gibbs method*
    
    <img width="741" height="428" alt="conf_mat_gibbs" src="https://github.com/user-attachments/assets/5c8c2ac5-128c-43f9-adf3-c5d9d4fa8851" />

    *With Gibbs method*

## 📌 Notes

- The scripts currently use a hardcoded Windows-style directory path, so you will need to replace it with your own local file location.
- The code is designed for a dataset with article categories split roughly across sports and technology topics.
- This project is a good example of applying LDA for unsupervised text mining and document clustering.

## ⭐ Acknowledgements

This project demonstrates a workflow for text preprocessing, topic modeling, and exploratory analysis in R using LDA and the `tm`/`tidytext` ecosystem.

