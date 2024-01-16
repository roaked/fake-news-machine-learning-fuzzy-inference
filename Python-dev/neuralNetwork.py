import matplotlib.pyplot as plt
import numpy as np
import Preprocessing3
import seaborn as sns 
from sklearn.metrics import confusion_matrix
from confusionmatStats import confusionmatStats
import tensorflow as tf
from sklearn.model_selection import train_test_split

#Preprocessing3

# Loading the saved variables
#saved_data = np.load('saved_data.npz')
#trainingData = saved_data['trainingData']
#trainingClass = saved_data['trainingClass']


# Function to get model weights
def get_model_weights(model):
    return [layer.get_weights() for layer in model.layers]
   
#history, model, targetsNN, outputsNN, performanceNN, _, y_pred, y_true, _, loss_curve = neuralNetwork(trainingData, trainingClass)

def neuralNetwork(trainingData, trainingClass):
    trainingData = trainingData.T
    trainingClass = trainingClass.T

    inputsNN = trainingData
    targetsNN = trainingClass[:, 0]

    print(inputsNN)

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
    model.add(tf.keras.layers.Dense(1)) # Assuming single output

    # Compile the model
    model.compile(optimizer=tf.keras.optimizers.Adam(learning_rate=0.01), loss='mean_squared_error')

    # Train the model and record the history to get the loss curve
    history = model.fit(train_inputs, train_targets, epochs=25, batch_size=32, validation_data=(test_inputs, test_targets))

    # Generate predictions on the test set
    y_pred = model.predict(test_inputs)
    y_pred = (y_pred > 0.5).astype(int)
    y_true = test_targets

    # Predict on the training set for performance evaluation
    outputsNN = model.predict(train_inputs)
    performanceNN = model.evaluate(train_inputs, train_targets)  # Get the evaluation metric from training


    # Create subplots for various visualizations
    fig, axs = plt.subplots(2, 2, figsize=(12, 10))

    # Get the loss curve from history
    loss_curve = history.history['loss']

    # Plot the loss curve
    axs[1, 0].plot(loss_curve)
    axs[1, 0].set_title('Loss Curve')

    # Confusion Matrix
    conf_matrix = confusion_matrix(y_true, y_pred)
    stats = confusionmatStats(y_true, y_pred)
    # Print the statistics
    print("Additional Statistics:")
    for key, value in stats.items():
        print(f"{key}: {value:.4f}" if isinstance(value, float) else f"{key}: {value}")

    sns.heatmap(conf_matrix, annot=True, fmt='d', cmap='Blues', ax=axs[1, 1])
    axs[1, 1].set_title('Confusion Matrix')

    # Calculate errors and plot error histogram
    errors = test_targets - y_pred
    axs[0, 1].hist(errors.flatten(), bins=50, alpha=0.5, color='orange', edgecolor='black')
    axs[0, 1].set_title('Error Histogram')

    # Show the combined plots
    plt.tight_layout()
    plt.show()
   

    return history, model, targetsNN, outputsNN, performanceNN, None, y_pred, y_true, None, loss_curve



