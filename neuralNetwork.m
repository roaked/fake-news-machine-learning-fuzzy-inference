function [trNN,targetsNN,outputsNN,performanceNN,errorsNN,netNN,yTst,tTst] = neuralNetwork(trainingData,trainingClass)

trainingData = trainingData';
trainingClass = trainingClass';

inputsNN = [trainingData]'; 
targetsNN = [trainingClass(:,1)]';

% Create a Pattern Recognition Network
fprintf('\nPick an option for the neural network:\n');
fprintf('1:[5] 2:[10] 3:[15]\n');
fprintf('4:[2 2] 5:[5 5] 6:[10 10]\n');
fprintf('7:[2 2 2] 8:[4 4 4] 9:[6 6 6]\n');
fprintf('10:[2 2 2 2] 11:[4 4 4 4]\n');
fprintf('\n'); 
option = input('');

switch(option)
    case 1
        hiddenSize = [5];
    case 2
        hiddenSize = [10];
    case 3
        hiddenSize = [15];
    case 4        
        hiddenSize = [2 2];
    case 5
        hiddenSize = [5 5];
    case 6
        hiddenSize = [10 10];
    case 7
        hiddenSize = [2 2 2];
    case 8
        hiddenSize = [4 4 4];
    case 9
        hiddenSize = [6 6 6];
    case 10
        hiddenSize = [2 2 2 2];
    case 11
        hiddenSize = [4 4 4 4];
end

netNN = patternnet(hiddenSize);

% Set up Division of Data for Training, Validation, Testing
netNN.trainFcn ='trainlm';
netNN.divideParam.trainRatio = 70/100;
netNN.divideParam.valRatio = 5/100;
netNN.divideParam.testRatio = 25/100;
% netNN.trainParam.lr=0.05; % learning rate
% netNN.trainParam.mc=0.5;% Momentum constant

% Train the Network
[netNN,trNN] = train(netNN,inputsNN,targetsNN);

 yTst = netNN(inputsNN(:,trNN.testInd));
 tTst = targetsNN(:,trNN.testInd);

% Test the Network
outputsNN = netNN(inputsNN);
errorsNN = gsubtract(targetsNN,outputsNN);
performanceNN = perform(netNN,targetsNN,outputsNN);

end


