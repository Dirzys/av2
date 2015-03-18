FRAMES = 46;

fps = 1000;
radius = 0;
last_y = 0; % meters

v_s = zeros(FRAMES-1,1); % vector of velocities (m/s)

for i = 1:FRAMES
    maskedRangeImage = maskRangeImage(i);
    [center, radius, bestCenter] = findCenter(maskedRangeImage, radius);

    % print frame number
    text(20,1170,strcat('Frame #', num2str(i)),'Color','white','fontname','fixedwidth');
    
    if i >= 2
        
        % calculate velocity (frame-to-frame)
        v = fps*(bestCenter(2) - last_y);
        v_s(i-1) = v;
        
        % print frame-to-frame velocity
        text(20,30,strcat('Measured  v=', num2str(v),' m/s'),'Color','white','fontname','fixedwidth');

        if i >= 3
            % estimate acceleration and actual velocity
            [ a, v_est ] = estimateAcceleration(v_s(1:i-1), fps);
            
            % print estimates
            text(20,70,strcat('Estimated v=', num2str(v_est),' m/s'),'Color','white','fontname','fixedwidth');
            text(20,110,strcat('Estimated a=', num2str(a),' m/s^2'),'Color','white','fontname','fixedwidth');
        end
    end
    
    % save last y coordinate
    last_y = bestCenter(2);
    pause(0.5)
end

% print final estimates
text(200,400,strcat('Final velocity v=', num2str(v_est),' m/s'),'Color','white','fontname','fixedwidth');
text(200,450,strcat('Acceleration estimate a=', num2str(a),' m/s'),'Color','white','fontname','fixedwidth');
