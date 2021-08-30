library(dplyr)
library(tibble)
library(tidyr)
library(ggplot2)
library(quanteda)
library(tidytext)
library(topicmodels)
library(stm)

setwd("/home/yang/VF2016Combined/Code")

df1_dfma_trimmed = readRDS("../News Local_df1_dfma_trimmed.rds")

dfm_stm <- convert(df1_dfma_trimmed, to="stm")

model.stm1 <- stm(dfm_stm$documents, dfm_stm$vocab, K = 4, data = dfm_stm$meta, prevalence=~battle_ground_dummy, init.type = "Spectral", seed=1234)

saveRDS(list(dfm_stm, model.stm1), "../ExportFiles/STM_2grams_News_Local_Covariate.rds")

stm_2grams_news_local = readRDS("../ExportFiles/STM_2grams_News_Local_Covariate.rds")

df1_tb1_news_local = readRDS("../News Local_df1_dfma_trimmed.rds")

model_stm = stm_2grams_news_local[[2]]
stm_df <- data.frame(t(labelTopics(model_stm, n = 25)$prob))
td_beta <- tidy(model_stm)
td_gamma <- tidy(model_stm, matrix = "gamma",
                 document_names = rownames(df1_tb1_news_local))

top_terms <- td_beta %>%
  arrange(beta) %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  arrange(-beta) %>%
  select(topic, term) %>%
  summarize(terms = list(term)) %>%
  mutate(terms = map(terms, paste, collapse = ", ")) %>%
  unnest(cols=c(topic,terms))
top_terms

gamma_terms <- td_gamma %>%
  group_by(topic) %>%
  summarize(gamma = mean(gamma)) %>%
  arrange(desc(gamma)) %>%
  left_join(top_terms, by = "topic") %>%
  mutate(topic = paste0("Topic ", topic),
         topic = reorder(topic, gamma))
gamma_terms

## write_csv(gamma_terms, "STM Topic Gamma Values.csv") #SEND TO ME

stm_classifications2 <- td_gamma %>%
  group_by(document) %>%
  top_n(1, gamma) %>%
  ungroup() %>%
  arrange(topic)
stm_classifications2

gamma_terms %>%
  mutate_at(vars(topic), list(as.character)) %>%
  separate(topic, c("temp", "topic_number"), sep=' ', remove=FALSE) %>%
  mutate_at(vars(topic_number), list(as.numeric)) %>%
  left_join(stm_classifications2 %>% count(topic), by=c('topic_number'='topic')) %>%
  select(-temp) %>%
  saveRDS("../ExportFiles/News_Local_stm_result.rds")
