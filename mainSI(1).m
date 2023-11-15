%Intelligent Systems 2019/20
%Work 4 - Group 7: Fake news automatic detection using metadata
%Authors:
%Nº80998  Name: Pedro Miguel Menezes Ramalho
%Nº85183  Name: Ricardo Miguel Diogo de Oliveira Chin
%Nº93807  Name: Henrique Manuel Caldeira Pimentel Furtado

clc
close all
clear all

folder=strcat(pwd,'\FMID5\');
addpath(folder)

fprintf('\nIntelligent Systems 2019/20\n');
fprintf('This program detects fake news automatic using metadata\n');

%% Data Processing

load('newsData2');
load('newsDataLing2');

selec = 0;

while(selec==0) 
    fprintf('\nPick an option for the features:\n');
    fprintf('1: All Features   2: Linguistic Features Only\n');
    fprintf('0: Exit program\n');
    fprintf('\n'); 
    option = input('');
    valid=0;
    warning on
  
    switch(option)
        case 0
            valid=1;
        case 1
            valid=1;
            features=1; %all features
            testingClass1 = testingClass;
            testingData1 = testingData;
            trainingClass1 = trainingClass;
            trainingData1 = trainingData;
            
        case 2
            valid=1;
            testingClass1 = testingClassLing;
            testingData1 = testingDataLing;
            trainingClass1 = trainingClassLing;
            trainingData1 = trainingDataLing;
            features=0; %linguistic features only
    end
    
        if(valid==0)
            fprintf('\nError! Invalid choice!\n');
        end
       
    if valid == 1 && option ~= 0
         warning off
         fprintf('Program loading...\n')

%% Results

selec2=0;
while(selec2==0)
    fprintf('\nPick an option for the methods:\n');
    fprintf('1: C-Means Clustering       2: K-Means Clustering\n');   
    fprintf('3: T-S Fuzzy Model          4: ANN\n'); 
    fprintf('0: Press 0 if you want to go back\n'); 
    fprintf('\n'); 
    option2 = input('');
    valid2=0;
    close all
    switch(option2)
        case 0
            valid2=1;
            selec2=1;
        case 1
            valid2=1;
            [cmeansTest,cmeansCluster,cmeansAcc,exponentValue] = cmeansClustering(trainingData1,testingData1,testingClass1);
            figure (1), hold on;
            plotconfusion(cmeansTest,cmeansCluster);
            title('Confusion Matrix of C-Means Clustering');
            
            figure (2), hold on;
            plot(exponentValue,cmeansAcc)
            title('Max Accuracy vs Exponent (m) value');
            ylabel('Max Accuracy');
            xlabel('Exponent (m) value');
                        
        case 2
            valid2=1;
            [kmeansTest,kmeansCluster] = kmeansClustering(trainingData1,testingData1,testingClass1);
            plotconfusion(kmeansTest,kmeansCluster);
            title('Confusion Matrix of K-Means Clustering');
        case 3
            valid2=1;
            [MaxAccuracy,Ym,YClassOptimal,YClass,FM,clusterNumber] = fuzzyModel(trainingData1,trainingClass1,testingData1,testingClass1);

            figure (1), hold on;
            plotmfs(FM)
            fm2tex(FM,'membershipEquations.tex');
            
            figure (2), hold on;
            plot(clusterNumber,MaxAccuracy);
            title('Max Accuracy vs Number of Clusters');
            ylabel('Max Accuracy');
            xlabel('Number of Clusters');
           
            figure (3), hold on;
            plotconfusion(testingClass1(1,:),YClassOptimal);
            title('Confusion Matrix of T-S FM Model with Optimal Threshold');
            
        case 4
            close all
            valid2=1;
            [trNN,targetsNN,outputsNN,performanceNN,errorsNN,netNN] = neuralNetwork(trainingData1,trainingClass1);
            % view neural network
             view(netNN)

            figure (1), plotperform(trNN)
            figure (2), plottrainstate(trNN)
            figure (3), plotconfusion(targetsNN,outputsNN)
            title('Confusion Matrix of ANN');
            figure (4), ploterrhist(errorsNN)
            
    end 
        if(valid2==0)
            fprintf('\nError! Invalid choice!\n');
        end
end




   %%%%%%%%%%%%%%%%%%%%%%%%%%%%First Option       
         
    elseif valid == 1 && option == 0
        selec=1; %Closes the loop
        fprintf('\nProgram ended.\n\n');          
    end  
end

clear features option option2 selec selec2 valid valid2 testingClassLing...
testingDataLing trainingClassLing trainingDataLing 