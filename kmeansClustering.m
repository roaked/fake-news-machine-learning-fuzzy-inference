function [kmeansTest,kmeansCluster] = kmeansClustering(trainingData,testingData,testingClass)

[pointsKM, ~] = kmeans(trainingData', 6);  %6 clusters

MdlKDT = KDTreeSearcher(trainingData');
% KDTreeSearcher object performs KNN (K-nearest-neighbor) search or
% radius search using a kd-tree. You can create a KDTreeSearcher object
% based on X

for i = 1:length(testingData)
obsNumber(i) = knnsearch(MdlKDT,testingData(:,i)');

% Knnsearch finds the nearest neighbor in X for each point in Y.

cluster(i) = pointsKM(obsNumber(i));
end

fakeKMeans = mode(pointsKM);

kmeansTest = testingClass(1,:);
kmeansCluster = cluster;

for i = 1:length(kmeansCluster)
    if kmeansCluster(i) ~= fakeKMeans
        kmeansCluster(i) = 1;
    else
        kmeansCluster(i) = 0;
    end
end

end