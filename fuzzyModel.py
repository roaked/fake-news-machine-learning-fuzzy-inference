import numpy as np
from sklearn.metrics import accuracy_score
import skfuzzy as fuzz
from confusionmatStats import confusionmatStats  # You'll need to define or import this function

def fuzzyModel(trainingData, trainingClass, testingData, testingClass):
    Input = trainingData.T
    Output = trainingClass.T[0]  # Assuming only the first column is needed
    
    DAT = {'U': Input, 'Y': Output}
    clusterNumber = [2]  # Initial cluster number

    # Initializing variables to store results
    MaxAccuracy = []
    Ym = []
    YClassOptimal = []
    YClass = []
    FM = []

    # Iterating over different cluster numbers
    for j in range(20):
        clusterNumber.append(clusterNumber[0] + j)  # Generating cluster numbers

        STR = {'c': clusterNumber[j+1]}  # Setting the current cluster number
        FM, *_ = fuzz.cluster.cmeans(DAT, STR)  # Fuzzy clustering

        # Computing similarity between testing data and clusters
        Ym, _, _, _, _ = fuzz.fmsim(testingData.T, testingClass.T, FM)

        Threshold = 0.00
        MaxAccuracy.append(0.00)
        MaxThreshold = 0.00

        while Threshold < 1.00:
            YClass = [1 if y > Threshold else 0 for y in Ym]

            stats = confusionmatStats(testingClass.T, np.array(YClass))
            if MaxAccuracy[j] < stats['accuracy']:
                MaxAccuracy[j] = stats['accuracy']
                MaxThreshold = Threshold

            Threshold += 0.01

        # Classifying based on the optimal threshold
        YClassOptimal = [1 if y > MaxThreshold else 0 for y in Ym]

    # Finding the highest accuracy achieved
    maximum = max(MaxAccuracy)
    highestCluster = MaxAccuracy.index(maximum)
    STR = {'c': clusterNumber[highestCluster + 1]}
    FM, _ = fuzz.fmclust(DAT, STR)
    Ym, _, _, _, _ = fuzz.fmsim(testingData.T, testingClass.T, FM)

    Threshold = 0.00
    MaxAccuracy = 0.00
    MaxThreshold = 0.00

    # Finding the optimal threshold for classification with the selected cluster number

    while Threshold < 1.00:
        YClass = [1 if y > Threshold else 0 for y in Ym]

        stats = confusionmatStats(testingClass.T, np.array(YClass))
        if MaxAccuracy < stats['accuracy']:
            MaxAccuracy = stats['accuracy']
            MaxThreshold = Threshold

        Threshold += 0.01
        
    # Classifying based on the optimal threshold and returning results
    YClassOptimal = [1 if y > MaxThreshold else 0 for y in Ym]

    return MaxAccuracy, Ym, YClassOptimal, YClass, FM, clusterNumber
