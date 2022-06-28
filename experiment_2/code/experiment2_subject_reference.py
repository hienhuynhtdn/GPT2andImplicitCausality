# -*- coding: utf-8 -*-
"""
Created on Mon Jun 27 15:16:34 2022

@author: Hien Huynh
"""

#%% IMPORT PACKAGES
import pandas as pd

#%% IMPORT DATAFRAME
df = pd.read_excel('./human_ratings/setup/Experiment selection.xlsx')

#%% FUNCTIONS
def split_sentence(sentence, separator):
    sentence = sentence.split(separator)[-1]
    
    # REMOVE SPACE AT THE BEGINNING OF STRING AND PUNCTUATION AT THE END
    sentence = sentence[1:-1]
    
    return sentence

def subject_reference(pronoun, subject_gender):
    result=""
    if subject_gender == 1:
        if pronoun == 'he':
            result = 1
        elif pronoun == 'she':
            result = 0
    elif subject_gender == 0:
        if pronoun == 'he':
            result = 0
        elif pronoun == 'she':
            result = 1
    return result
    

#%% DETERMINE WHETHER THE SUBJECT OF THE GENERATED CLAUSE REFERS TO THE PREVIOUS SUBJECT OR OBJECT

# GET THE SUBJECT OF THE MODEL OUTPUT ('HE' OR 'SHE')
df['generated_subject'] = df['cleaned_output'].apply(
    lambda x: split_sentence(x,'because').split()[0])

# INDICATE WHETHER THE GENERATED SUBJECT REFERS TO THE PREVIOUS SUBJECT OR OBJECT
df['subject_reference'] = df.apply(
    lambda x: subject_reference(x.generated_subject,x.subject_gender),axis=1)

df.to_csv('./data/experiment2_subject_reference.csv')
