import numpy as np
from sklearn.metrics import confusion_matrix
from operations import plot_confusion_matrix
from scipy.io import loadmat
import matplotlib.pyplot as plt
from neuralNetwork import neuralNetwork
from fuzzyModel import fuzzyModel
from cmeansClustering import cmeansClustering
from kmeansClustering import kmeansClustering
import Preprocessing3

# folder = r"path_to_your_folder\FMID5\\"
# Change the folder path 


Preprocessing3

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

print('\nSmart Detector by Ricardo Chin\n')
print('This program detects fake news automatically using metadata\n')

selec = 0
while selec == 0:
    print('\nPick an option for the features:')
    print('1: All Features   2: Linguistic Features Only')
    print('0: Exit program\n')
    option = int(input())
    valid = 0
    warning = True  # Simulating MATLAB 'warning on'

    if option == 0:
        break
    elif option == 1:
        valid = 1
        features = 1  # all features
        testingClass1 = testingClass
        testingData1 = testingData
        trainingClass1 = trainingClass
        trainingData1 = trainingData
    elif option == 2:
        valid = 1
        testingClass1 = testingClassLing
        testingData1 = testingDataLing
        trainingClass1 = trainingClassLing
        trainingData1 = trainingDataLing
        features = 0  # linguistic features only

    if valid == 0:
        print('\nError! Invalid choice!\n')

    if valid == 1 and option != 0:
        print('Program loading...')
        # You can add additional logic here if needed

    selec2 = 0
    while selec2 == 0:
        print('\nPick an option for the methods:')
        print('1: C-Means Clustering       2: K-Means Clustering')
        print('3: T-S Fuzzy Model          4: ANN')
        print('0: Press 0 if you want to go back\n')
        option2 = int(input())
        valid2 = 0
        plt.close('all')  # Assuming you're using matplotlib for plotting

        if option2 == 0:
            valid2 = 1
            selec2 = 1

        elif option2 == 1:
            cmeansTest, cmeansCluster, cmeansAcc, highestExponent = cmeansClustering(trainingData, testingData, testingClass)

            # Calculate confusion matrix
            conf_matrix = plot_confusion_matrix(cmeansTest, cmeansCluster)

            # Assuming cmeansAcc contains 25 values
            cmeansAcc = np.random.rand(25)  # Replace this with your actual values
            highestExponent = np.arange(25)   # Assuming exponentValue needs to match the 25 values in cmeansAcc
            
            # Plot other metrics as required
            plt.figure(2)
            plt.plot(highestExponent, cmeansAcc)
            plt.title('Max Accuracy vs Exponent (m) value')
            plt.ylabel('Max Accuracy')
            plt.xlabel('Exponent (m) value')
            plt.show()

        elif option2 == 2:
            kmeansTest, kmeansCluster, conf_matrix = kmeansClustering(trainingData1, testingData1, testingClass1)
        

        elif option2 == 3:
            MaxAccuracy, Ym, YClassOptimal, YClass, FM, clusterNumber = fuzzyModel(trainingData1, trainingClass1,
                                                                                    testingData1, testingClass1)
            plt.figure(1), plt.plotmfs(FM)
            plt.fm2tex(FM, 'membershipEquations.tex')

            plt.figure(2), plt.plot(clusterNumber, MaxAccuracy)
            plt.title('Max Accuracy vs Number of Clusters')
            plt.ylabel('Max Accuracy')
            plt.xlabel('Number of Clusters')

            plt.figure(3), plt.plotconfusion(testingClass1[0], YClassOptimal)
            plt.title('Confusion Matrix of T-S FM Model with Optimal Threshold')
            plt.show()

        elif option2 == 4:
            history, model, targetsNN, outputsNN, performanceNN, _, y_pred, y_true, _, loss_curve = neuralNetwork(trainingData1, trainingClass1)
            plt.show()

        else:
            print('\nError! Invalid choice!\n')
    else:
        print('\nError! Invalid choice!\n')
