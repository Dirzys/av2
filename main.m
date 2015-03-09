for i = 1:46
    maskedRangeImage = maskRangeImage(i);
    center = findCenter(maskedRangeImage);
    pause(0.5)
end