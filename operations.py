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

