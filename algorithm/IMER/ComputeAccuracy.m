function acc = ComputeAccuracy(stdF, firstArrivals)
tempArray = abs(stdF - firstArrivals);
acc = sum(tempArray <= 10) / length(firstArrivals);
end