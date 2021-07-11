function f = ComputeCCT(dataset,template)
[m,n] = size(dataset);
f = zeros(1,n);
for j = 1:n
    r = xcorr(dataset(:,j),template);
    r = r(m:end);
    [~,f(j)] = max(r);
end