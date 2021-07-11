function PlotWaveAPoint(paraData, paraFirstArrival, acc)
    %% »­Í¼
    figure
    hold on
    sizeData = size(paraData);
    %y = zeros(sizeData(1), 1) - 2;
    x = 0:sizeData(1) - 1;
    for j = 1:sizeData(2)
        %y = y + 2;
        tempData = paraData(:,j) - (paraData(:,j) - abs(paraData(:,j))) / 2;
        %plot(y, x, 'k')
        plot(paraData(:,j) + (j - 1) * 2, x, 'k')
        patch([0 tempData' 0] + (j - 1) * 2, [x(1) x x(end)], 'k')
        if paraFirstArrival(j) ~= 0 && paraFirstArrival(j) > 0 && paraFirstArrival(j) <= size(paraData, 1)
            scatter(paraData(paraFirstArrival(j),j) + (j - 1) * 2, paraFirstArrival(j) - 1, 'r.')
        else
            scatter((j - 1) * 2, 0, 'b.')
        end
    end
    title('accuracy: ' + string(acc))
    xlabel('trace')
    ylabel('sample')
    set(gca, 'XAxisLocation', 'top')
    set(gca, 'YDir', 'reverse')
    xlim([0 sizeData(2) * 2])
end