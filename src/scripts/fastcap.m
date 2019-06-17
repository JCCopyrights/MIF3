%% Example for interfacing with FastCap2
% This script is a example to run FastCap2 to extract capacitance.
% The results of the capacitance matrix are not working well @TODO: fIX THIS
addpath('../functions')
N1=6; 
r1=15e-3; d1=2*1e-3; h=[1.8e-3];
X = rectangular_planar_inductor(N1,2*r1,2*r1,r1,r1,d1,h,0,0,0,0,0,0);
%Create the coil structs compatible with FastHenry2
freq=6.79e6;			%Frequency
w1=1e-3; h1=0.0347e-3; %Conductor dimensions 1OZ
rh=2; rw=2; 		%Relation between discretization filaments
mu0=4*pi*1e-7; 		%Permeability
sigma=5.96e7;			%Conductivity (rho=2e-8)
delta=sqrt(2*(1/sigma)/(2*pi*freq*mu0)); %Skin effect
% Optimize the discretization for each coil (In this case is not necesary, equal w,h for every coil)
% This Parameter affects A LOT simulation times
[nhinc,nwinc]=optimize_discr(w1,h1,rh,rw,delta);
primary=generate_coil('primary',X,sigma,w1,h1,nhinc,nwinc,rh,rw);
coils={primary};

% Visualization of the topology
figure();
hold on;
plot3(X(1,:),X(2,:),X(3,:));
grid on
xlabel('X')
ylabel('Y')
zlabel('Z')
title('WPT Topology');

fasthenry_creator('SurpriseMotherFucker',coils,freq);
%capcap('SurpriseMotherFucker.inp',coils);
[C]=fastcap2_runner( fastcap2_creator('SurpriseMotherFucker.inp','SurpriseMotherFucker',4.8, '-f -d0'),'-o1000',true);

disp('Capacitance Matrix')
disp(C);