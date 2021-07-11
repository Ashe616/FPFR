clear;clc

tic
load("../../data/TheoreticalData1.mat")

noisyData = AddNoise(data, -7);
chaData = ComputeCharacterVector(noisyData);
clusterData = FirstArrivalTools.DimensionConversion1(chaData);
[~, U] = fcm(clusterData, 2);
label = FirstArrivalTools.GetLabel(U');
label = FirstArrivalTools.DimensionConversion2(label, size(chaData));
firstArrivals = FirstArrivalTools.GetFirstArrivals(label);

a1 = ComputeAccuracy(standardFirstArrivals, firstArrivals(1, :));
a2 = ComputeAccuracy(standardFirstArrivals, firstArrivals(2, :));
[acc, idx] = max([a1, a2]);

f = firstArrivals(idx, :);
PlotWaveAPoint(noisyData, firstArrivals(idx, :), acc)

toc