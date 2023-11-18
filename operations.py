import matplotlib.pyplot as plt
from sklearn.metrics import confusion_matrix
import copy
import seaborn as sns


def plot_loss_curve(history):
    plt.plot(history.history['loss'], label='Training Loss')
    plt.plot(history.history['val_loss'], label='Validation Loss')
    plt.xlabel('Epochs')
    plt.ylabel('Loss')
    plt.legend()
    plt.title('Training and Validation Loss')
    plt.show()

def plot_train_state_before_after(trained_model):
    # Assuming trained_model is the trained neural network model (MLPRegressor) in Scikit-learn
    
    # Get the initial weights of the model
    initial_weights = copy.deepcopy(trained_model.coefs_)

    # Get the trained weights after training
    trained_weights = trained_model.coefs_

    # Plotting the change in weights before and after training
    fig, axs = plt.subplots(len(initial_weights), 2, figsize=(10, 8))
    fig.suptitle('Weights Before and After Training')

    for i in range(len(initial_weights)):
        axs[i, 0].imshow(initial_weights[i], cmap='viridis', aspect='auto')
        axs[i, 0].set_title(f'Layer {i+1} - Before Training')
        axs[i, 1].imshow(trained_weights[i], cmap='viridis', aspect='auto')
        axs[i, 1].set_title(f'Layer {i+1} - After Training')

    plt.tight_layout()
    plt.show()

def plot_confusion_matrix(true_labels, predicted_labels):
    # Assuming true_labels and predicted_labels are available from tTst and yTst

    # Calculate confusion matrix
    confusion_mat = confusion_matrix(true_labels, predicted_labels)

    # Plotting the confusion matrix using seaborn heatmap
    plt.figure(figsize=(8, 6))
    sns.heatmap(confusion_mat, annot=True, fmt='d', cmap='Blues', cbar=False)
    plt.xlabel('Predicted Label')
    plt.ylabel('True Label')
    plt.title('Confusion Matrix')
    plt.show()

def plot_error_histogram(errors):
    # Assuming errorsNN contains the errors from your neural network predictions
    # Plotting the error histogram
    plt.figure(figsize=(8, 6))
    plt.hist(errors, bins=30, edgecolor='black')
    plt.xlabel('Errors')
    plt.ylabel('Frequency')
    plt.title('Error Histogram of ANN')
    plt.show()

