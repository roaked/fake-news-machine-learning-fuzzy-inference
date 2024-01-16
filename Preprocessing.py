import pandas as pd
import numpy as np
import importfile
import scipy.io

# Number of news
N = list(range(1, 3603))

# Remove news that don't exist for some reason
N.remove(697)
N.remove(1467)

metaInputsTrue = []
metaInputsFake = []
metaTargetsTrue = []
metaTargetsFake = []

for i in N:
    # Assuming importfile function reads the data from a text file and returns a list or array

    # metaInputsTrue.append(importfile(f'{i}-meta.txt'))
    metaInputsFake.append(importfile(f'{i}-meta.txt'))

    # metaTargetsTrue.append([1, 0])
    metaTargetsFake.append([0, 1])


# Load metaInputs and metaTargets from the .mat files
metaInputs_data = scipy.io.loadmat('metaInputs.mat')
metaTargets_data = scipy.io.loadmat('metaTargets.mat')

# Access the loaded data
metaInputs = metaInputs_data['metaInputs']
metaTargets = metaTargets_data['metaTargets']

# Combining the data
metaInputs = np.column_stack((metaInputsTrue, metaInputsFake))
metaTargets = np.column_stack((metaTargetsTrue, metaTargetsFake))

# Convert lists to numpy arrays or Pandas DataFrames for further processing if needed
metaInputs = np.array(metaInputs)
metaTargets = np.array(metaTargets)