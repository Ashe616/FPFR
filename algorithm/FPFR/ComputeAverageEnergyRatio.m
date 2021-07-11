function [energyRatio, energy] = ComputeAverageEnergyRatio(firstArrival, data)
%%
energy = zeros(2, size(firstArrival, 2));
ratio = zeros(1, size(firstArrival, 2));
count = 20;
for j = 1:size(firstArrival, 2)
    if 1 <= firstArrival(j) && firstArrival(j) <= size(data, 1)
        data1 = data(max(firstArrival(j) - count, 1):firstArrival(j), j, 1);
        data2 = data(firstArrival(j):min(firstArrival(j) + count, size(data ,1)), j, 1);
        energy(1,j) = sum(data1) / length(find(data1 ~= 0));
        energy(2,j) = sum(data2) / length(find(data2 ~= 0));
        ratio(j) = energy(1, j) / energy(2, j);
    else
        ratio(j) = 1;
    end
end
energyRatio = mean(ratio, 'omitnan');