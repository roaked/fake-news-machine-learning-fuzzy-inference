import numpy as np

# INPUT
# group = true class labels
# grouphat = predicted class labels

# OR INPUT
# stats = confusionmatStats(group);
# group = confusion matrix from matlab function (confusionmat)

# OUTPUT
# stats is a structure array
# stats.confusionMat
#               Predicted Classes
#                    p'    n'
#              ___|_____|_____| 
#       Actual  p |     |     |
#      Classes  n |     |     |

# stats.accuracy = (TP + TN)/(TP + FP + FN + TN) ; the average accuracy is returned
# stats.precision = TP / (TP + FP)                  % for each class label
# stats.sensitivity = TP / (TP + FN)                % for each class label
# stats.specificity = TN / (FP + TN)                % for each class label
# stats.recall = sensitivity                        % for each class label
# stats.Fscore = 2*TP /(2*TP + FP + FN)            % for each class label

# TP: true positive, TN: true negative, 
# FP: false positive, FN: false negative

def confusionmatStats(group, grouphat=None):
    if grouphat is None:
        value1 = group
    else:
        value1 = np.array([[np.sum((group == i) & (grouphat == j)) for j in np.unique(grouphat)] for i in np.unique(group)])

    numOfClasses = value1.shape[0]
    totalSamples = np.sum(value1)
    
    accuracy = (2 * np.trace(value1) + np.sum(2 * value1)) / (numOfClasses * totalSamples) - 1

    TP = np.diag(value1)
    FP = np.sum(value1, axis=0) - TP
    FN = np.sum(value1, axis=1) - TP

    # Calculate TN without deletions
    TN = []
    for i in range(numOfClasses):
        mask = np.ones_like(value1, dtype=bool)
        mask[i] = False  # Exclude the i-th row
        mask[:, i] = False  # Exclude the i-th column
        TN.append(np.sum(value1[mask]) - FP[i] - FN[i] + TP[i])

    sensitivity = TP / (TP + FN)
    specificity = np.array(TN) / (np.array(FP) + np.array(TN))
    precision = TP / (TP + FP)
    f_score = 2 * TP / (2 * TP + FP + FN)

    stats = {
        'confusionMat': value1,
        'accuracy': accuracy,
        'sensitivity': sensitivity,
        'specificity': specificity,
        'precision': precision,
        'recall': sensitivity,
        'Fscore': f_score
    }

    return stats