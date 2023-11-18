import matplotlib.pyplot as plt
import copy

def plot_loss_curve(trained_model):
    # Assuming trained_model is the trained neural network model (MLPRegressor) in Scikit-learn
    
    # Accessing the loss curve during training from the 'loss_' attribute of the model
    loss_curve = trained_model.loss_curve_

    # Plotting the loss curve
    plt.figure()
    plt.plot(loss_curve, label='Loss Curve')
    plt.title('Loss Curve of Neural Network')
    plt.xlabel('Number of Iterations')
    plt.ylabel('Loss')
    plt.legend()
    plt.show()


