function [ bestCenter ] = findCenter(maskedRangeImage)
    ITER = 50000;
    threshDist = 0.00001;
    number = size(maskedRangeImage, 1);
    num = 4;
    bestInNum = 0; % Best fitting sphere with largest number of inliers
    bestCenter = [0, 0, 0]; % centre for the best fitting sphere
    bestInliers = 0;
    for i = 1:ITER
        % Randomly select 4 points that are not in background
        k = randperm(number/2*(number-1),num);
        q = floor(sqrt(8*(k-1) + 1)/2 + 3/2);
        p = k - (q-1).*(q-2)/2;
        bad_sample = 0;
        for j = 1: length(q)
            depth = maskedRangeImage(q(j), p(j), 3);
            if depth < 0
                bad_sample = 1;
                break
            end
        end
        
        % If selected point that is background - try again
        if bad_sample == 1
            continue
        end
        
        % Otherwise, collect information about 4 samples
        samples = [];
        for j = 1: length(q)
            samples = [samples; maskedRangeImage(q(j), p(j), 1) maskedRangeImage(q(j), p(j), 2) maskedRangeImage(q(j), p(j), 3)];
        end
        % Fit sphere
        [center, radius] = sphereFit(samples);
        
        distance = sqrt((maskedRangeImage(:, :, 1)-center(1)).^2 + (maskedRangeImage(:, :, 2)-center(2)).^2 + (maskedRangeImage(:, :, 3)-center(3)).^2);
        inlierIdx = find(distance <= threshDist + radius & distance >= radius - threshDist); 
        inlierNum = length(inlierIdx);
        
        if inlierNum > bestInNum
            bestInNum = inlierNum;
            bestCenter = center;
            bestInliers = inlierIdx;
        end
        %break
    end
    %bestCenter
    K=[[4597.95 0 672.846];[0 4603.2 362.875];[0 0 1]];
    x_img = K*bestCenter';
    x_final = x_img/x_img(3);
    
    maxDistance = 0;
    maxRow = 0;
    maxCol = 0;
    
    for i=1:length(bestInliers)
        col = idivide(int32(bestInliers(i)), int32(1200), 'ceil');
        row = mod(bestInliers(i),1200);
        distance = sqrt((maskedRangeImage(row, col, 2)-bestCenter(1)).^2 + (maskedRangeImage(row, col, 1)-bestCenter(2)).^2);
        if distance > maxDistance
            maxDistance = distance;
            maxRow = row;
            maxCol = col;
        end
    end
    x_inlier = K*[maskedRangeImage(maxRow, maxCol, 1); maskedRangeImage(maxRow, maxCol, 2); maskedRangeImage(maxRow, maxCol, 3)];
    x_inlier_final = x_inlier/x_inlier(3);
    maxDistance = sqrt((x_inlier_final(1)-x_final(1)).^2 + (x_inlier_final(2)-x_final(2)).^2);
    
    plot(x_final(1), x_final(2), 'g+', 'LineWidth', 10);
%     for j=1:length(bestSamples2)
%         plot(bestSamples2(j, 2), bestSamples2(j, 1), 'g+')
%     end
    viscircles([x_final(1) x_final(2)],maxDistance);
end

