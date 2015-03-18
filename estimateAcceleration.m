function [ a ] = estimateAcceleration( velocities, fps )
% Uses linear regression to estimate acceleration (since it's constant)
    N = size(velocities,1);
    p = polyfit([1:N]',velocities,1);
    a = p(1) * fps;
end