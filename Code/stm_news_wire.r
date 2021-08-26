library(dplyr)
library(tibble)
library(tidyr)
library(ggplot2)
library(quanteda)
library(tidytext)
library(topicmodels)
library(stm)

setwd("/home/yang/VF2016Combined/Code")

df1_dfma_trimmed = readRDS("../News Wire_df1_dfma_trimmed.rds")

dfm_stm <- convert(df1_dfma_trimmed, to="stm")

model.stm1 <- stm(dfm_stm$documents, dfm_stm$vocab, K = 4, data = dfm_stm$meta, prevalence=~battle_ground_dummy, init.type = "Spectral", seed=1234)

saveRDS(list(dfm_stm, model.stm1), "../ExportFiles/STM_News_Wire_Covariate.rds")
