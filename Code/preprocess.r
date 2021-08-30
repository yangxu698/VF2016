library(stringr)
library(dplyr)
library(tibble)
library(tidyr)
library(quanteda)
library(writexl)
library(readxl)
library(tidytext)

file_list = list.files(path="/home/yang/VF2016Combined", pattern="txt$", recursive=TRUE)

wd = "/home/yang/VF2016Combined/"
setwd(wd)

text = c()
for (file in file_list){
    temp = readLines(paste0(wd,file))
    text = c(text, paste(temp, collapse=' '))
    temp = ""
}

raw_data = as_tibble(data.frame(file_path=file_list, raw_text=text))

raw_data = raw_data %>%
  mutate(raw_text = as.character(raw_text)) %>%
  separate(file_path, c("section","title"), sep="/", remove=FALSE)

temp = raw_data %>% filter(title == 'CA_LA Times70.txt') %>% pull(raw_text)

battle_ground_keys = "TucsonDailyStar|DenverPost|TampaBayTimes|Quad-CityTimes|DetroitNews|LasVegasReview-Journal|Union-Leader|CharlotteObserver|PlainDealer|RichmondTimesDispatch|MilwaukeeJournalSentinel"

df1_tbl <- raw_data %>%
                mutate(raw_text = str_to_lower(raw_text)) %>%
                mutate(raw_text = str_replace_all(raw_text, "\\r\\n", " ")) %>%
                mutate(raw_text = str_replace_all(raw_text, "\\s+"," ")) %>%
                mutate(battle_ground_refer = str_to_lower(file_path)) %>%
                mutate(battle_ground_refer = str_replace_all(battle_ground_refer, "\\s+","")) %>%
                mutate(battle_ground_dummy = ifelse(str_detect(battle_ground_refer, str_to_lower(battle_ground_keys)),1,0)) %>%
                select(-battle_ground_refer)


glimpse(df1_tbl)

#  df1_tbl1 <- df1_tbl %>%
    #  mutate(
     #  relevant_new = case_when(
      #  str_detect(body, "ballot.* fraud|dead people vot.*|deceased voter.*|elect.* fraud|fraudulent ballot.*|illegal ballot.*|illegal vot.*|illegitimate vot.*|ineligible vot.*|rig elect.*|rigged elect.*|rig vot.*|rigged vot.*|vot.* fraud|steal.* elect.*|stop the steal|stop steal|steal.*|deceased|dead|people| vot.*|ballot.*|elect.*|fraud.*|illegal|illegitimate|ineligible|rig.*|steal.*|stop|trump|biden|campaign.*|democrat.*|republican.*") ~ 1)
    #  ) %>%
    #  filter(relevant_new==1)
# glimpse(df1_tbl1)

saveRDS(df1_tbl, 'df1_tbl_2016_all.rds')

df1_tbl = readRDS('df1_tbl_2016_all.rds')
section = df1_tbl %>% pull(section) %>% unique()

for (element in section){
    df1_dfma_trimmed <- df1_tbl %>%
              filter(section == element) %>%
              rename(doc_id=file_path,text=raw_text) %>%
              corpus() %>%
              tokens() %>%
              tokens_remove(pattern = c(stopwords("english"),"=","<",">","+","u","e.g","etc"), padding=TRUE) %>%
              tokens_ngrams(n=2, concatenator = " ") %>%
              dfm(remove_url = TRUE, remove_numbers = TRUE, remove_punct = TRUE, remove_separators=TRUE, remove_symbols=TRUE, verbose=TRUE) %>%
              dfm_remove(pattern = c(stopwords("english"),"=","<",">","+","u","e.g","etc","may","include","can","see","eg","must","time","i.e","s","t","https","m","com","also","need","just","said",
                            "like","going","know","according","get","now","re","even"), verbose=TRUE)
    saveRDS(df1_dfma_trimmed, paste0(element, "_df1_dfma_trimmed.rds"))

}
