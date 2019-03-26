%% Calculate parameters for Square Inductors.
% Example to try with optimized parameters

addpath('../functions')
% Create the different Geometries for each coil
R=15e-3; %All units must be in I.S [m]
N1=6; N2=10;
R=15e-3; d=1e-3; 

X = square_spiral(N1, R,R,d, 0, 0, 0, 0, 0, 0);
Y = square_spiral(N2,R/3, R/3,d/6, 0, 0, -R, 0, 0, 0);

%Create the coil structs compatible with FastHenry2
freq=500e3;			%Frequency
w=0.5e-3; h=0.5e-3; %Conductor dimensions
rh=2; rw=2; 		%Relation between discretization filaments
mu0=4*pi*1e-7; 		%Permeability
sigma=5.96e7; 		%Conductivity
delta=sqrt(2*(1/sigma)/(2*pi*freq*mu0)); %Skin effect
% Optimize the discretization for each coil (In this case is not necesary, equal w,h for every coil)
% This Parameter affects A LOT simulation times
[nhinc,nwinc]=optimize_discr(w,h,rh,rw,delta);
primary=generate_coil('primary',X,sigma,w,h,nhinc,nwinc,rh,rw);
[nhinc,nwinc]=optimize_discr(w,h,rh,rw,delta);
secundary=generate_coil('secundary',Y,sigma,w,h,nhinc,nwinc,rh,rw);
% Package all the coils in a cell array
coils={primary,secundary};

% Visualization of the topology
figure();
hold on;
plot3(X(1,:),X(2,:),X(3,:));
plot3(Y(1,:),Y(2,:),Y(3,:));
grid on
xlabel('X')
ylabel('Y')
zlabel('Z')
title('WPT Topology');
legend({primary.coil_name,secundary.coil_name},'Location','east')
legend('boxoff')

[L,R,Frequency]=fasthenry_runner(fasthenry_creator('SurpriseMotherFucker',coils,freq),'',true);
%To acces like a semi-functional human being to the matrix => squeeze((L(i,:,:))) squeeze((R(i,:,:)))

disp('Resistance Matrix')
RC=squeeze((R(1,:,:)));
disp(RC);
disp('Inductances Matrix')
LC=squeeze((L(1,:,:)));
disp(LC);

%Calculate COUPLING for each Coil and Frequency
%Coils are numerated in the order of coils={}
disp('Coupling kij between i and j coil')
for j=1:1:size(Frequency,1)
	Indct=squeeze((L(j,:,:)));
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
