radius = 0;
last_y = [];
last_v = 0;
a_sum = 0;
a_count = 0;
for i = 1:46
    maskedRangeImage = maskRangeImage(i);
    [center, radius] = findCenter(maskedRangeImage, radius);
    text(1190,20,strcat('Frame #', num2str(i)),'Color','white','HorizontalAlignment','right');
    if i >= 2
        v = center(2) - last_y;
        text(20,20,strcat('Instantaneous downward velocity v=', num2str(v)),'Color','white');
        if i >= 3
            a = v - last_v;
            a_sum = a_sum + a;
            a_count = a_count + 1;
            a_avg = a_sum / a_count;
            text(20,50,strcat('Estimated downward acceleration a=', num2str(a_avg)),'Color','white');
        end
        last_v = v;
    end
    last_y = center(2);
    pause(0.01)
end