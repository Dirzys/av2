function [ bestCenterProjected, radius, bestCenter ] = findCenter(maskedRangeImage, radiusLast)
    % RANSAC parameters
    ITER = 200;
    DIST = 0.00001;
    NUM = 4;
    
    % Convert masked range image into two dimensional array
    rangeImage = reshape(maskedRangeImage, size(maskedRangeImage,1)*size(maskedRangeImage,2), size(maskedRangeImage,3));
    % Find masked values
    idx = find(rangeImage(:,3) ~= -1);
    potentialSphere = rangeImage(idx, :);
    
    % RANSAC
    bestInNum = 0; % Best fitting sphere with largest number of inliers
    bestCenter = 0; % Centre for the best fitting sphere
    bestInliers = 0; % Sphere inliers within distance DIST that belongs to the fitted sphere surface 
    for i = 1:ITER
        % Randomly select 4 points that are not in the background
        randIdx = randperm(length(idx), NUM);
        samplesIdx = idx(randIdx);
        
        % Collect information about 4 samples
        samples = rangeImage(samplesIdx, :);
        
        % Fit sphere on collected samples
        [center, radius] = sphereFit(samples);
        
        % Check the number of fitted sphere's surface inliers within
        % distance DIST
        distance = sqrt((potentialSphere(:, 1)-center(1)).^2 + (potentialSphere(:, 2)-center(2)).^2 + (potentialSphere(:, 3)-center(3)).^2);
        inlierIdx = find(distance <= DIST + radius & distance >= radius - DIST); 
        inlierNum = length(inlierIdx);
        
        % If number of inliers increased, then select this sphere as a best
        % currently fitted sphere
        if inlierNum > bestInNum
            bestInNum = inlierNum;
            bestCenter = center;
            bestInliers = inlierIdx;
        end
    end
    
    % Project coordinates of fitted sphere's center onto intensity image
    bestCenterProjected = projectCoordinates(bestCenter');
    
    % Find inlier with the maximum distance from the centre
    % and not considering depth of the point
    maxDistance = 0;
    maxIdx = 0;
    for i=1:length(bestInliers)
        distance = sqrt((potentialSphere(i, 2)-bestCenterProjected(1)).^2 + (potentialSphere(i, 1)-bestCenterProjected(2)).^2);
        if distance > maxDistance
            maxDistance = distance;
            maxIdx = i;
        end
    end
    
    % Project the innermost inlier onto intensity image 
    maxProjected = projectCoordinates([potentialSphere(maxIdx, 1); potentialSphere(maxIdx, 2); potentialSphere(maxIdx, 3)]);
    % Find the radius of the sphere
    radius = sqrt((maxProjected(1)-bestCenterProjected(1)).^2 + (maxProjected(2)-bestCenterProjected(2)).^2);
    
    % Heuristic to limit frame to frame radius variation
    if radiusLast
        radius = (radius + radiusLast) / 2;
    end
    
    plot(bestCenterProjected(1), bestCenterProjected(2), 'r+', 'LineWidth', 5);
    viscircles([bestCenterProjected(1) bestCenterProjected(2)], radius);
end

