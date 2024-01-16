import pandas as np
import scipy.io

# Load metaInputs from the .mat file
mat_data = scipy.io.loadmat('metaInputs.mat')

# Access the metaInputs data
metaInputs = mat_data['metaInputs']

# Statistics
avgNumbToken = np.sum(metaInputs[0, :]) / 7204
avgNumbTokenTrue = np.sum(metaInputs[0, :3602]) / 3602
avgNumbTokenFalse = np.sum(metaInputs[0, 3602:]) / 3602

# It's similar to the stats in the paper
