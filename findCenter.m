function [ bestCenter ] = findCenter(maskedRangeImage)
    ITER = 20000;
    threshDist = 0.0001;
    number = size(maskedRangeImage, 1);
    num = 4;
    bestInNum = 0; % Best fitting sphere with largest number of inliers
    bestCenter = [0, 0, 0]; % centre for the best fitting sphere
    bestRadius = 0;
    bestSamples = 0;
    bestSamples2 = 0;
    for i = 1:ITER
        % Randomly select 5 points that are not in background
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
        
        % Otherwise, collect information about 5 samples
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
            projected_samples = [];
            for j = 1: length(q)
                projected_samples = [projected_samples; q(j) p(j) maskedRangeImage(q(j), p(j), 3)*6000];
            end
            [projected_center, projected_radius] = sphereFit(projected_samples);
            %plot(projected_center(2), projected_center(1), 'r+')
            %pause(0.5)
            bestInNum = inlierNum;
            bestCenter = projected_center;
            bestRadius = projected_radius;
            bestSamples = samples;
            bestSamples2 = projected_samples;
        end
        %break
    end
    plot(bestCenter(2), bestCenter(1), 'r+', 'LineWidth', 10)
%     bestRadius;
%     for j=1:length(bestSamples2)
%         plot(bestSamples2(j, 2), bestSamples2(j, 1), 'g+')
%     end
%     bestSamples;
%     bestSamples2;
end

