function sf = SmoothFirstArrival(firstArrival, span, method)
%%
    if isnumeric(method)
        d = method;
        isUseRobust = true;
    else
        methods = struct('lowess', 1, 'loess', 2, 'rlowess', 1, 'rloess', 2);
        useRobust = struct('lowess', false, 'loess', false, 'rlowess', true, 'rloess', true);
        d = methods.(method);
        isUseRobust = true;
    end
    
    if span < 1
        span = floor(length(firstArrival) * span);
    end
    if ~mod(span, 2)
        span = span + 1;
    end
    
    if span == 3
        sf = firstArrival;
        return
    end
    
    n = length(firstArrival);
    halfSpan = floor(span / 2);
    lBound = min(max((1:n) - halfSpan, 1) + 2 * halfSpan, n) - 2 * halfSpan;
    rBound = max(min((1:n) + halfSpan, n) - 2 * halfSpan, 1) + 2 * halfSpan;
    sf = zeros(1, length(firstArrival));
    
    for i = 1:n
        wR = WeightedRegression(lBound(i):rBound(i), firstArrival(lBound(i):rBound(i)), d, i, ones(span, 1));
        sf(1,i) = wR.aimValue;
    end
    
    if isUseRobust
        for tempIter = 1:5
            residual = firstArrival - sf;
            robustWeight = ComputeRobustWeight(residual, firstArrival);
            for i = 1:n
                tempIndex = lBound(i):rBound(i);
                if any(robustWeight(tempIndex) <= 0)
                    tempIndex = FindKNearestNeighbours(span, i, 1:n, (robustWeight > 0));
                end
                wR = WeightedRegression(tempIndex, firstArrival(tempIndex), d, i, robustWeight(tempIndex));
                sf(1,i) = wR.aimValue;
            end
        end
    end
    return
end

function robustWeight = ComputeRobustWeight(residual, y)
    MAD = max(max(abs(y)) * eps * 1e8, median(abs(residual)));
    robustWeight = zeros(size(y), 'like', y);
    tempArray = residual / (6 * MAD);
    tempIndex = abs(tempArray) < 1;
    robustWeight(tempIndex) = (1 - tempArray(tempIndex) .^ 2) .^ 2;
end


function index = FindKNearestNeighbours(span, i, x, in)
    if nnz(in) <= span
        index = find(in);
    else
        d = abs(x - i);
        ds = sort(d(in));
        dk = ds(span);
        close = (d <= dk);
        index = find(close & in);
    end
end