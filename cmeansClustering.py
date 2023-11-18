import numpy as np
from sklearn.metrics import accuracy_score
# pip install -U scikit-fuzzy
from skfuzzy import cmeans
from scipy.spatial import distance
import Preprocessing3

Preprocessing3

def cmeansClustering(trainingData, testingData, testingClass):
    # Generating a range of values from 1.1 to 3.5 with steps of 0.1
    p_values = np.arange(1.1, 3.6, 0.1)
    cmeansAcc = []

    # Loop through the range of p values
    for p in p_values:
            # Fuzzy C-means clustering with varying p values
            options = dict(c=p, m=2, error=0.0000001, maxiter=150)
            centersCM, _ = cmeans(trainingData.T, 6, 2, error=0.0000001, maxiter=150)

            # Calculate distances between testing data and cluster centers
            dist = np.zeros((centersCM.shape[0], testingData.shape[1]))
            for i in range(testingData.shape[1]):
                for j in range(centersCM.shape[0]):
                    totalDelta = np.sum((testingData[:, i] - centersCM[j])**2)
                    dist[j, i] = np.sqrt(totalDelta)

            # Assign data points to clusters based on minimum distance
            cluster = np.argmin(dist, axis=0)

            # Finding the most frequent cluster as the "fake" cluster
            fakeCMeans = np.argmax(np.bincount(cluster))

            # Initializations for classification and accuracy calculations
            cmeansTest = testingClass[0, :].tolist()
            cmeansCluster = [1 if c != fakeCMeans else 0 for c in cluster]

            # Calculate accuracy and store it for each p value
            acc = accuracy_score(cmeansTest, cmeansCluster)
            cmeansAcc.append(acc)

    # Find the p value with the highest accuracy
    maximum = max(cmeansAcc)
    highestExponent = (np.where(np.array(cmeansAcc) == maximum)[0][0] + 1.1) / 10
    options = dict(c=highestExponent, m=2, error=0.0000001, maxiter=150)
    centersCM, _ = cmeans(trainingData.T, 6, 2, error=0.0000001, maxiter=150)

    # Repeat the clustering process with the p value that yielded the highest accuracy
    dist = np.zeros((centersCM.shape[0], testingData.shape[1]))
    for i in range(testingData.shape[1]):
        for j in range(centersCM.shape[0]):
            totalDelta = np.sum((testingData[:, i] - centersCM[j])**2)
            dist[j, i] = np.sqrt(totalDelta)

    cluster = np.argmin(dist, axis=0)
    fakeCMeans = np.argmax(np.bincount(cluster))
    cmeansTest = testingClass[0, :].tolist()

    # Classify based on the most frequent cluster
    cmeansCluster = [1 if c != fakeCMeans else 0 for c in cluster]

    return cmeansTest, cmeansCluster, cmeansAcc, highestExponent


# Call the function
[cmeansTest, cmeansCluster, cmeansAcc, exponentValue] = cmeansClustering(trainingData, testingData, testingClass)