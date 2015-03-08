Img_prev = zeros(1200);
for i = 1:46
    load(strcat('falling_ball_',sprintf('%02d', i),'.mat'));
    diff = (Img-Img_prev) + 0.5;
    edged = edge(diff, 'Canny', 0.15);
    [x, y] = find(edged);
    x = mean(x);
    y = mean(y);
    imshow(diff);
    hold on
    viscircles([y, x], 300, 'LineWidth', 1, 'DrawBackgroundCircle', false);
    hold on;
    plot(y, x, 'gx');
    hold on
%     plot(uint32(x), uint32(y), 'gx');
    Img_prev = Img;
%     [centers, radii] = imfindcircles(diff, [290 310], 'Sensitivity', 0.9);
%     viscircles(centers, radii);
    pause(1)
end