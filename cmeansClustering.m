function [cmeansTest,cmeansCluster,cmeansAcc,exponentValue] = cmeansClustering(trainingData,testingData,testingClass)

p = 1.1;
u=1;

for p=1.1:0.1:3.5
    options = [p 150 0.0000001 0];
    exponentValue(u) = p;
    [centersCM, ~]= fcm(trainingData', 6,options); %6 clusters

    totalDelta = 0;
    %i = news index
    %j = cluster index
    %k = parameters index
    for i = 1:length(testingData)
        for j = 1:size(centersCM,1)
             for k = 1:size(centersCM,2)
                %distance between each parameter k and each cluster j of news i
                delta = (testingData(k,i)-centersCM(j,k))^2;
                totalDelta = totalDelta + delta;
             end
            %distance of news i to cluster j
            dist(j,i) = sqrt(totalDelta);
            totalDelta = 0;

        end
        [~,ClusterIndex] = min(dist(:,i));
        cluster(i) = ClusterIndex;
    end

    fakeCMeans = mode(cluster);

    cmeansTest = testingClass(1,:);

    cmeansCluster = cluster;

    for i = 1:length(cmeansCluster)
          if cmeansCluster(i) ~= fakeCMeans
              cmeansCluster(i) = 1;
          else
             cmeansCluster(i) = 0;
          end
    end
    
         
    stats = confusionmatStats(cmeansTest,cmeansCluster);
    cmeansAcc(u) = stats.accuracy;
    u=u+1;
    end
    
%%%%%%%%%%%%%%%%%%%%%%Highest Vale%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    maximum = max(cmeansAcc);
    [~,highestExponent]=find(cmeansAcc==maximum);
    highestExponent = highestExponent/10 + 1.1;
    options = [ highestExponent(1) 150 0.0000001 0];
    [centersCM, ~]= fcm(trainingData', 6,options); %6 clusters

    totalDelta = 0;
    %i = news index
    %j = cluster index
    %k = parameters index
    for i = 1:length(testingData)
        for j = 1:size(centersCM,1)
             for k = 1:size(centersCM,2)
                %distance between each parameter k and each cluster j of news i
                delta = (testingData(k,i)-centersCM(j,k))^2;
                totalDelta = totalDelta + delta;
             end
            %distance of news i to cluster j
            dist(j,i) = sqrt(totalDelta);
            totalDelta = 0;

        end
        [~,ClusterIndex] = min(dist(:,i));
        cluster(i) = ClusterIndex;
    end

    fakeCMeans = mode(cluster);

    cmeansTest = testingClass(1,:);

    cmeansCluster = cluster;

    for i = 1:length(cmeansCluster)
          if cmeansCluster(i) ~= fakeCMeans
              cmeansCluster(i) = 1;
          else
             cmeansCluster(i) = 0;
          end
    end

end