FRAMES = 46;

fps = 1000;
radius = 0;
last_y = 0; % meters
last_v = 0; % m/s
a_sum = 0;
a_count = 0;
y_positions = zeros(FRAMES,1);
v_s = zeros(FRAMES-1,1);
% a = 1000 m/s^2 in test
% test = [0.0005, 0.002, 0.0045, 0.008, 0.0125, 0.018, 0.0245, 0.032, 0.0405, 0.05, 0.0605, 0.072, 0.0845, 0.098, 0.1125, 0.128, 0.1445, 0.162, 0.1805, 0.2, 0.2205, 0.242, 0.2645, 0.288, 0.3125, 0.338, 0.3645, 0.392, 0.4205, 0.45, 0.4805, 0.512, 0.5445, 0.578, 0.6125, 0.648, 0.6845, 0.722, 0.7605, 0.8, 0.8405, 0.882, 0.9245, 0.968, 1.0125, 1.058];
for i = 1:FRAMES
    maskedRangeImage = maskRangeImage(i);
    [center, radius, bestCenter] = findCenter(maskedRangeImage, radius);
    y_positions(i) = bestCenter(2);
    text(20,1170,strcat('Frame #', num2str(i)),'Color','white','fontname','fixedwidth');
    
    if i >= 2
%         v = fps*(test(i) - last_y);
        v = fps*(bestCenter(2) - last_y);
        v_s(i-1) = v;
        text(20,30,strcat('Measured  v=', num2str(v),' m/s'),'Color','white','fontname','fixedwidth');
        if i >= 3
            [ a, v_est ] = estimateAcceleration(v_s(1:i-1), fps);
            text(20,70,strcat('Estimated v=', num2str(v_est),' m/s'),'Color','white','fontname','fixedwidth');
            text(20,110,strcat('Estimated a=', num2str(a),' m/s^2'),'Color','white','fontname','fixedwidth');
        end
        last_v = v;
    end
    last_y = bestCenter(2);
%     last_y = test(i);
    text(200,400,strcat('Final velocity v=', num2str(v_est),' m/s'),'Color','white','fontname','fixedwidth');
    text(200,450,strcat('Acceleration estimate a=', num2str(a),' m/s'),'Color','white','fontname','fixedwidth');
    pause(0.5)
end
