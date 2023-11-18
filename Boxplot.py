import numpy as np
import matplotlib.pyplot as plt
from scipy.io import loadmat

# Load .mat files
metaInputs_data = loadmat('metaInputs.mat')
metaTargets_data = loadmat('metaTargets.mat')

# Accessing loaded data
metaInputs = metaInputs_data['metaInputs']
metaTargets = metaTargets_data['metaTargets']


################### Features ####################

#1  number of tokens good
#2  number of words without punctuation good
#3  number of types good
#4  number of links inside the news 
#5  number of words in upper case
#6  number of verbs  discard
#7  number of subjuntive and imperative verbs 
#8  number of nouns   discard
#9  number of adjectives   discard
#10 number of adverbs   discard
#11 number of modal verbs (mainly auxiliary verbs)
#12 number of singular first and second personal pronouns
#13 number of plural first personal pronouns
#14 number of pronouns   discard
#15 pausality   discard
#16 number of characters
#17 average sentence length
#18 average word length
#19 percentage of news with speeling errors good
#20 emotiveness
#21 diversity

# Assuming you've loaded 'metaInputs' and 'metaTargets' from the .mat files

# Choosing specific parameters for analysis
metaInputs2 = metaInputs[[0, 1, 2, 5, 7, 8, 9, 13], :]

plt.figure(figsize=(8, 6))

# Boxplot for all features
plt.subplot(2, 1, 1)
plt.boxplot(metaInputs.T, sym='')
plt.ylim(0, 10250)
plt.xlabel('Features #')
plt.title('All Features')

# Boxplot for specific features
plt.subplot(2, 1, 2)
plt.boxplot(metaInputs2.T, sym='', labels=['1', '2', '3', '6', '8', '9', '10', '14'])
plt.ylim(0, 2400)
plt.xlabel('Features #')
plt.title('Only Specific Features')

plt.tight_layout()
plt.show()

# Fake or Not Fake analysis
metaInputs3 = metaInputs[[10, 11, 14, 19]].T
metaInputsTrue = metaInputs3[:3602, :]
metaInputsFake = metaInputs3[3602:7204, :]

plt.figure(figsize=(8, 6))

# Boxplot for True News - Linguistic Features
plt.subplot(2, 1, 1)
plt.boxplot(metaInputsTrue, sym='', labels=['11 - # of Modal Verbs', '12 - # of Personal Pronouns',
                                           '15 - Pausality', '20 - Emotiveness'])
plt.ylim(0, 60)
plt.xlabel('Features #')
plt.title('True News - Linguistic Features')

# Boxplot for Fake News - Linguistic Features
plt.subplot(2, 1, 2)
plt.boxplot(metaInputsFake, sym='', labels=['11 - # of Modal Verbs', '12 - # of Personal Pronouns',
                                           '15 - Pausality', '20 - Emotiveness'])
plt.ylim(0, 60)
plt.xlabel('Features #')
plt.title('Fake News - Linguistic Features')

plt.tight_layout()
plt.show()
