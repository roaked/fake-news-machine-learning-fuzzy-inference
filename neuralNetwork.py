import matplotlib.pyplot as plt
import numpy as np
import seaborn as sns 
from sklearn.metrics import confusion_matrix
from sklearn.neural_network import MLPRegressor
import tensorflow as tf
from sklearn.model_selection import train_test_split

# Function to get model weights
def get_model_weights(model):
    return [layer.get_weights() for layer in model.layers]
   

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

    initial_weights = get_model_weights(model) # Get weights before training

    # Compile the model
    model.compile(optimizer='adam', loss='mean_squared_error')

     # Train the model and record the history to get the loss curve
    history = model.fit(train_inputs, train_targets, epochs=20, batch_size=32, validation_data=(test_inputs, test_targets))

    final_weights = get_model_weights(model) # Get weights after training

    # Create subplots for various visualizations
    fig, axs = plt.subplots(2, 2, figsize=(12, 10))

    # Compare weights before and after training
    for i, (initial_layer_weights, final_layer_weights) in enumerate(zip(initial_weights, final_weights)):
        weight_changes = [fw - iw for iw, fw in zip(initial_layer_weights, final_layer_weights)]
        ax = axs[i // 2, i % 2]
        ax.hist(weight_changes[0].flatten(), bins=50, alpha=0.5, label='Layer {} Weights'.format(i))
        ax.set_title('Weight Changes in Layer {}'.format(i))
        ax.legend()

    # Get the loss curve from history
    loss_curve = history.history['loss']

    # Plot the loss curve
    axs[1, 0].plot(loss_curve)
    axs[1, 0].set_title('Loss Curve')

    print(test_inputs)


    # Generate predictions on the test set
    predictions = model.predict(test_inputs)
    #y_pred = np.argmax(predictions, axis=1)

    #if len(test_targets.shape) > 1:
    #    y_true = np.argmax(test_targets, axis=1)
    #else:
    #    y_true = test_targets

    # Predict on the test set
    y_pred = model.predict(test_inputs)
    y_true = test_targets

    # Predict on the training set for performance evaluation
    outputsNN = model.predict(train_inputs)
    performanceNN = model.evaluate(train_inputs, train_targets)  # Get the evaluation metric from training

    # Create and display the confusion matrix
    conf_matrix = confusion_matrix(y_true, y_pred)
    sns.heatmap(conf_matrix, annot=True, fmt='d', cmap='Blues', ax=axs[1, 1])
    axs[1, 1].set_title('Confusion Matrix')


    # Calculate errors and plot error histogram
    errors = test_targets - predictions
    axs[0, 1].hist(errors.flatten(), bins=50, alpha=0.5, color='orange', edgecolor='black')
    axs[0, 1].set_title('Error Histogram')

    # Show the combined plots
    plt.tight_layout()
    plt.show()
   

    return history, model, targetsNN, outputsNN, performanceNN, None, y_pred, y_true, None, loss_curve



