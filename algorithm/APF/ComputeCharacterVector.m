function chaData = ComputeCharacterVector(data)
successivePointsNum = 5;
invalidPointsNum = floor(successivePointsNum / 2);

s = size(data);
chaData = zeros(s(1) - 2 * invalidPointsNum, s(2), 3);
for j = 1:s(2)
    for i = invalidPointsNum + 1: s(1) - invalidPointsNum
        chaData(i - invalidPointsNum, j, 1) = sum(data(i - invalidPointsNum: i + invalidPointsNum, j) .^ 2);
        chaData(i - invalidPointsNum, j, 2) = mean(data(i - invalidPointsNum: i + invalidPointsNum, j));
        chaData(i - invalidPointsNum, j, 3) = std(data(i - invalidPointsNum: i + invalidPointsNum, j), 1);
    end
end
end