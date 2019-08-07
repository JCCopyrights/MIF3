%% Example for MIFFF
% This script is a example to run FastHenry2

addpath('../functions')
% Create the different Geometries for each coil
R=15e-3; %All units must be in I.S [m]+
N=10;
d=1e-3;
RES=200; %Resolution for round spirals.
N_Cells_X=2; N_Cells_Y=2;
Cell_size=2*sqrt(2)*R;

%Conductor Propierties and Sizes
freq=200e3;			%Frequency
w=0.5e-3; h=0.5e-3; %Conductor dimensions
rh=10; rw=10; 		%Relation between discretization filaments
mu0=4*pi*1e-7; 		%Permeability
sigma=5.8e7;			%Conductivity (rho=2e-=8)
delta=sqrt(2*(1/sigma)/(2*pi*freq*mu0)); %Skin effect

%Create Coil Array;
for j=1:1:2*N_Cells_Y+1
	for i=1:1:N_Cells_X+1
		X{(N_Cells_X+1)*(j-1)+i} = round_spiral(N, R, d, 0, RES, Cell_size*(i-1)+(1-mod(j,2))*Cell_size/2, Cell_size/2*(j-1), 0, 0, 0, 0);
	end
end
Y{1}=round_spiral(N, R, d, 0, RES, Cell_size*N_Cells_X/2, Cell_size*N_Cells_X/2, Cell_size, 0, 0, 0);

% Visualization of the topology
figure();
hold on;
for i=1:1:length(X)
	plot3(X{i}(1,:),X{i}(2,:),X{i}(3,:),'b');
end
plot3(Y{1}(1,:),Y{1}(2,:),Y{1}(3,:),'r');
grid on
xlabel('X')
ylabel('Y')
zlabel('Z')
title('WPT Topology');
%legend({coil1.coil_name,coil2.coil_name,coil3.coil_name,coil4.coil_name},'Location','east')
%legend('boxoff')

% Optimize the discretization for each coil
% This Parameter affects A LOT simulation times
for i=1:1:length(X)
	[nhinc,nwinc]=optimize_discr(w,h,rh,rw,delta); %The parameters of w,h  .. etc could be unique for each coil
	name=sprintf("coil%d",i);
	coils{i}=generate_coil(name,X{i},sigma,w,h,nhinc,nwinc,rh,rw);
end
[nhinc,nwinc]=optimize_discr(w,h,rh,rw,delta); %The parameters of w,h  .. etc could be unique for each coil
coils{i+1}=generate_coil('load',Y{1},sigma,w,h,nhinc,nwinc,rh,rw);

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