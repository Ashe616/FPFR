clear;clc

load("../../data/TheoreticalData1.mat")

SNR = -7;
data = AddNoise(data, SNR);

tic
clusterData = ExtractFeatures(data);

%%pre-picking
minK = 2;
maxK = 5;
information = cell(4, maxK - minK + 1);
for k = minK:maxK
    %% 
    tempData = FirstArrivalTools.DimensionConversion1(clusterData);
    [~, U] = fcm(tempData, k, [2, 1000, 1e-5, 1]);
    label = FirstArrivalTools.GetLabel(U');
    label = FirstArrivalTools.DimensionConversion2(label, size(clusterData));
    firstArrivals = FirstArrivalTools.GetFirstArrivals(label);

    %%
    [evaluateValue, allValue] = EvaluateClusterAns(label, firstArrivals, clusterData);
    information(1, k - minK + 1) = {firstArrivals};
    information(2, k - minK + 1) = evaluateValue(1);
    information(3, k - minK + 1) = evaluateValue(2);
    information(4, k - minK + 1) = {allValue};
end
tempEvaluateArray = cell2mat(information(3,:));
[~, bestIndex1] = min(tempEvaluateArray(1,:));bestK = bestIndex1 + minK - 1
initialFirstArrival = cell2mat(information(2, bestIndex1));
acc1 = ComputeAccuracy(standardFirstArrivals, initialFirstArrival)
PlotWaveAPoint(data, initialFirstArrival, acc1)

%%smoothing
[firstArrival, optPop] = GeneticAlgorithm(initialFirstArrival, clusterData);
acc2 = ComputeAccuracy(standardFirstArrivals, firstArrival)
PlotWaveAPoint(data, firstArrival, acc2)
toc