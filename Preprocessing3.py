import scipy.io
import numpy as np

# Load data from .mat files
metaInputs = scipy.io.loadmat('metaInputs.mat')['metaInputs']
metaTargets = scipy.io.loadmat('metaTargets.mat')['metaTargets']

# Data with all news parameters
# 25% of data for testing
testingData = metaInputs[:, ::4]
testingClass = metaTargets[:, ::4]

# 75% of data for training
trainingData = np.copy(metaInputs)
trainingClass = np.copy(metaTargets)

for i in range(metaInputs.shape[1] - 1, -1, -1):
    if i % 4 == 0:
        trainingData = np.delete(trainingData, i, axis=1)
        trainingClass = np.delete(trainingClass, i, axis=1)

# Data with only the 4 linguistic parameters
metaInputsLing = metaInputs[[10, 11, 14, 19], :]

# 25% of data for testing
testingDataLing = metaInputsLing[:, ::4]
testingClassLing = metaTargets[:, ::4]


# 75% of data for training
trainingDataLing = np.copy(metaInputsLing)
trainingClassLing = np.copy(metaTargets)

for i in range(metaInputsLing.shape[1] - 1, -1, -1):
    if i % 4 == 0:
        trainingDataLing = np.delete(trainingDataLing, i, axis=1)
        trainingClassLing = np.delete(trainingClassLing, i, axis=1)

# Saving the variables into a .npz file
np.savez('saved_data.npz',
         testingData=testingData, testingClass=testingClass,
         trainingData=trainingData, trainingClass=trainingClass,
         testingDataLing=testingDataLing, testingClassLing=testingClassLing,
         trainingDataLing=trainingDataLing, trainingClassLing=trainingClassLing)