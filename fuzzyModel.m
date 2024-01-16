function [MaxAccuracy,Ym,YClassOptimal,YClass,FM,clusterNumber] = fuzzyModel(trainingData,trainingClass,testingData,testingClass)

Input = trainingData';
Output = trainingClass';

DAT.U=Input; %Feature 1 e 3

DAT.Y=Output(:,1); % Basta uma das linhas do metaTargets
clusterNumber(1)=2;


for j=1:20
     clusterNumber(j) = clusterNumber(1) +  j - 1;
    STR.c = clusterNumber(j);

    
    [FM,~] = fmclust(DAT,STR);

    [Ym,~,~,~,~] = fmsim(testingData',testingClass',FM); 

    %Threshold to define if fake or true

    Threshold = 0.00;
    MaxAccuracy(j) = 0.00;
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
        if MaxAccuracy(j) < stats.accuracy
        
               MaxAccuracy(j) = stats.accuracy;
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
  
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    maximum = max(MaxAccuracy);
    [~,highestCluster]=find(MaxAccuracy==maximum);
    STR.c = clusterNumber(highestCluster(1));

   
    [FM,~] = fmclust(DAT,STR);

    [Ym,~,~,~,~] = fmsim(testingData',testingClass',FM); 

    %Threshold to define if fake or true

    Threshold = 0.00;
    MaxAccuracy(j) = 0.00;
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
    if MaxAccuracy(j) < stats.accuracy
        
            MaxAccuracy(j) = stats.accuracy;
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




end