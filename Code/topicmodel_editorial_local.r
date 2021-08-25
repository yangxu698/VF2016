library(dplyr)
library(tibble)
library(tidyr)
library(ggplot2)
library(quanteda)
library(ldatuning)
library(tidytext)
library(topicmodels)

## wd = "/home/yang/VF2016Combined/"
## setwd(wd)

df1_dfma_trimmed = readRDS("../Editorial Local_df1_dfma_trimmed.rds")

# Topics Search

# not trimmed
dtm_test_trimmed <- convert(df1_dfma_trimmed, to="topicmodels")

result_trimmed <- FindTopicsNumber(
                        dtm_test_trimmed,
                        topics = seq(from = 2, to = 10, by = 1), #I increased to 25 since there are a large number of documents; for NG < 60 I used 10
                        metrics = c("Griffiths2004","CaoJuan2009","Arun2010","Deveaud2014"),
                        method = "Gibbs",
                        control = list(seed=8999, iter=7500, burnin=2500, alpha=1, delta=1),
                        mc.cores = 9L,
                        verbose = TRUE
                      )

FindTopicsNumber_plot(result_trimmed)
ggsave("../ExportFiles/Editorial_Local.png")
# "Griffiths2004",
saveRDS(result_trimmed, paste0("../ExportFiles/topics_search_result","Editorial_Local.rds"))
