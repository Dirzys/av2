function [ projected ] = projectCoordinates( coordinate )
    % Project 3-D range image coordinate onto 2-D density image
    K = [[4597.95 0 672.846];[0 4603.2 362.875];[0 0 1]];
    p_coordinate = K*coordinate;
    projected = p_coordinate/p_coordinate(3);
end

