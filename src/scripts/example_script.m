%% Example for Interface
% This script is a example to run FastHenry2

addpath('../functions')
% Create the different Geometries for each coil
R=15e-3; %All units must be in I.S [m]+
N=10;
d=1e-3;
RES=200; %Resolution for round spirals.
X = round_spiral(N, R/3, d/3, 0, RES, 0, 0, 0, 0, 0, 0);
Y = round_spiral(N, R, d, 0, RES, 0, 0, R, 0, 0, 0);
Z = round_spiral(N, R, d, 0, RES, 0, 0, -R, 0, 0, 0);
A = round_spiral(N, R, d, 0, RES, 0, R, 0, pi/2, 0, 0);

%Create the coil structs compatible with FastHenry2
freq=500e3;			%Frequency
w=0.5e-3; h=0.5e-3; %Conductor dimensions
rh=10; rw=10; 		%Relation between discretization filaments
mu0=4*pi*1e-7; 		%Permeability
sigma=5.96e7; 		%Conductivity
delta=sqrt(2*(1/5.8e7)/(2*pi*freq*mu0)); %Skin effect
% Optimize the discretization for each coil (In this case is not necesary, equal w,h for every coil)
% This Parameter affects A LOT simulation times
[nhinc,nwinc]=optimize_discr(w,h,rh,rw,delta);
coil1=generate_coil('coil1',X,sigma,w,h,nhinc,nwinc,rh,rw);
[nhinc,nwinc]=optimize_discr(w,h,rh,rw,delta);
coil2=generate_coil('coil2',Y,sigma,w,h,nhinc,nwinc,rh,rw);
[nhinc,nwinc]=optimize_discr(w,h,rh,rw,delta);
coil3=generate_coil('coil3',Z,sigma,w,h,nhinc,nwinc,rh,rw);
[nhinc,nwinc]=optimize_discr(w,h,rh,rw,delta);
coil4=generate_coil('coil4',A,sigma,w,h,nhinc,nwinc,rh,rw);
% Package all the coils in a cell array
coils={coil1,coil2,coil3,coil4};

% Visualization of the topology
figure();
hold on;
plot3(X(1,:),X(2,:),X(3,:));
plot3(Y(1,:),Y(2,:),Y(3,:));
plot3(Z(1,:),Z(2,:),Z(3,:));
plot3(A(1,:),A(2,:),A(3,:));
grid on
xlabel('X')
ylabel('Y')
zlabel('Z')
title('WPT Topology');
legend({coil1.coil_name,coil2.coil_name,coil3.coil_name,coil4.coil_name},'Location','east')
legend('boxoff')

% Runs FastHery2 over the topology for freq.
[L,R,Frequency]=fasthenry_runner(fasthenry_creator('SurpriseMotherFucker',coils,freq),'',false);
%To acces like a semi-functional human being to the matrix => squeeze((L(i,:,:))) squeeze((R(i,:,:)))

%Calculate COUPLING for each Coil and Frequency
%Coils are numerated in the order of coils={}
disp('Coupling kij between i and j coil')
for j=1:1:size(Frequency,1)
	Indct=squeeze((L(j,:,:)));
	Rindct=squeeze((R(j,:,:)));
	for i=1:1:size(coils,2)
		for l=1:1:size(coils,2)
			k=Indct(i,l)/sqrt(Indct(i,i)*Indct(l,l));
			%Because disp function is shit
			text = sprintf('k%d%d : %g', i,l,k);
			disp(text)
			%Beware of the signs in the couplings,port polarity issues
		end
	end
end