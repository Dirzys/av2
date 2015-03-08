Img_prev = zeros(1200);
for i = 1:46
    load(strcat('falling_ball_',sprintf('%02d', i),'.mat'));
    Img_bw = imcomplement(im2bw(Img, 0.075));
    props = regionprops(Img_bw, 'Centroid', 'Area', 'Eccentricity', 'PixelList');
%     imshow(Img_bw);
    big = 0;
    for j=1:length(props)
        if props(j).Area > 10000 && props(j).Eccentricity < 0.75
            Img_mask = zeros(1200);
            for k=1:length(props(j).PixelList)
                Img_mask(props(j).PixelList(k,2),props(j).PixelList(k,1)) = 1;
            end
            Img_mask = bwconvhull(Img_mask);
            break
        end
    end
%     imshow(Img_mask);
%     XYZ_new = bsxfun(@times, XYZ, Img_mask);
    XYZ_new = XYZ;
    XYZ_new(~Img_mask(:,:,ones(1, size(XYZ_new,3)))) = 1.3;
    XYZ_new = imresize(XYZ_new, 0.125);
    XYZ = imresize(XYZ, 0.125);
    plot3(XYZ(:,:,1), XYZ(:,:,2), XYZ_new(:,:,3))
    break
end