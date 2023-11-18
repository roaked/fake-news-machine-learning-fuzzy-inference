import numpy as np
from sklearn.metrics import accuracy_score
# pip install -U scikit-fuzzy
from skfuzzy import cmeans
import skfuzzy as fuzz
from scipy.spatial import distance

# Loading the saved variables
saved_data = np.load('saved_data.npz')

# Retrieve the variables from the loaded file
testingData = saved_data['testingData']
testingClass = saved_data['testingClass']
trainingData = saved_data['trainingData']
trainingClass = saved_data['trainingClass']
testingDataLing = saved_data['testingDataLing']
testingClassLing = saved_data['testingClassLing']
trainingDataLing = saved_data['trainingDataLing']
trainingClassLing = saved_data['trainingClassLing']


def cmeansClustering(trainingData, testingData, testingClass):
    # Generating a range of values from 1.1 to 3.5 with steps of 0.1
    p_values = np.arange(1.1, 3.6, 0.1)
    cmeansAcc = []

    # Loop through the range of p values
    for p in p_values:
        
            # Fuzzy C-means clustering with varying p values
            options = dict(c=p, m=2, error=0.0000001, maxiter=150)
            centersCM, u, _, _, _, _, _ = fuzz.cluster.cmeans(
                trainingData.T,
                6,
                p,
                error=0.0000001,
                maxiter=150
            )  # 6 clusters

        
            # # Possible reshaping or transposition if needed
            # centersCM = centersCM.T  # Transpose centersCM if necessary

            # # Transpose testingData to align shapes
            # testingData = testingData    
            # # testingData = testingData.reshape(new_shape)  # Reshape testingData if necessary

            print(testingData.shape)
            print(centersCM.shape)


            # Assuming centersCM and testingData are initialized appropriately
            # Initialize dist matrix to store distances / point to cluster center
            dist = np.zeros((centersCM.shape[0], testingData.shape[1]))

            # Loop through each testing data point and each cluster center
            for i in range(testingData.shape[1]): # Loop over each testing data point
                for j in range(centersCM.shape[0]): # Loop over each cluster center
                    totalDelta = 0 # Initialize total delta for each cluster center

                    
                    for k in range(testingData.shape[0]):  # Iterate through the rows of testingData
                        # Calculate the squared difference between each parameter of the testing data point
                        # and each cluster center, and accumulate the total delta
                        delta = (testingData[k, i] - centersCM[j, k])**2
                        totalDelta += delta

                    
                    
                    # Calculate the square root of the accumulated totalDelta and store in the dist matrix
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
    centersCM, u, _, _, _, _, _ = fuzz.cluster.cmeans(
        trainingData.T,
        6,
        highestExponent,
        error=0.0000001,
        maxiter=150
    )  # 6 clusters

    # Perform subtraction
    dist = np.zeros((centersCM.shape[0], testingData.shape[1]))
    for i in range(testingData.shape[1]):
        for j in range(centersCM.shape[0]):
            totalDelta = 0
            for k in range(testingData.shape[0]):  # Iterate through the rows of testingData
                delta = (testingData[k, i] - centersCM[j, k])**2
                totalDelta += delta
            dist[j, i] = np.sqrt(totalDelta)

    cluster = np.argmin(dist, axis=0)
    fakeCMeans = np.argmax(np.bincount(cluster))
    cmeansTest = testingClass[0, :].tolist()

    # Classify based on the most frequent cluster
    cmeansCluster = [1 if c != fakeCMeans else 0 for c in cluster]

    return cmeansTest, cmeansCluster, cmeansAcc, highestExponent

# Call the function
[cmeansTest, cmeansCluster, cmeansAcc, exponentValue] = cmeansClustering(trainingData, testingData, testingClass)