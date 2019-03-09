addpath('../functions')
%A = round_spiral(10, 5, 0.5, 0, 1000, 0, 0, 0, 0, 0, 0);
A = solenoid_spiral(10,5,1,3*pi/2,0,1000,0,0,0,0,0,0);
%A = helix_spiral(10,5,1,0,1000,0,0,0,0,0,0);
%A = square_spiral(10,10,10,0.5,0,0,0,0,0,0);
figure();
hold on;
plot3(A(1,:),A(2,:),A(3,:));
grid on
xlabel('X')
ylabel('Y')
zlabel('Z')
title('WPT Topology');
axis([-10 10 -10 10 -10 10]);
