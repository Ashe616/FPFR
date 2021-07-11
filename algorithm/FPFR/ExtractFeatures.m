function featureData = ExtractFeatures(data)
s = size(data);
featureData = zeros(s(1), s(2), 2);
featureData(:, :, 1) = abs(data);

for j = 1:s(2)
    i = 1;
    while true
        count = 0;
        if i > s(1)
            break;
        end
        if data(i, j) == 0
            i = i + 1;
            continue 
        end
        while true
            if i + count > s(1)
                break;
            end
            if data(i + count, j) * data(i, j) < 0
                break;
            else
                count = count + 1;
            end
        end
        maxValue = max(abs(data(i:i + count - 1, j)));
        featureData(i:i + count - 1, j, 2) = maxValue;
        i = i + count;
    end
end
end