function [ XYZ ] = maskRangeImage(i)
    WRONG_DEPTH = -1;
    load(strcat('set/falling_ball_',sprintf('%02d', i),'.mat'));
    % First threshold the background
    Img_bw = imcomplement(im2bw(Img, 0.08));
    % Extarct objects
    props = regionprops(Img_bw, 'Area', 'PixelList');
    % Only consider the largest object
    areas = cat(1, props.Area);
    [max_area, i] = max(areas);
    % Create a mask
    Img_mask = zeros(1200);
    for k=1:length(props(i).PixelList)
        Img_mask(props(i).PixelList(k,2),props(i).PixelList(k,1)) = 1;
    end
    
    %Img_mask = bwconvhull(Img_mask);
    
    imshow(Img);
    hold on
    % Apply mask on 3-D range image
    XYZ_depth = XYZ(:,:,3);
    XYZ_depth(~Img_mask) = WRONG_DEPTH;
    XYZ(:,:,3) = XYZ_depth;
end

