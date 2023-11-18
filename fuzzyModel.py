import numpy as np
from sklearn.metrics import accuracy_score
from skfuzzy import fmclust, fmsim
from confusionmatStats import confusionmatStats  # You'll need to define or import this function

def fuzzyModel(trainingData, trainingClass, testingData, testingClass):
    Input = trainingData.T
    Output = trainingClass.T[0]  # Assuming only the first column is needed
    
    DAT = {'U': Input, 'Y': Output}
    clusterNumber = [2]  # Initial cluster number

    MaxAccuracy = []
    Ym = []
    YClassOptimal = []
    YClass = []
    FM = []

    for j in range(20):
        clusterNumber.append(clusterNumber[0] + j)

        STR = {'c': clusterNumber[j+1]}
        FM, _ = fmclust(DAT, STR)
        Ym, _, _, _, _ = fmsim(testingData.T, testingClass.T, FM)

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

        YClassOptimal = [1 if y > MaxThreshold else 0 for y in Ym]

    maximum = max(MaxAccuracy)
    highestCluster = MaxAccuracy.index(maximum)
    STR = {'c': clusterNumber[highestCluster + 1]}
    FM, _ = fmclust(DAT, STR)
    Ym, _, _, _, _ = fmsim(testingData.T, testingClass.T, FM)

    Threshold = 0.00
    MaxAccuracy = 0.00
    MaxThreshold = 0.00

    while Threshold < 1.00:
        YClass = [1 if y > Threshold else 0 for y in Ym]

        stats = confusionmatStats(testingClass.T, np.array(YClass))
        if MaxAccuracy < stats['accuracy']:
            MaxAccuracy = stats['accuracy']
            MaxThreshold = Threshold

        Threshold += 0.01

    YClassOptimal = [1 if y > MaxThreshold else 0 for y in Ym]

    return MaxAccuracy, Ym, YClassOptimal, YClass, FM, clusterNumber
