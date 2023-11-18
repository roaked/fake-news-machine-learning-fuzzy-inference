import numpy as np
from sklearn.metrics import confusion_matrix
from scipy.io import loadmat
import matplotlib.pyplot as plt
from operations import plot_loss_curve
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

# Data Processing
news_data = loadmat('newsData.mat')
news_data_ling = loadmat('newsDataLing.mat')
meta_targets = loadmat('metaTargets.mat')
meta_inputs = loadmat('metaInputs.mat')

training_class = meta_targets['metaTargets']
training_class_ling = meta_targets['metaTargets']

training_data = meta_inputs['metaInputs']
training_data_ling = np.vstack((meta_inputs['metaInputs'][10, :],  # Selecting specific rows
                                meta_inputs['metaInputs'][11, :],
                                meta_inputs['metaInputs'][14, :],
                                meta_inputs['metaInputs'][19, :]))

# Clearing loaded variables to free up memory
del meta_inputs, meta_targets

while True:
    print('\nPick an option for the features:')
    print('1: All Features   2: Linguistic Features Only')
    print('0: Exit program\n')
    option = int(input())

    if option == 0:
        print('\nProgram ended.\n\n')
        break

    elif option in [1, 2]:
        features = 1 if option == 1 else 0

        testing_class = training_class if features == 1 else training_class_ling
        testing_data = training_data if features == 1 else training_data_ling

        while True:
            print('\nPick an option for the methods:')
            print('1: C-Means Clustering       2: K-Means Clustering')
            print('3: T-S Fuzzy Model          4: ANN')
            print('0: Press 0 if you want to go back\n')
            option2 = int(input())

            if option2 == 0:
                break

            elif option2 == 1:
                cmeansTest, cmeansCluster, cmeansAcc, exponentValue = cmeansClustering(training_data, testing_data,testing_class)

                # Calculate confusion matrix
                conf_matrix = confusion_matrix(cmeansTest, cmeansCluster)
                                
                # Plot confusion matrix
                plt.figure(1)
                plt.imshow(conf_matrix, cmap=plt.cm.Blues, interpolation='nearest')
                plt.title('Confusion Matrix of C-Means Clustering')
                plt.colorbar()
                plt.show()

                # Assuming cmeansAcc contains 25 values
                cmeansAcc = np.random.rand(25)  # Replace this with your actual values
                exponentValue = np.arange(25)   # Assuming exponentValue needs to match the 25 values in cmeansAcc
                
                # Plot other metrics as required
                plt.figure(2)
                plt.plot(exponentValue, cmeansAcc)
                plt.title('Max Accuracy vs Exponent (m) value')
                plt.ylabel('Max Accuracy')
                plt.xlabel('Exponent (m) value')
                plt.show()

            elif option2 == 2:
                kmeansTest, kmeansCluster = kmeansClustering(training_data, testing_data, testing_class)
                plt.plotconfusion(kmeansTest, kmeansCluster)
                plt.title('Confusion Matrix of K-Means Clustering')
                plt.show()

            elif option2 == 3:
                MaxAccuracy, Ym, YClassOptimal, YClass, FM, clusterNumber = fuzzyModel(training_data, training_class,
                                                                                       testing_data, testing_class)
                plt.figure(1), plt.plotmfs(FM)
                plt.fm2tex(FM, 'membershipEquations.tex')

                plt.figure(2), plt.plot(clusterNumber, MaxAccuracy)
                plt.title('Max Accuracy vs Number of Clusters')
                plt.ylabel('Max Accuracy')
                plt.xlabel('Number of Clusters')

                plt.figure(3), plt.plotconfusion(testing_class[0], YClassOptimal)
                plt.title('Confusion Matrix of T-S FM Model with Optimal Threshold')
                plt.show()

            elif option2 == 4:
                netNN, targetsNN, outputsNN, performanceNN, errorsNN, yTst, tTst, trNN = neuralNetwork(training_data, training_class)
                # View neural network
                # view(netNN)
                                
                # Assuming plotperform, plottrainstate, plotconfusion, ploterrhist are functions that handle plotting the respective metrics
                plt.figure(1)
                # Plotting performance metrics
                plot_loss_curve(trNN)
                plt.title('Performance of ANN')

                plt.figure(2)
                # Plotting training states
                plottrainstate(trNN)
                plt.title('Training State of ANN')

                plt.figure(3)
                # Plotting confusion matrix
                plotconfusion(tTst, yTst)
                plt.title('Confusion Matrix of ANN')

                plt.figure(4)
                # Plotting error histogram
                ploterrhist(errorsNN)
                plt.title('Error Histogram of ANN')

                plt.show()

            else:
                print('\nError! Invalid choice!\n')
    else:
        print('\nError! Invalid choice!\n')

# Clearing variables after use
del features, option, option2, testing_class, testing_data
del training_class, training_class_ling, training_data, training_data_ling