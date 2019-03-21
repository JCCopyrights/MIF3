%% Dummy
% Script Just to test different spiral geometrys

addpath('../functions')
figure();
hold on;
%All dimensions are in [m]
%A = round_spiral(10, 5, 0.5, 0, 1000, 0, 0, 0, 0, 0, 0, true);
%A = solenoid_spiral(10,5,1,3*pi/2,0,1000,0,0,0,0,0,0,true);
%A = helix_spiral(10,5,1,0,1000,0,0,0,0,0,0, true);
%A = square_spiral(10,10,10,0.5,0,0,0,0,0,0, true);
%A=round_layer_spiral(5, 5, 0.5, 0, 1000,4,0.1, 0, 0, 0, 0, 0, 0, true);
A=square_layer_spiral(5,10,10,0.5,5,2,0,0,0,0,0,0, true);



