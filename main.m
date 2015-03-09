for i = 1:46
    maskedRangeImage = maskRangeImage(i);
%     figure(1);
%     hold on
%     plot(maskedRangeImage(:, :, 1), maskedRangeImage(:, :, 2))
    maxX = max(max(maskedRangeImage(:, :, 1)));
    minX = min(min(maskedRangeImage(:, :, 1)));
    maxY = max(max(maskedRangeImage(:, :, 2)));
    minY = min(min(maskedRangeImage(:, :, 2)));
    center = findCenter(maskedRangeImage, mean([abs(maxY)+abs(minY) abs(maxX)+abs(minX)]));
    pause(0.5)
end