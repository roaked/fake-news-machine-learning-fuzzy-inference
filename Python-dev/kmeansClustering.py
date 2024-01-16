import numpy as np
from sklearn.cluster import KMeans
import matplotlib.pyplot as plt
from operations import plot_confusion_matrix
from sklearn.neighbors import KDTree
from confusionmatStats import confusionmatStats

def kmeansClustering(trainingData, testingData, testingClass):
    kmeans = KMeans(n_clusters=6)
    pointsKM = kmeans.fit_predict(trainingData.T)
    MdlKDT = KDTree(trainingData.T)
    cluster = []

    for i in range(testingData.shape[1]):
        dist, obsNumber = MdlKDT.query(testingData[:, i].reshape(1, -1), k=1)
        cluster.append(pointsKM[obsNumber])

    fakeKMeans = np.bincount(pointsKM).argmax()
    kmeansTest = testingClass[0]
    kmeansCluster = np.array(cluster)

    # Binary classification: 1 for different clusters, 0 for the most frequent cluster
    kmeansCluster = np.where(kmeansCluster != fakeKMeans, 1, 0)

    # Ensure testingClass and kmeansCluster have the same shape and type (if necessary)
    kmeansTest = np.asarray(kmeansTest)
    kmeansCluster = np.asarray(kmeansCluster)

    # Check unique values in kmeansTest and kmeansCluster to identify any issues
    unique_values_test = np.unique(kmeansTest)
    unique_values_cluster = np.unique(kmeansCluster)
    print("Unique values in kmeansTest:", unique_values_test)
    print("Unique values in kmeansCluster:", unique_values_cluster)

    # Align the labels if needed to ensure consistency
    # For instance, convert labels to 0 or 1 if they are not consistent
    kmeansTest[kmeansTest != 0] = 1
    kmeansCluster[kmeansCluster != 0] = 1

    kmeansCluster = np.squeeze(kmeansCluster)  # Remove singleton dimensions
    print("Shape of kmeansTest:", kmeansTest.shape)
    print("Shape of kmeansCluster:", kmeansCluster.shape)

    # Create the confusion matrix after aligning the labels
    conf_matrix = plot_confusion_matrix(kmeansTest, kmeansCluster)

    # Compute additional statistics
    stats = confusionmatStats(kmeansTest, kmeansCluster)

    # Print the statistics
    print("Additional Statistics:")
    for key, value in stats.items():
        print(f"{key}: {value:.4f}" if isinstance(value, float) else f"{key}: {value}")

    return kmeansTest, kmeansCluster, conf_matrix


