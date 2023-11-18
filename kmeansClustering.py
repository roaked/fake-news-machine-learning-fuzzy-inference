import numpy as np
from sklearn.cluster import KMeans
from sklearn.neighbors import KDTree

def kmeansClustering(trainingData, testingData, testingClass):
    # KMeans clustering on training data
    kmeans = KMeans(n_clusters=6)  # Define a KMeans model with 6 clusters
    pointsKM = kmeans.fit_predict(trainingData.T)  # Fit the KMeans model to trainingData and get cluster labels
    
    # KDTree for nearest neighbour search on training data
    MdlKDT = KDTree(trainingData.T)  # Build a KDTree for fast nearest neighbour search

    cluster = []  # Initialize an empty list to store assigned clusters for testing data


    for i in range(testingData.shape[1]):
        # Finding the nearest neighbour index of each testing data point in the KDTree of training data
        dist, obsNumber = MdlKDT.query(testingData[:, i].reshape(1, -1), k=1)  # Find the nearest neighbour index
        cluster.append(pointsKM[obsNumber])  # Append the cluster label of the nearest neighbour
    
    # Determine the most frequent cluster label in the KMeans clustering
    fakeKMeans = np.bincount(pointsKM).argmax()  # Find the most frequent cluster label in the KMeans result
    
    kmeansTest = testingClass[0]  # Assign the testing class data to kmeansTest
    kmeansCluster = np.array(cluster)  # Convert the cluster list to a NumPy array

    # Assign 1 if the cluster label is different from the most frequent cluster label, else assign 0
    kmeansCluster = np.where(kmeansCluster != fakeKMeans, 1, 0)

    return kmeansTest, kmeansCluster  # Return the testing class data and the assigned cluster labels
