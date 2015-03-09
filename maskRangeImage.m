function [ XYZ ] = maskRangeImage(i, wrong_depth)
    load(strcat('set/falling_ball_',sprintf('%02d', i),'.mat'));
    Img_bw = imcomplement(im2bw(Img, 0.075));
    props = regionprops(Img_bw, 'Centroid', 'Area', 'Eccentricity', 'PixelList');
%     imshow(Img_bw);
%     hold on
    tic
    big = 0;
    for j=1:length(props)
        if props(j).Area > 10000 && props(j).Eccentricity < 0.75
            Img_mask = zeros(1200);
            for k=1:length(props(j).PixelList)
                Img_mask(props(j).PixelList(k,2),props(j).PixelList(k,1)) = 1;
            end
            imshow(Img_mask);
            hold on
            tic
            Img_mask = bwconvhull(Img_mask);
            toc
            break
        end
    end
    toc
%     imshow(Img_mask);
%     XYZ_new = bsxfun(@times, XYZ, Img_mask);
    XYZ_depth = XYZ(:,:,3);
    XYZ_depth(~Img_mask) = wrong_depth;
    XYZ(:,:,3) = XYZ_depth;
end

