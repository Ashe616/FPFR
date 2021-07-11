clear;clc

tic
load("template.mat");
load("../../data/TheoreticalData1.mat")
noisyData = AddNoise(data, -7);
firstArrival = ComputeCCT(noisyData, template);

acc = ComputeAccuracy(standardFirstArrivals, firstArrival)
PlotWaveAPoint(noisyData, firstArrival, acc);
toc
