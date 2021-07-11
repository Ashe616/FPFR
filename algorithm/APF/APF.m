clear;clc
tic
load("dataset1.mat")

chaData = ComputeCharacterVector(data);
clusterData = FirstArrivalTools.DimensionConversion1(chaData);
[~, U] = fcm(clusterData, 2);
label = FirstArrivalTools.GetLabel(U');
label = FirstArrivalTools.DimensionConversion2(label, size(chaData));
firstArrivals = FirstArrivalTools.GetFirstArrivals(label);

a1 = ComputeAccuracy(standardFirstArrivals, firstArrivals(1, :));
a2 = ComputeAccuracy(standardFirstArrivals, firstArrivals(2, :));
[acc, idx] = max([a1, a2]);
acc
f = firstArrivals(idx, :);
PlotWaveAPoint(data, firstArrivals(idx, :), acc)

toc