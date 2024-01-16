function [MaxAccuracy,Ym,YClassOptimal,YClass,FM] = fuzzyModel(trainingData,trainingClass,testingData,testingClass)

Input = trainingData';
Output = trainingClass';

DAT.U=Input; %Feature 1 e 3

DAT.Y=Output(:,1); % Basta uma das linhas do metaTargets
STR.c = 6;

% for i=1:1:9
    
    
 
    
    [FM,~] = fmclust(DAT,STR);

    [Ym,~,~,~,~] = fmsim(testingData',testingClass',FM); 

    %Threshold to define if fake or true

    Threshold = 0.00;
    MaxAccuracy = 0.00;
    MaxThreshold = 0.00;

    while(Threshold < 1.00) 
        for i = 1:size(Ym)
            if Ym(i) > Threshold
                YClass(i) = 1;
            else
              YClass(i) = 0;
            end
        end
     %plotconfusion(testingClass(1,:),YClass)
    stats = confusionmatStats(testingClass(1,:),YClass);
    if MaxAccuracy < stats.accuracy
        
            MaxAccuracy = stats.accuracy;
            MaxThreshold = Threshold;
    end
    
    Threshold = Threshold + 0.01;    
    end

    for i = 1:size(Ym)
        if Ym(i) > MaxThreshold
            YClassOptimal(i) = 1;
        else
            YClassOptimal(i) = 0;
        end
    end
%     close all
%     clusterNumber = clusterNumber + i;
% end
end