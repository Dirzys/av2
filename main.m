for i = 1:46
    maskedRangeImage = maskRangeImage(i);
    [center radius] = findCenter(maskedRangeImage);
    pause(0.01)
end