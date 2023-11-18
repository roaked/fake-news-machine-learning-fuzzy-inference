import numpy as np
from scipy.io import loadmat
import matplotlib.pyplot as plt
import cmeansClustering, kmeansClustering, fuzzyModel, neuralNetwork
from skfuzzy import fmclust

folder = r"path_to_your_folder\FMID5\\"
# Change the folder path to where your data is located

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
                cmeansTest, cmeansCluster, cmeansAcc, exponentValue = cmeansClustering(training_data, testing_data,
                                                                                        testing_class)
                plt.figure(1), plt.plotconfusion(cmeansTest, cmeansCluster)
                plt.title('Confusion Matrix of C-Means Clustering')

                plt.figure(2), plt.plot(exponentValue, cmeansAcc)
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
                trNN, targetsNN, outputsNN, performanceNN, errorsNN, netNN = neuralNetwork(training_data, training_class)
                # View neural network
                # view(netNN)

                plt.figure(1), plt.plotperform(trNN)
                plt.figure(2), plt.plottrainstate(trNN)
                plt.figure(3), plt.plotconfusion(targetsNN, outputsNN)
                plt.title('Confusion Matrix of ANN')
                plt.figure(4), plt.ploterrhist(errorsNN)
                plt.show()

            else:
                print('\nError! Invalid choice!\n')
    else:
        print('\nError! Invalid choice!\n')

# Clearing variables after use
del features, option, option2, testing_class, testing_data
del training_class, training_class_ling, training_data, training_data_ling