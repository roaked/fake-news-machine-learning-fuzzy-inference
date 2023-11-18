import numpy as np
from sklearn.neural_network import MLPRegressor

def neuralNetwork(trainingData, trainingClass):
    trainingData = trainingData.T
    trainingClass = trainingClass.T

    inputsNN = trainingData
    targetsNN = trainingClass[:, 0]

    print('\nPick an option for the neural network:\n')
    print('1:[5] 2:[10] 3:[15]\n')
    print('4:[2 2] 5:[5 5] 6:[10 10]\n')
    print('7:[2 2 2] 8:[4 4 4] 9:[6 6 6]\n')
    print('10:[2 2 2 2] 11:[4 4 4 4]\n')
    print('\n')
    option = int(input(''))

    # Set hidden layer sizes based on user input
    if option == 1:
        hiddenSize = (5,)
    elif option == 2:
        hiddenSize = (10,)
    elif option == 3:
        hiddenSize = (15,)
    elif option == 4:
        hiddenSize = (2, 2)
    elif option == 5:
        hiddenSize = (5, 5)
    elif option == 6:
        hiddenSize = (10, 10)
    elif option == 7:
        hiddenSize = (2, 2, 2)
    elif option == 8:
        hiddenSize = (4, 4, 4)
    elif option == 9:
        hiddenSize = (6, 6, 6)
    elif option == 10:
        hiddenSize = (2, 2, 2, 2)
    elif option == 11:
        hiddenSize = (4, 4, 4, 4)

    # Create the neural network model
    netNN = MLPRegressor(hidden_layer_sizes=hiddenSize, solver='lbfgs', max_iter=10000)

    # Train the neural network
    netNN.fit(inputsNN, targetsNN)

    # Predict on the training set
    outputsNN = netNN.predict(inputsNN)
    performanceNN = netNN.score(inputsNN, targetsNN)
    errorsNN = targetsNN - outputsNN

    return netNN, targetsNN, outputsNN, performanceNN, errorsNN



