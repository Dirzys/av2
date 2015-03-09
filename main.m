WRONG_DEPTH = -1;

for i = 1:46
    maskedRangeImage = maskRangeImage(i, WRONG_DEPTH);
    center = findCenter(maskedRangeImage);
    pause(1)
end