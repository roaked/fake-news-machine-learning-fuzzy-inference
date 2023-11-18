import matplotlib.pyplot as plt
import numpy as np
from sklearn.neural_network import MLPRegressor
import tensorflow as tf
from sklearn.model_selection import train_test_split

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

    # Train-test split the data
    train_inputs, test_inputs, train_targets, test_targets = train_test_split(inputsNN, targetsNN, test_size=0.2, random_state=42)

    # Define the model
    model = tf.keras.Sequential([
        tf.keras.layers.Dense(units, activation='relu', input_shape=(train_inputs.shape[1],)) for units in hiddenSize
    ])
    model.add(tf.keras.layers.Dense(1))  # Assuming single output

    # Compile the model
    model.compile(optimizer='adam', loss='mean_squared_error')

     # Train the model and record the history to get the loss curve
    history = model.fit(train_inputs, train_targets, epochs=100, batch_size=32, validation_data=(test_inputs, test_targets))

    # Predict on the test set
    yTst = model.predict(test_inputs)
    tTst = test_targets

    # Predict on the training set for performance evaluation
    outputsNN = model.predict(train_inputs)
    performanceNN = model.evaluate(train_inputs, train_targets)  # Get the evaluation metric from training

    # Get the loss curve from history
    loss_curve = history.history['loss'] 

        # Plotting the loss curve
    # plt.plot(loss_curve)
    # plt.xlabel('Epochs')
    # plt.ylabel('Loss')
    # plt.title('Loss Curve during Training')
    # plt.show()

    return history, model, targetsNN, outputsNN, performanceNN, None, yTst, tTst, None, loss_curve



