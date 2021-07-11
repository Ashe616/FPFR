function c = ComputeEnergyCharacteristic(clusterData, label)
data = clusterData(:, :, 1);
s = size(data);
data = reshape(data, s(1) * s(2), 1);
label = reshape(label, s(1) * s(2), 1);
minLabel = min(label, [], 'all');
maxLabel = max(label, [], 'all');
c = zeros(1, maxLabel - minLabel + 1);
for l = minLabel:maxLabel
    tempData = abs(data(find(label == l)));
    c(1, l) = mean(tempData);
end