classdef FirstArrivalTools
    methods(Static)       
        function data = DimensionConversion1(paraData)
            %% 
            sizeData = size(paraData);
            dimData = ndims(paraData);
            if dimData == 2
                data = zeros(sizeData(1) * sizeData(2), 1);
                for j = 1:sizeData(2)
                    data((j - 1) * sizeData(1) + 1: j * sizeData(1)) = paraData(:, j);
                end
            elseif dimData == 3
                data = zeros(sizeData(1) * sizeData(2), sizeData(3));
                for j = 1:sizeData(2)
                    data((j - 1) * sizeData(1) + 1: j * sizeData(1), :) = paraData(:, j, :);
                end
            end
            return
        end
        
        function data = DimensionConversion2(paraData, paraSizeData)
            %%
            sizeData = size(paraData);
            data = zeros(paraSizeData(1), paraSizeData(2), sizeData(2));
            for j = 1:paraSizeData(2)
                data(:, j, :) = paraData((j - 1) * paraSizeData(1) + 1: j * paraSizeData(1), :);
            end
            return
        end
        
        function label = GetLabel(paraMemDegMat)
            %% 
            [~,label]=max(paraMemDegMat, [], 2);
            return
        end
        
        function firstArrivals = GetFirstArrivals(paraLabel)
            %% 
            maxLabel = max(paraLabel, [], 'all');
            sizeLabel = size(paraLabel);
            firstArrivals = zeros(maxLabel, sizeLabel(2)) - 1;
            for i = 1:maxLabel
                for j = 1:sizeLabel(2)
                    tempFirstArrival = find(paraLabel(:,j) == i);
                    if ~isempty(tempFirstArrival)
                        firstArrivals(i,j) = tempFirstArrival(1);
                    else
                        firstArrivals(i,j) = 0;
                    end
                end
            end
            return
        end
    end
end