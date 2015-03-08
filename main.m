for i = 1:46
    maskedRangeImage = maskRangeImage(i);
    maskedRangeImage = imresize(maskedRangeImage, 0.125);
    plot3(maskedRangeImage(:,:,1), maskedRangeImage(:,:,2), maskedRangeImage(:,:,3))
    
    %surface = findSurface(maskRangeImage);
    break
end