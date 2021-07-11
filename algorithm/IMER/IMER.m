clear;clc

tic
%%
load("dataset1");
nt1 = 6;
nt2 = 12;
nt3 = 12;
times = 8;

% load("dataset2");
% nt1 = 6;
% nt2 = 12;
% nt3 = 12;
% times = 10;

% load("dataset3");
% nt1 = 8;
% nt2 = 16;
% nt3 = 16;
% times = 20;

% load("dataset4");
% nt1 = 6;
% nt2 = 12;
% nt3 = 12;
% times = 41;

% load("dataset5.mat")
% nt1 = 4;
% nt2 = 8;
% nt3 = 8;
% times = 4;

% load("dataset6.mat")
% nt1 = 2;
% nt2 = 26;
% nt3 = 26;
% times = 20;

%%
s = size(data, 2);
f = zeros(1, s);
flag = true;
for i = 1:s
    [a(:,i), temp] = ComputeIMER(data(:, i), nt1, nt2, nt3, times);
    if temp == false
        fprintf("ãÐÖµ¹ý´ó£¡\n");
        flag = false;
        break;
    end
    f(i) = temp;
end
if flag
    acc = ComputeAccuracy(standardFirstArrivals, f)
    PlotWaveAPoint(data, f, acc);
end

toc