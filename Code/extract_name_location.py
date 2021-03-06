import pandas as pd
import nltk
import spacy
import os,glob
import en_core_web_lg

file_list = glob.glob(os.path.join(os.getcwd(),"*.txt"))

len(file_list)
corpus_list = []
for file in file_list:
    with open(file) as f_input:
        corpus_list.append(f_input.read())

## nlp = spacy.load('en')
nlp2 = en_core_web_lg.load()

names_list = []
locations_list = []

for article in corpus_list:
    sents = nlp2(article)
    name_temp = [ee for ee in sents.ents if ee.label_=='PERSON']
    location_temp = [ee for ee in sents.ents if ee.label_=='GPE']
    names_list.append(name_temp)
    locations_list.append(location_temp)

locations_list[390:400]
locations2 = [ee for ee in sents2.ents if ee.label_=='GPE']
type(locations2[0])

file_name_location = pd.DataFrame({'file_name':[file.split('/')[-1] for file in file_list],
                                   'article':corpus_list,
                                   'names_list':names_list,
                                   'locations_list':locations_list})
file_name_location.to_excel("../ExportFiles/NewsLocalNameLocationV1.xlsx", index=False)
