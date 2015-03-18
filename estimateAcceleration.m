function [ a, v ] = estimateAcceleration( velocities, fps )
% Uses linear regression to estimate acceleration (since it's constant) and
% final velocity
    N = size(velocities,1);
    p = polyfit([1:N]',velocities,1);
    a = p(1) * fps;
    v = a*(N/fps) + p(2);
end