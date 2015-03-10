function drawCentres(centre, radius)
    % Draw centre of the object
    ang = 0:0.01:2*pi; 
    xp = radius*cos(ang);
    yp = radius*sin(ang);
    plot(centre(2)+xp, centre(1)+yp, 'LineWidth', 2, 'Color', [1 0 0]); 
