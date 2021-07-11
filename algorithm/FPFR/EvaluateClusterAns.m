function [bestAns, value] = EvaluateClusterAns(label, firstArrivals ,clusterData)
%%
s = size(firstArrivals);
bestAns = cell(1,2);
value = zeros(2, s(1));
for i = 1:s(1)
    if min(firstArrivals(i,:)) <= 0 || max(firstArrivals(i,:)) > size(clusterData ,1)
        value(:,i) = inf;
        continue;
    end
    value(1,i) = ComputeAverageEnergyRatio(firstArrivals(i,:), clusterData);
end
value(2, :) = ComputeEnergyCharacteristic(clusterData, label);

tempMinValue = min(value(1, value(2,:) > 0.45));
if length(tempMinValue) ~= 0
    tempMinIndex = find(value(1,:) == tempMinValue);
    bestAns(1) = {firstArrivals(tempMinIndex,:)};
    bestAns(2) = {value(:,tempMinIndex)};
else
    bestAns(1) = {nan};
    bestAns(2) = {[inf;inf]};
end
return