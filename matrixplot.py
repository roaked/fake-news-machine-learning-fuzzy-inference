import numpy as np
import scipy.io
import matplotlib.pyplot as plt

# Load metaInputs from the .mat file
mat_data = scipy.io.loadmat('metaInputs.mat')

# Access the metaInputs data
metaInputs = mat_data['metaInputs']

# Choosing only 4 parameters of the news
metaInputs2 = metaInputs[[0, 1, 2, 18], :]

metaInputsTrue = metaInputs2[:, :3602]
metaInputsFalse = metaInputs2[:, 3602:]

plt.figure(1)

plt.subplot(1, 2, 1)
plt.plot(metaInputsTrue.T)
plt.title('True news')

plt.subplot(1, 2, 2)
plt.plot(metaInputsFalse.T)
plt.title('Fake news')

plt.tight_layout()
plt.show()
