function [IMER, f] = ComputeIMER(data, nt1, nt2, nt3, times)
len = length(data);
ER12 = zeros(len - nt1 - nt2, 1);
ER13 = zeros(len - nt1 - nt2 - nt3, 1);
MER12 = zeros(len - nt1 - nt2, 1);
MER13 = zeros(len - nt1 - nt2 - nt3, 1);
MA12 = zeros(len - nt1 - nt2, 1);
MA13 = zeros(len - nt1 - nt2 - nt3, 1);
aveFitLen = 7;

for i = nt2 + 1:len - nt1
    ER12(i - nt2) = sum(data(i:i + nt1) .^ 2) / sum(data(i - nt2:i) .^ 2);
    MER12(i - nt2) = (ER12(i - nt2) * abs(data(i))) .^ 3;
end
for i = nt3 + nt2 + 1:len - nt1
    ER13(i - nt3 - nt2) = sum(data(i:i + nt1) .^ 2) / sum(data(i - nt3 - nt2:i - nt2) .^ 2);
    MER13(i - nt3 - nt2) = (ER13(i - nt3 - nt2) * abs(data(i - nt2))) .^ 3;
end
%%
MER12(find(isnan(MER12))) = 0;
MER13(find(isnan(MER13))) = 0;
%%

MA12 = MeanFiltering(MER12, aveFitLen);
MA13 = MeanFiltering(MER13, aveFitLen);

IMER = MA12(nt3 + 1:end) - MA13;

threshold = mean(IMER) * times;
if threshold > 0
    f = find(IMER > threshold);
else
    f = find(IMER < threshold);
end
if isempty(f)
    f = false;
else
    f = f(1);
    f = f + nt2 + nt3;
end