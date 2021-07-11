clear;clc

tic
load("dataset1.mat")
load("template1.mat")

firstArrival = ComputeCCT(data, template);

acc = ComputeAccuracy(standardFirstArrivals, firstArrival)
PlotWaveAPoint(data, firstArrival, acc);
toc