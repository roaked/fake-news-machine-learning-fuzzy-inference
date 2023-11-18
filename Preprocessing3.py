import scipy.io
import numpy as np

# Load metaInputs and metaTargets from the .mat files
metaInputs_data = scipy.io.loadmat('metaInputs.mat')
metaTargets_data = scipy.io.loadmat('metaTargets.mat')

# Access the loaded data
metaInputs = metaInputs_data['metaInputs']
metaTargets = metaTargets_data['metaTargets']

# Data with all news parameters
# 25% of data for testing
testingData = metaInputs[:, 0::4]
testingClass = metaTargets[:, 0::4]

# 75% of data for training
trainingData = np.delete(metaInputs, np.s_[::4], axis=1)
trainingClass = np.delete(metaTargets, np.s_[::4], axis=1)

# Data with only the 4 linguistic parameters
metaInputsLing = metaInputs[[10, 11, 14, 19], :]

# 25% of data for testing
testingDataLing = metaInputsLing[:, 0::4]
testingClassLing = metaTargets[:, 0::4]

# 75% of data for training
trainingDataLing = np.delete(metaInputsLing, np.s_[::4], axis=1)
trainingClassLing = np.delete(metaTargets, np.s_[::4], axis=1)

# Saving the variables into a .npz file
np.savez('saved_data.npz',
         testingData=testingData, testingClass=testingClass,
         trainingData=trainingData, trainingClass=trainingClass,
         testingDataLing=testingDataLing, testingClassLing=testingClassLing,
         trainingDataLing=trainingDataLing, trainingClassLing=trainingClassLing)