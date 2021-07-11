function [bestSmoothAns, globalOptPop] = GeneticAlgorithm(initialFirstArrival, clusterData)
start = ceil(0.025 * length(initialFirstArrival));
if(mod(start, 2) == 0)
    start = start + 1;
end
pFeasibleRegion = start:2:(0.15 * length(initialFirstArrival));
dFeasibleRegion = [1, 2];
feasibleRegion = {pFeasibleRegion, dFeasibleRegion};

popSize = 20;
pc= 0.7;
pm = 0.1;
maxGen = 5;
M = 999;

pops = zeros(popSize, length(feasibleRegion));
fitness = zeros(popSize, 3);
for i = 1: popSize
    pops(i, :) = Code(feasibleRegion);
    [fitness(i, 1), fitness(i, 2)] = ComputeFitness(pops(i, :), initialFirstArrival, clusterData);
    fitness(i ,3) = 1 / (fitness(i, 1) + M * (max(fitness(i, 2), 1) - 1));
end
[~, optPopIndex] = max(fitness(:, 3));
globalOptPop = pops(optPopIndex, :);
localOptPop = pops;
globalOptFitness = fitness(optPopIndex, :);
localOptFitness = fitness;

for iter = 1:maxGen
    pops = Select(pops, fitness);
    pops = Cross(pc, pops);
    pops = Mutation(pm, pops, feasibleRegion);
    for j = 1:popSize
        [fitness(j, 1), fitness(j, 2)] = ComputeFitness(pops(j, :), initialFirstArrival, clusterData);
        fitness(j ,3) = 1 / (fitness(j, 1) + M * (max(fitness(j, 2), 1) - 1));
        if(fitness(j, 3) > localOptFitness(j ,3))
            localOptFitness(j, :) = fitness(j, :);
            localOptPop(j, :) = pops(j, :);
        end
        if(fitness(j, 3) > globalOptFitness(3))
            globalOptFitness = fitness(j, :);
            globalOptPop = pops(j, :);
        end
    end
    fprintf("第%d代 最优适应度为：%f\n", iter, globalOptFitness(3));
end
bestSmoothAns = round(SmoothFirstArrival(initialFirstArrival, globalOptPop(1), globalOptPop(2)));
end

function pop = Code(feasibleRegion)
pop = zeros(1, length(feasibleRegion));
for i = 1:length(feasibleRegion)
    tempFeasibleRegion = cell2mat(feasibleRegion(i));
    tempIndex = unidrnd(length(tempFeasibleRegion));
    pop(i) = tempFeasibleRegion(tempIndex);
end
end

function [energyRatio, covOf2Order] = ComputeFitness(pop, initialFirstArrival, clusterData)
tempSmoothAns = round(SmoothFirstArrival(initialFirstArrival, pop(1), pop(2)));
energyRatio = ComputeAverageEnergyRatio(tempSmoothAns, clusterData);
covOf2Order = cov(diff(diff(tempSmoothAns)));
end

function ret = Select(pops, fitness)
popSize = size(pops, 1);
tempFitness = fitness(:, 3);
pickPro = tempFitness / sum(tempFitness);
pickProCum = cumsum(pickPro);
index = zeros(popSize, 1);
for i = 1:popSize
    p = rand();
    temp = find(pickProCum >= p);
    index(i) = temp(1);
end
ret = pops(index, :);
end

function ret = Cross(pc, pops)
[popSize, lenChrom] = size(pops);
ret = pops;
for i = 1:popSize
    if rand() > pc
        continue;
    end
    
    p = rand(1, 2);
    crossAimIndex = ceil(popSize * p);
    p = rand();
    position = ceil(p * lenChrom);
    temp = ret(crossAimIndex(1), position);
    ret(crossAimIndex(1), position) = ret(crossAimIndex(2), position);
    ret(crossAimIndex(2), position) = temp;
end
end

function ret = Mutation(pm, pops, feasibleRegion)
[popSize, lenChrom] = size(pops);
len = zeros(lenChrom, 1);
for i = 1:lenChrom
    len(i) = length(cell2mat(feasibleRegion(i)));
end
len = len / sum(len);
len = cumsum(len);

ret = pops;
for i = 1:popSize
    if rand() > pm
        continue;
    end
    
    p = rand();
    temp = find(len > p);
    position = temp(1);
    
    currentValue = ret(i, position);
    tempFeasibleRegion = cell2mat(feasibleRegion(position));
    tempFeasibleRegion = setdiff(tempFeasibleRegion, currentValue);
    tempIndex = unidrnd(length(tempFeasibleRegion));
    ret(i, position) = tempFeasibleRegion(tempIndex);
end
end