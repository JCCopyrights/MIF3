%% Final Results for WPT topology
% Example to try with optimized parameters

addpath('../functions')
N1=6;
r1=15e-3; d1=2*1e-3; h=1.6e-3;
% 3A 45?
%Nmax=r1/(d1*2)
%c=(N>Nmax)*h;%Compensate the inductor height
X = rectangular_planar_inductor(N1,2*r1,2*r1,r1,r1,d1,h,0,0, 0,0,0,0);
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
% Package all the coils in a cell array
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
legend({primary.coil_name},'Location','east')
legend('boxoff')
directives='';
%directives='-i2';
[L,R,Frequency]=fasthenry_runner(fasthenry_creator('SurpriseMotherFucker',coils,freq),directives,false);
%To acces like a semi-functional human being to the matrix => squeeze((L(i,:,:))) squeeze((R(i,:,:)))
disp('Resistance Matrix')
RC=squeeze((R(1,:,:)));
disp(RC);
disp('Inductances Matrix')
LC=squeeze((L(1,:,:)));
disp(LC);
R1=RC(1,1);
L1=LC(1,1);
%Calculate COUPLING for each Coil and Frequency
%Coils are numerated in the order of coils={}
Q1=2*pi*freq*L1/R1;
C1=(1/(2*pi*freq*sqrt(L1)))^2;









