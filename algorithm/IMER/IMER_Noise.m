clear;clc
tic
load("../../data/TheoreticalData1.mat")

%%
nt1 = 6;
nt2 = 12;
nt3 = 12;
times = 16;

%%
noisyData = AddNoise(data, -7);

s = size(noisyData, 2);
f = zeros(1, s);
flag = true;
for i = 1:s
    [a(:,i), temp] = ComputeIMER(noisyData(:, i), nt1, nt2, nt3, times);
    if temp == false
        fprintf("ãÐÖµ¹ý´ó£¡\n");
        flag = false;
        break;
    end
    f(i) = temp;
end
if flag
    acc = ComputeAccuracy(standardFirstArrivals, f)
    PlotWaveAPoint(noisyData, f, acc);
end

toc