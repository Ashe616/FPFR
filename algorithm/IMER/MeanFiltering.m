function data = MeanFiltering(paraData, len)
data = paraData;
negData = data; 
posData = data;
halfLen = floor(len / 2);
for i = 1:halfLen
    negData = [0; negData(1:end - 1)];
    posData = [posData(2:end); 0];
    data = data + negData + posData;
end

data(halfLen + 1:size(paraData, 1) - halfLen) = data(halfLen + 1:size(paraData, 1) - halfLen) ./ len;
for i = 1:halfLen
    data(i) = data(i) / (halfLen + i);
    data(end - i + 1) = data(end - i + 1) / (halfLen + i);
end