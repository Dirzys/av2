Img_prev = zeros(1200);
for i = 1:46
    load(strcat('falling_ball_',sprintf('%02d', i),'.mat'));
    Img_bw = imcomplement(im2bw(Img, 0.075));
    props = regionprops(Img_bw, 'Centroid', 'Area', 'Eccentricity', 'PixelList');
%     imshow(Img_bw);
%     hold on;
    big = 0;
    for j=1:length(props)
        if props(j).Area > 10000 && props(j).Eccentricity < 0.75
            Img_mask = zeros(1200);
            for k=1:length(props(j).PixelList)
                Img_mask(props(j).PixelList(k,2),props(j).PixelList(k,1)) = 1;
            end
%             Img_mask = bwconvhull(Img_mask);
            break
        end
    end
    imshow(Img_mask);
%     hold on;
%     plot(props(j).Centroid(1), props(j).Centroid(2), 'rx', 'LineWidth', 10);
    
%     diff = (Img-Img_prev) + 0.5;
%     edged = edge(diff, 'Canny', 0.15);
%     [x, y] = find(edged);
%     x = mean(x);
%     y = mean(y);
%     imshow(diff);
%     hold on
%     viscircles([y, x], 300, 'LineWidth', 1, 'DrawBackgroundCircle', false);
%     hold on;
%     plot(y, x, 'gx');
%     hold on
%     Img_prev = Img;
% %     [centers, radii] = imfindcircles(diff, [290 310], 'Sensitivity', 0.9);
% %     viscircles(centers, radii);
%     pause(1)
end